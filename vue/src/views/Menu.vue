<template>
  <div>
    <div>
      <!--      搜索栏-->
      <el-input  style="width: 200px;margin-right: 20px" placeholder="请输入菜单名称" v-model="name" prefix-icon="el-icon-user"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="load" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">
      <!--      新增批量删除-->
      <el-button style="margin-right: 10px;" type="success"  class="el-icon-plus" @click="save(null)">新增</el-button>
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

    <el-table
        :data="tableData" border stripe
        :header-cell-style="getRowClass"
        @selection-change="handleSelectionChange"
        row-key="id"
        border
        default-expand-all>
      <el-table-column type="selection" width="55"></el-table-column>
      <el-table-column prop="id" label="id"></el-table-column>
      <el-table-column prop="name" label="菜单名称"></el-table-column>
      <el-table-column prop="path" label="菜单路径"></el-table-column>
      <el-table-column label="菜单图标">
        <template slot-scope="scope">
          <i :class="scope.row.icon"/>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="菜单描述"></el-table-column>
      <el-table-column prop="pagePath" label="页面路径"></el-table-column>
      <el-table-column prop="sortNum" label="排序"></el-table-column>
      <el-table-column  label="操作" width="350">
        <template slot-scope="scope">
          <el-button  type="success"  class="el-icon-circle-plus" @click="save(scope.row.id)" v-if="!scope.row.pid && !scope.row.path ">新增子菜单</el-button>
          <el-button  type="primary"  class="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
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


    <el-dialog title="菜单信息" :visible.sync="dialogFormVisible" width="30%">
      <el-form :model="form" :rules="rules">
        <el-form-item label="菜单名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="菜单路径" :label-width="formLabelWidth">
          <el-input v-model="form.path" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="菜单图标" :label-width="formLabelWidth">
          <el-select v-model="form.icon" filterable placeholder="请选择图标">
            <el-option
                v-for="dict in dictList"
                :key="dict.name"
                :label="dict.name"
                :value="dict.value">
              <i :class="dict.value"></i>&nbsp;&nbsp;{{dict.name}}
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="页面路径" :label-width="formLabelWidth" >
          <el-input v-model="form.pagePath" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="排序" :label-width="formLabelWidth">
          <el-input v-model="form.sortNum" autocomplete="off" type="number"></el-input>
        </el-form-item>
        <el-form-item label="描述" :label-width="formLabelWidth">
          <el-input v-model="form.description" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleAdd">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "Menu",
  data(){
    return{
      pageSize:10,
      pageNum:1,
      name:'',
      tableData:[],
      dialogFormVisible:false,
      form:{},
      formLabelWidth: '80px',
      multipleSelection:[],
      total:0,
      dictList:[],
      rules: {
        name: [
          {required: true, message: '请输入菜单名称', trigger: 'blur'}
        ],

      }
    }
  },
  created() {
    this.load();
  },
  methods:{
    load(){
      this.request.get("/menu/findAll",{
        params:{
          name:this.name,
        }
      }).then(res => {
        this.tableData = res.data;
      });
      this.request.get("/dict/findAll",{
        params:{
          type:'icon',
        }
      }).then(res => {
        this.dictList = res.data;
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
    save(pid){
      this.dialogFormVisible = true;
      this.form = {};
      if(pid){
        this.form.pid = pid;
      }
    },
    handleAdd(){
      this.request.post("/menu/save",this.form).then(res => {
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
        this.request.delete('/menu/deleteById/' + id).then(res => {
          if(res.code === '200'){
            this.$message.success('删除数据成功');
            this.load();
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
      this.request.post('/menu/deleteBatch',ids).then(res => {
        if(res.code === '200'){
          this.$message.success('批量删除成功');
          this.load();
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
    }
  }
}
</script>

<style scoped>

</style>
