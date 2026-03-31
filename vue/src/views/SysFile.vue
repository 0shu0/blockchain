<template>
  <div>
    <div>
      <!--      搜索栏-->
      <el-input  style="width: 200px;margin-right: 20px" placeholder="请输入名称" v-model="name" prefix-icon="el-icon-user"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="load" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">
      <!--      新增。批量删除-->
      <el-upload
          style="display: inline-block"
          action="http://localhost:8888/sysFile/upload"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
          :on-error="handleAvatarError">
        <el-button style="margin-right: 10px;" type="primary"  class="el-icon-plus">上传文件</el-button>
      </el-upload>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除这些数据吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" style="margin-left:5px;" class="el-icon-delete">批量删除</el-button>
      </el-popconfirm>
    </div>

    <el-table :data="tableData" border stripe :header-cell-style="getRowClass" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="id"></el-table-column>
      <el-table-column prop="name" label="文件名称"></el-table-column>
      <el-table-column prop="type" label="文件类型"></el-table-column>
      <el-table-column prop="size" label="文件大小(kb)"></el-table-column>
      <el-table-column prop="enable" label="是否启用">
        <template slot-scope="scope">
          <el-switch
              v-model="scope.row.enable"
              active-color="#13ce66"
              inactive-color="#ff4949"
              @change="changeEnable(scope.row)"
              :active-value="1"
              :inactive-value="0">
          </el-switch>
        </template>
      </el-table-column>
      <el-table-column  label="操作" width="300">
        <template slot-scope="scope">
          <el-button  type="success"  class="el-icon-view" @click="viewImage(scope.row.url)">预览</el-button>
          <el-button  type="primary"  class="el-icon-download" @click="download(scope.row.url)" v-if="scope.row.enable === 1">下载</el-button>
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

    <el-dialog title="图片信息" :visible.sync="viewVisible" width="30%">
      <img width="100%" :src="dialogImageUrl" alt="图片"/>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "SysFile",
  data(){
    return{
      pageSize:10,
      pageNum:1,
      name:'',
      tableData:[],
      dialogImageUrl:'',
      dialogFormVisible:false,
      viewVisible:false,
      form:{},
      formLabelWidth: '80px',
      multipleSelection:[],
      total:0
    }
  },
  created() {
    this.load();
  },
  methods:{
    viewImage(url){
      this.dialogImageUrl = url;
      this.viewVisible = true;
    },
    changeEnable(row){
      this.request.post('/sysFile/updateEnable',row).then(res => {
        if(res.code === '200'){
          this.$message.success('更新启用状态成功')
        }else{
          this.$message.error('更新启用状态失败')
        }
      })
    },
    load(){
      this.request.get("/sysFile/findPage",{
        params:{
          pageNum:this.pageNum,
          pageSize:this.pageSize,
          name:this.name,
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
      this.name = '';
      this.load();
    },
    save(){
      this.dialogFormVisible = true;
      this.form = {};
    },
    handleAdd(){
      this.request.post("/sysFile/save",this.form).then(res => {
        if(res.code === '200'){
          if(this.form.id){
            this.$message.success('编辑成功');
          }else{
            this.$message.success('新增成功');
          }
          this.dialogFormVisible = false;
          this.load();
        }else{
          this.$message.error(res.msg)
        }
      })
    },
    handleEdit(row){
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(id){
      if(id){
        this.request.delete('/sysFile/deleteById/' + id).then(res => {
          if(res.code === '200'){
            this.$message.success('删除数据成功');
            this.handleCalPageNum();
          }else{
            this.$message.error(res.msg)
          }
        })
      }else{
        this.$message.error('没有id信息，无法删除');
      }
    },
    cancel(){
      this.$message.success('取消操作成功');
    },
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    deleteBatch(){
      //批量删除数据
      if(this.multipleSelection.length === 0){
        this.$message.warning("请先选择要删除的数据");
        return
      }
      const ids = this.multipleSelection.map(v => v.id);
      this.request.post('/sysFile/deleteBatch',ids).then(res => {
        if(res.code === '200'){
          this.$message.success('批量删除成功');
          this.handleCalPageNum();
        }else{
          this.$message.error(res.msg);
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
    handleCalPageNum(){
      this.request.get("/sysFile/findPage",{
        params:{
          pageNum:this.pageNum,
          pageSize:this.pageSize,
          name:this.name,
        }
      }).then(res => {
        this.total = res.data.total;
        this.pageNum = (this.total % this.pageSize === 0) ? (this.total / this.pageSize) : Math.floor((this.total / this.pageSize) + 1);
        if(this.pageNum < 1){
          this.pageNum = 1;
        }
        this.load();
      })
    },
    handleAvatarSuccess(res, file) {
      console.log(res)
      console.log(res)
      console.log(res)
      this.$message.success('上传文件成功!');
      this.load();

    },
    handleAvatarError() {
        this.$message.error('上传文件失败!');
    },
    download(url){
      window.open(url);
    }
  }
}
</script>

<style scoped>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}
.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>