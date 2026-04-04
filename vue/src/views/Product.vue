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
      <!-- 新增。批量删除 -->
      <el-button style="margin-right: 10px;" type="success" class="el-icon-plus" @click="save">新增</el-button>
    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass"
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="name" label="产品名称"></el-table-column>
      <el-table-column prop="origin" label="产地"></el-table-column>
      <el-table-column prop="manufacturer" label="厂家"></el-table-column>
      <el-table-column prop="traceCode" label="产品码"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button class="el-icon-edit" @click="showSendDialog(scope.row)">发货</el-button>
          <el-button type="primary" class="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
          <el-popconfirm
              confirm-button-text='确定'
              cancel-button-text='取消'
              icon="el-icon-info"
              icon-color="red"
              title="确定删除这些数据吗？"
              @confirm="handleDelete(scope.row.id)"
              @cancel="cancel">
            <el-button slot="reference" type="danger" style="margin-left:5px;" class="el-icon-delete">删除</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>

    <div class="block" style="padding:10px 0;align-content: center;margin-left: 30%;margin-top:30px;">
    </div>

    <el-dialog title="产品信息" :visible.sync="dialogFormVisible" width="30%">
      <!-- 核心修复：增加ref="productForm"，用于触发表单验证 -->
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
    <el-dialog title="发货" :visible.sync="sendDialogVisible" width="30%" >
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
import {addProduct, deleteProduct, getAllProduct, updateProduct} from "@/http/Product";
import {generateUUID} from "@/utils/uuid";
import {addWarehouse} from "@/http/Warehouse";

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
      multipleSelection: [],
      total: 0,
      rules: {
        'name': [
          {required: true, message: '请输入产品名称', trigger: 'blur'}
        ],
        'origin': [
          {required: true, message: '请输入产地', trigger: 'blur'}
        ],
        'manufacturer': [
          {required: true, message: '请输入厂家', trigger: 'blur'}
        ],
      },
      sendRules: {
        'amount': [{required: true, message: '请输入发货数量', trigger: 'blur'}]
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
        if(!valid)
          return;
        let params = {
          id:generateUUID(),
          traceCode: this.sendRow.traceCode,
          productId: this.sendRow.traceCode,
          amount: this.sendForm.amount,
          sendDate: new Date().toLocaleString(),
          origin: this.sendRow.origin,
          name:this.sendRow.name,
          recvDate:''
        }
        addWarehouse(params).then(res => {
          this.$message.success('发货成功');
          this.sendDialogVisible = false;
        });
      })
    },
    async load() {
      // 核心修复：增加try/catch捕获加载失败
      try {
        const res = await getAllProduct();
        this.rowTableData = res;
        this.tableData = res;
        // 新增：无数据时提示，提升体验
        if (res.length === 0) {
          this.$message.info('当前暂无产品数据');
        }
      } catch (err) {
        this.$message.error('加载产品列表失败：' + (err.message || '未知错误'));
        this.rowTableData = [];
        this.tableData = [];
      }
    },
    getRowClass({rowIndex, columnIndex}) {
      if (rowIndex === 0) {
        return 'background:#ccc'
      }
    },
    async filterName(){
      await this.load();
      if(!this.name)
        return;
      this.tableData = this.tableData.filter(item => {
        return item.name==(this.name);
      });
    },
    reset() {
      this.name = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      // 修复：重置为初始空对象，与data中定义的结构一致
      this.form = {
        name: '',
        origin: '',
        manufacturer: '',
        traceCode: '',
        id: ''
      };
      // 重置表单验证状态（避免编辑后新建，残留验证提示）
      this.$nextTick(() => {
        this.$refs.productForm?.clearValidate();
      });
    },
    handleAdd() {
      // 核心修复1：调用表单验证，空值不允许提交
      this.$refs.productForm.validate((valid) => {
        if (!valid) {
          return; // 验证失败，直接返回
        }
        if (!this.form.id) {
          // 新建产品逻辑
          this.form.id = generateUUID();
          this.form.traceCode = generateUUID();
          addProduct(this.form).then(res => {
            this.dialogFormVisible = false;
            this.$message.success('产品新建成功！'); // 新增：成功提示
            this.load(); // 刷新列表
          }).catch(err => {
            // 核心修复2：捕获报错，提示用户
            this.$message.error('产品新建失败：' + (err.message || '合约调用异常'));
          });
        } else {
          // 编辑产品逻辑（顺带完善，增加提示和捕获）
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
    handleDelete(id) {
      if (id) {
        deleteProduct(id).then(res => {
          this.load();
        });
      } else {
        this.$message.error('没有id信息，无法删除');
      }
    },
    cancel() {
      this.$message.success('取消操作成功');
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    deleteBatch() {
      // 批量删除数据
      if (this.multipleSelection.length === 0) {
        this.$message.warning("请先选择要删除的数据");
        return
      }
      const ids = this.multipleSelection.map(v => v.id);
      this.request.post('/product/deleteBatch', ids).then(res => {
        if (res.code === '200') {
          this.$message.success('批量删除成功');
          this.handleCalPageNum();
        } else {
          let msg = res.msg;
          this.$message.error(msg);
        }
      })
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
    }
  }
}
</script>

<style scoped>

</style>
