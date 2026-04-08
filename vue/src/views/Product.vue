<template>
  <div>
    <div>
      <!-- 搜索栏 -->
      <el-input style="width: 200px;margin-right: 20px" placeholder="请输入产品名称" v-model="name"
                prefix-icon="el-icon-user"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="filterName" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">
      <!-- 新增按钮和批量删除按钮 -->
      <el-button style="margin-right: 10px;" type="success" class="el-icon-plus" @click="save">新增</el-button>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除选中的产品吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" style="margin-left:5px;" class="el-icon-delete">批量删除</el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="name" label="产品名称"></el-table-column>
      <el-table-column prop="origin" label="产地"></el-table-column>
      <el-table-column prop="manufacturer" label="厂家"></el-table-column>
      <el-table-column prop="traceCode" label="产品码"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button class="el-icon-edit" @click="showSendDialog(scope.row)">发货</el-button>
          <el-button type="primary" class="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="block" style="padding:10px 0;align-content: center;margin-left: 30%;margin-top:30px;">
    </div>

    <el-dialog title="产品信息" :visible.sync="dialogFormVisible" width="30%">
      <el-form :model="form" :rules="rules" ref="productForm">
        <el-form-item label="产品名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="产地" :label-width="formLabelWidth" prop="origin">
          <el-input v-model="form.origin" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="厂家" :label-width="formLabelWidth" prop="manufacturer">
          <el-input v-model="form.manufacturer" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleAdd">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="发货" :visible.sync="sendDialogVisible" width="30%">
      <el-form :model="sendForm" :rules="sendRules" ref="sendForm">
        <el-form-item label="发货数量" :label-width="formLabelWidth" prop="amount">
          <el-input-number v-model="sendForm.amount" :min="1"></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="sendDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleSend">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { addProduct, getAllProduct, updateProduct, deleteProduct } from "@/http/Product";
import { generateUUID } from "@/utils/uuid";
import { addWarehouse } from "@/http/Warehouse";

export default {
  name: "Product",
  data() {
    return {
      sendForm: {
        amount: '',
      },
      sendDialogVisible: false,
      pageSize: 10,
      pageNum: 1,
      name: '',
      rowTableData: [],
      tableData: [],
      dialogFormVisible: false,
      form: {
        name: '',
        origin: '',
        manufacturer: '',
        traceCode: '',
      },
      formLabelWidth: '80px',
      sendRow: {},
      total: 0,
      multipleSelection: [],
      rules: {
        'name': [
          { required: true, message: '请输入产品名称', trigger: 'blur' }
        ],
        'origin': [
          { required: true, message: '请输入产地', trigger: 'blur' }
        ],
        'manufacturer': [
          { required: true, message: '请输入厂家', trigger: 'blur' }
        ],
      },
      sendRules: {
        'amount': [{ required: true, message: '请输入发货数量', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.load();
  },
  methods: {
    showSendDialog(row) {
      this.sendRow = row;
      this.sendDialogVisible = true;
    },
    handleSend(row) {
      this.$refs.sendForm.validate((valid) => {
        if (!valid) return;
        // 检查产品是否为空或缺少必要字段
        if (!this.sendRow || !this.sendRow.traceCode || !this.sendRow.origin || !this.sendRow.name) {
          this.$message.error('产品信息不完整，无法发货');
          return;
        }
        let params = {
          id: generateUUID(),
          traceCode: this.sendRow.traceCode,
          productId: this.sendRow.traceCode,
          amount: this.sendForm.amount,
          sendDate: new Date().toLocaleString(),
          origin: this.sendRow.origin,
          name: this.sendRow.name,
          recvDate: ''
        }
        addWarehouse(params).then(res => {
          this.$message.success('发货成功');
          this.sendDialogVisible = false;
        }).catch(err => {
          this.$message.error('发货失败：' + (err.message || '合约调用异常'));
        });
      })
    },
    async load() {
      try {
        const res = await getAllProduct();
        // 过滤掉空产品（缺少必要字段的产品）
        const validProducts = res.filter(item => item.id && item.name && item.origin && item.traceCode);
        this.rowTableData = validProducts;
        this.tableData = validProducts;
        if (validProducts.length === 0) {
          this.$message.info('当前暂无产品数据');
        }
      } catch (err) {
        this.$message.error('加载产品列表失败：' + (err.message || '未知错误'));
        this.rowTableData = [];
        this.tableData = [];
      }
    },
    getRowClass({ rowIndex, columnIndex }) {
      if (rowIndex === 0) {
        return 'background:#ccc'
      }
    },
    async filterName() {
      await this.load();
      if (!this.name) return;
      this.tableData = this.tableData.filter(item => {
        return item.name === this.name;
      });
    },
    reset() {
      this.name = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      this.form = {
        name: '',
        origin: '',
        manufacturer: '',
        traceCode: '',
      };
      this.$nextTick(() => {
        this.$refs.productForm?.clearValidate();
      });
    },
    handleAdd() {
      this.$refs.productForm.validate((valid) => {
        if (!valid) return;
        if (!this.form.traceCode) {
          this.form.traceCode = generateUUID();
          console.log("生成的traceCode：", this.form.traceCode);
          addProduct(this.form).then(res => {
            this.dialogFormVisible = false;
            this.$message.success('产品新建成功！');
            this.load();
          }).catch(err => {
            this.$message.error('产品新建失败：' + (err.message || '合约调用异常'));
          });
        } else {
          updateProduct(this.form).then(res => {
            this.dialogFormVisible = false;
            this.$message.success('产品编辑成功！');
            this.load();
          }).catch(err => {
            this.$message.error('产品编辑失败：' + (err.message || '合约调用异常'));
          });
        }
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    cancel() {
      this.$message.success('取消操作成功');
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.load();
    },
    handleCurrentChange(val) {
      this.pageNum = val;
      this.load();
    },
    handleCalPageNum() {
      this.request.get("/product/findPage", {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          name: this.name,
        }
      }).then(res => {
        this.total = res.data.total;
        this.pageNum = (this.total % this.pageSize === 0) ? (this.total / this.pageSize) : Math.floor((this.total / this.pageSize) + 1);
        if (this.pageNum < 1) {
          this.pageNum = 1;
        }
        this.load();
      })
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    deleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message.warning("请先选择要删除的产品");
        return;
      }
      // 过滤掉空产品（没有id的产品）
      const validProducts = this.multipleSelection.filter(v => v.id);
      if (validProducts.length === 0) {
        this.$message.warning("所选产品中没有有效的产品ID");
        return;
      }
      const ids = validProducts.map(v => v.id);
      // 批量删除产品
      Promise.all(ids.map(id => deleteProduct(id))).then(() => {
        this.$message.success('批量删除成功');
        this.load();
      }).catch(err => {
        this.$message.error('批量删除失败：' + (err.message || '合约调用异常'));
      });
    },
    cancel() {
      this.$message.success('取消操作成功');
    }
  }
}
</script>

<style scoped>
</style>