<template>
  <div>
    <div>
      <!--      搜索栏-->
      <el-input  style="width: 200px;margin-right: 20px" placeholder="请输入名称" v-model="name" prefix-icon="el-icon-user"></el-input>
      <el-button style="margin-left: 10px;" type="primary" @click="load" class="el-icon-search">搜索</el-button>
      <el-button style="margin-left: 10px;" type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
    </div>

    <div style="margin-top:20px;margin-bottom: 20px;">
      <!--      新增批量删除-->
      <el-button style="margin-right: 10px;" type="success"  class="el-icon-plus" @click="save">新增</el-button>
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
      <el-table-column prop="name" label="角色名称"></el-table-column>
      <el-table-column prop="code" label="角色编码"></el-table-column>
      <el-table-column prop="description" label="描述"></el-table-column>
      <el-table-column  label="操作" width="400">
        <template slot-scope="scope">
          <el-button  type="success"  class="el-icon-menu" @click="selectMenuByRole(scope.row)">分配菜单</el-button>
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

    <el-dialog title="角色信息" :visible.sync="dialogFormVisible" width="30%">
      <el-form :model="form" :rules="rules">
        <el-form-item label="角色名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="角色编码" :label-width="formLabelWidth" prop="code">
          <el-input v-model="form.code" autocomplete="off"></el-input>
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

    <el-dialog title="分配菜单" :visible.sync="menuVisible" width="23%">
        <el-tree
            :data="menuData"
            show-checkbox
            node-key="id"
            ref="tree"
            default-expand-all
            :default-checked-keys="checks"
            :props="props"
            :expand-on-click-node="false">
          <span class="custom-tree-node" slot-scope="{ node, data }">
            <i :class="data.icon" style="font-size: 25px"></i>
            <span style="padding-left: 12px;font-size: 25px">{{ data.name }}</span>
          </span>
        </el-tree>
      <div slot="footer" class="dialog-footer">
        <el-button @click="menuVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveRoleMenu">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "Role",
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
      user:localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : {},
      menuData:[],
      roleId:null,
      checks:[],
      props: {
        children: 'children',
        label: 'name'
      },
      rules: {
        name: [
          {required: true, message: '请输入角色名', trigger: 'blur'}
        ],
        code: [
          {required: true, message: '请输入用户编码', trigger: 'blur'}
        ],
      }
    }
  },
  created() {
    this.load();
  },
  methods:{
    load(){
      this.request.get("/role/findPage",{
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
      this.request.post("/role/save",this.form).then(res => {
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
        this.request.delete('/role/deleteById/' + id).then(res => {
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
      this.request.post('/role/deleteBatch',ids).then(res => {
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
      this.request.get("/role/findPage",{
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
    //展示树形菜单信息和该角色已经勾选的菜单信息
    selectMenuByRole(row){
      this.roleId = row.id;

      this.request.post('/role/selectMenuByRole/' + this.roleId).then(res => {
        this.checks = res.data
        this.request.get('/menu/findAllMenuId').then(res => {
          const allIdList = res.data;
          allIdList.forEach(id => {
            if(!this.checks.includes(id)){
              this.$refs.tree.setChecked(id,false);
            }
          })
        })
      })
      this.menuVisible = true;

      this.request.get('/menu/findAll').then(res => {
        this.menuData = res.data;
      })
    },
    saveRoleMenu(){
      let menuIds = this.$refs.tree.getCheckedKeys();
      this.request.post("/role/saveRoleMenu/" + this.roleId,menuIds).then(res => {
        if(res.code === '200'){
          if(this.user.roleId === this.roleId){
            this.request.post('/user/logout').then(res => {
              if(res.code === '200'){
                this.$store.commit('logout');
                this.$message.success('保存菜单成功，请重新登录');
              }else{
                this.$message.error('保存菜单成功，但是退出登录失败，请联系管理员');
              }
            })
          }else{
            this.$message.success("保存菜单成功");
          }
          this.menuVisible = false;
        }else{
          this.$message.error(res.msg);
        }
      })

    }
  }
}
</script>

<style scoped>

</style>
