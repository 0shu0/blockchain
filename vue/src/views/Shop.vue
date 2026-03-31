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
      <el-table-column prop="name" label="产品名称"></el-table-column>
      <el-table-column prop="origin" label="产地"></el-table-column>
      <el-table-column prop="amount" label="数量"></el-table-column>
      <el-table-column prop="price" label="上架价格"></el-table-column>
      <el-table-column prop="listDate" label="上架日期"></el-table-column>
      <el-table-column prop="sendDate" label="发货日期"></el-table-column>
      <el-table-column prop="recvDate" label="收货日期"></el-table-column>
      <el-table-column label="操作" width="200">
        <template slot-scope="scope">
          <el-button type="primary" class="el-icon-edit" :disabled="!scope.row.recvDate==''" @click="handleRecv(scope.row)">收货</el-button>
          <el-button type="primary" class="el-icon-edit" @click="showListDlg(scope.row)" :disabled="!scope.row.listDate==''||scope.row.recvDate==''">上架</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog title="上架" :visible.sync="dialogFormVisible" width="30%" :before-close="cancel">
      <el-form :model="form" :rules="rules" label-width="80px" ref="form">
        <el-form-item label="上架价格" prop="price">
          <el-input v-model="form.price" placeholder="请输入上架价格"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleList">确定</el-button>
        <el-button @click="dialogFormVisible = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {getAllShop, updateShop} from "@/http/Shop";

export default {
  name: "${table.entityName}",
  data() {
    return {
      pageSize: 10,
      pageNum: 1,
      name: '',
      tableData: [],
      currentRow:{},
      dialogFormVisible: false,
      form: {
        price:''
      },
      formLabelWidth: '80px',
      multipleSelection: [],
      total: 0,
      rules: {

        'price': [
          {required: true, message: '请输入', trigger: 'blur'}
        ],

      }
    }
  },
  created() {
    this.load();
  },
  methods: {
    async filterName(){
      await this.load();
      this.tableData = this.tableData.filter(item => {
        return item.name==(this.name);
      });
    },
    handleRecv(row){
      row.recvDate = new Date().toLocaleString();
      row.price=row.price==''?null:row.price;
      updateShop(row).then(res => {
        this.load();
      })
    },
    showListDlg(row){
      this.currentRow = row;
      this.dialogFormVisible = true;
    },
    handleList(){
      this.$refs.form.validate(valid=>{
        if(!valid)
          return;
        this.currentRow.price = this.form.price;
        this.currentRow.listDate =new Date().toLocaleString();
        updateShop(this.currentRow).then(res => {
          this.$message.success('上架成功');
          this.dialogFormVisible = false;
          this.load();
        })
      })
    },
    async load() {
      await getAllShop().then(res => {
        this.tableData = res;
      });
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
      this.form = {};
    },
    handleAdd() {
      this.request.post("/shop/save", this.form).then(res => {
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
        this.request.delete('/shop/deleteById/' + id).then(res => {
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
      this.request.post('/shop/deleteBatch', ids).then(res => {
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
      this.request.get("/shop/findPage", {
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
