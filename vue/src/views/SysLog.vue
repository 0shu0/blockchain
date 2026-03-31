<template>
  <div>
    <div>
      <!--      搜索栏-->
      <el-input  style="width: 200px;margin-right: 20px" placeholder="请输入操作用户名称" v-model="username" prefix-icon="el-icon-user"></el-input>
      <el-input  style="width: 200px;margin-right: 20px" placeholder="请输入操作用户名称" v-model="type" prefix-icon="el-icon-info"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="load" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">

    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="id"></el-table-column>
      <el-table-column prop="username" label="操作用户"></el-table-column>
      <el-table-column prop="record" label="操作记录"></el-table-column>
      <el-table-column prop="type" label="操作类型"></el-table-column>
      <el-table-column prop="createTime" label="创建时间"></el-table-column>
    </el-table>

    <div class="block" style="padding:10px 0;align-content: center;margin-left: 30%;margin-top:30px;">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[5, 10, 15, 20]"
          :page-size="10"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
      </el-pagination>
    </div>
  </div>
</template>

<script>
export default {
  name: "SysLog",
  data(){
    return{
      pageSize:10,
      pageNum:1,
      name:'',
      tableData:[],
      dialogFormVisible:false,
      menuVisible:false,
      form:{},
      formLabelWidth: '80px',
      multipleSelection:[],
      total:0,
      menuData:[],
      checks:[],
      props: {
        children: 'children',
        label: 'name'
      }
    }
  },
  created() {
    this.load();
  },
  methods:{
    load(){
      this.request.get("/sysLog/findPage",{
        params:{
          pageNum:this.pageNum,
          pageSize:this.pageSize,
          username:this.username,
          type:this.type
        }
      }).then(res => {
        this.tableData = res.data.records;
        this.total = res.data.total;
      })
    },
    getRowClass({rowIndex,columnIndex}){
      if(rowIndex === 0){
        return 'background:#ccc'
      }
    },
    reset(){
      this.username = '';
      this.type = '';
      this.load();
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    handleSizeChange(val) {
      this.pageSize = val;
      this.load();
    },
    handleCurrentChange(val) {
      this.pageNum = val;
      this.load();
    },
  }
}
</script>

<style scoped>

</style>