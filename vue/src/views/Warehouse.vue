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
    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass"
              @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="traceCode" label="溯源码"></el-table-column>
      <el-table-column prop="amount" label="发货数量"></el-table-column>
      <el-table-column prop="sendDate" label="发货日期"></el-table-column>
      <el-table-column prop="origin" label="产地"></el-table-column>
      <el-table-column prop="name" label="产品名称"></el-table-column>
      <el-table-column prop="recvDate" label="收货日期"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button type="primary" class="el-icon-edit" @click="handleRecv(scope.row)"
                     :disabled="!scope.row.recvDate == ''">收货
          </el-button>
          <el-button class="el-icon-edit" @click="showSendDialog(scope.row)" :disabled="scope.row.recvDate == ''">发货
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="信息" :visible.sync="dialogFormVisible" width="30%">
      <el-form :model="form" :rules="rules">
        <el-form-item label="溯源码" :label-width="formLabelWidth" prop="traceCode">
          <el-input v-model="form.traceCode" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="发货数量" :label-width="formLabelWidth" prop="amount">
          <el-input v-model="form.amount" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="发货日期" :label-width="formLabelWidth" prop="sendDate">
          <el-input v-model="form.sendDate" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="产地" :label-width="formLabelWidth" prop="origin">
          <el-input v-model="form.origin" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="产品名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="收货日期" :label-width="formLabelWidth" prop="recvDate">
          <el-input v-model="form.recvDate" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleAdd">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="发货信息" :visible.sync="dialogSendVisible" width="30%">
      <el-form :model="sendForm" :rules="sendRules" ref="sendForm">
        <el-form-item label="发货数量" :label-width="formLabelWidth" prop="amount">
          <el-input-number v-model="sendForm.amount" :min="1"></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogSendVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleSend">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {deleteWarehouse, getAllWarehouse, updateWarehouse} from "@/http/Warehouse";
import {addShop} from "@/http/Shop";
import {generateUUID} from "@/utils/uuid";

export default {
  name: "${table.entityName}",
  data() {
    return {
      pageSize: 10,
      pageNum: 1,
      name: '',
      tableData: [],
      dialogFormVisible: false,
      form: {
        traceCode: '',
        amount: '',
        sendDate: '',
        origin: '',
        name: '',
        recvDate: '',
      },
      sendForm:{
        price:'',
        amount:''
      },
      formLabelWidth: '80px',
      multipleSelection: [],
      total: 0,
      rules: {
        'traceCode': [
          {required: true, message: '请输入溯源码', trigger: 'blur'}
        ],
        'amount': [
          {required: true, message: '请输入发货数量', trigger: 'blur'}
        ],
        'sendDate': [
          {required: true, message: '请输入发货日期', trigger: 'blur'}
        ],
        'origin': [
          {required: true, message: '请输入产地', trigger: 'blur'}
        ],
        'name': [
          {required: true, message: '请输入产品名称', trigger: 'blur'}
        ],
        'recvDate': [
          {required: true, message: '请输入收货日期', trigger: 'blur'}
        ],
      },
      sendRules:{
        'amount':[{required:true,message:'请输入发货数量',trigger:'blur'}]
      },
      dialogSendVisible: false,
      sendRow: {},
    }
  },
  created() {
    this.load();
  },
  methods: {
    async filterName(){
      await this.load();
      if(this.name=='')
        return;
      this.tableData = this.tableData.filter(item => {
        return item.name==(this.name);
      });
    },
    handleRecv(row) {
      row.recvDate = new Date().toLocaleString();
      updateWarehouse(row).then(res => {
        this.$message.success('收货成功');
        this.load();
      });
    },
    showSendDialog(row){
      this.sendRow = row;
      this.dialogSendVisible = true;
    },
    handleSend() {
      this.$refs.sendForm.validate((valid) => {
        if (!valid) {
          return;
        }
        let params = {
          productId: this.sendRow.productId,
          traceCode: this.sendRow.traceCode,
          amount: this.sendForm.amount,
          sendDate: new Date().toLocaleString(),
          price: null,
          origin: this.sendRow.origin,
          name: this.sendRow.name,
          listDate:'',
          id:generateUUID(),
          recvDate:''
        };
        addShop(params).then(res=>{
          this.$message.success('发货成功');
          this.dialogSendVisible = false;
          this.load();
        })
      });
    },
    async load() {
      await getAllWarehouse().then(res => {
        this.tableData = res;
      })
    },
    getRowClass({rowIndex, columnIndex}) {
      if (rowIndex === 0) {
        return 'background:#ccc'
      }
    },
    reset() {
      this.name = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      this.form = {};
    },
    handleAdd() {
      this.request.post("/warehouse/save", this.form).then(res => {
        if (res.code === '200') {
          if (this.form.id) {
            this.$message.success('编辑成功');
          } else {
            this.$message.success('新增成功');
          }
          this.dialogFormVisible = false;
          this.load();
        } else {
          let msg = res.msg;
          this.$message.error(msg);
        }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(id) {
      if (id) {
        this.request.delete('/warehouse/deleteById/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除数据成功');
            this.handleCalPageNum();
          } else {
            let msg = res.msg;
            this.$message.error(msg)
          }
        })
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
      this.request.post('/warehouse/deleteBatch', ids).then(res => {
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
      this.request.get("/warehouse/findPage", {
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
