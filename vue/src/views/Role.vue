<template>
  <div class="role-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <i class="el-icon-s-custom icon-lg"></i>
        </div>
        <div class="header-text">
          <h1>角色管理</h1>
          <p>管理系统角色信息，包括添加、编辑、删除和分配菜单</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ total }}</span>
            <span class="stat-label">角色总数</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 200px;" placeholder="请输入名称" v-model="name" prefix-icon="el-icon-search"></el-input>
        <el-button type="primary" @click="load" class="el-icon-search">搜索</el-button>
        <el-button type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="action-section">
      <el-button type="success" class="el-icon-plus" @click="save">新增</el-button>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除这些数据吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" class="el-icon-delete">批量删除</el-button>
      </el-popconfirm>
    </div>

    <!-- 角色表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>角色列表</h3>
        <span class="table-count">{{ tableData.length }} 个角色</span>
      </div>
      <el-table 
        :data="tableData" 
        border 
        stripe 
        @selection-change="handleSelectionChange"
        :row-class-name="tableRowClassName"
        style="width: 100%"
      >
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="name" label="角色名称" min-width="150"></el-table-column>
        <el-table-column prop="code" label="角色编码" min-width="150"></el-table-column>
        <el-table-column prop="description" label="描述" min-width="200"></el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="success" 
              size="small" 
              class="el-icon-menu"
              @click="selectMenuByRole(scope.row)"
              title="分配菜单"
            ></el-button>
            <el-button 
              type="primary" 
              size="small" 
              class="el-icon-edit"
              @click="handleEdit(scope.row)"
              title="编辑"
            ></el-button>
            <el-popconfirm
                confirm-button-text='确定'
                cancel-button-text='取消'
                icon="el-icon-info"
                icon-color="red"
                title="确定删除这些数据吗？"
                @confirm="handleDelete(scope.row.id)"
                @cancel="cancel">
              <el-button 
                slot="reference" 
                type="danger" 
                size="small" 
                class="el-icon-delete"
                title="删除"
              ></el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <div v-if="tableData.length === 0" class="empty-state">
        <el-empty description="暂无角色数据" />
      </div>
      
      <!-- 分页 -->
      <div class="pagination-section">
        <el-pagination
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-sizes="[5, 10, 15, 20]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="total">
        </el-pagination>
      </div>
    </div>

    <!-- 角色信息对话框 -->
    <el-dialog 
      title="角色信息" 
      :visible.sync="dialogFormVisible" 
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" :rules="rules" ref="roleForm">
        <el-form-item label="角色名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off" placeholder="请输入角色名称"></el-input>
        </el-form-item>
        <el-form-item label="角色编码" :label-width="formLabelWidth" prop="code">
          <el-input v-model="form.code" autocomplete="off" placeholder="请输入角色编码"></el-input>
        </el-form-item>
        <el-form-item label="描述" :label-width="formLabelWidth">
          <el-input v-model="form.description" autocomplete="off" placeholder="请输入描述"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAdd">确定</el-button>
      </div>
    </el-dialog>

    <!-- 分配菜单对话框 -->
    <el-dialog title="分配菜单" :visible.sync="menuVisible" width="400px">
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
            <i :class="data.icon" style="font-size: 18px"></i>
            <span style="padding-left: 12px;font-size: 16px">{{ data.name }}</span>
          </span>
        </el-tree>
      <div slot="footer" class="dialog-footer">
        <el-button @click="menuVisible = false">取消</el-button>
        <el-button type="primary" @click="saveRoleMenu">确定</el-button>
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
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
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
.role-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  min-height: calc(100vh - 120px);
}

/* 页面标题 */
.page-header {
  margin-bottom: 30px;
  padding: 25px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  color: white;
  animation: fadeInUp 0.6s ease-out;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-icon {
  margin-right: 20px;
}

.icon-lg {
  font-size: 2.5rem;
  opacity: 0.9;
}

.header-text {
  flex: 1;
}

.header-text h1 {
  font-size: 2rem;
  font-weight: bold;
  margin-bottom: 8px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.header-text p {
  font-size: 1.1rem;
  opacity: 0.9;
  margin: 0;
}

.header-stats {
  display: flex;
  gap: 20px;
}

.stat-item {
  text-align: center;
  padding: 15px 20px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 8px;
  backdrop-filter: blur(10px);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-number {
  display: block;
  font-size: 1.8rem;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  display: block;
  font-size: 0.9rem;
  opacity: 0.8;
}

/* 搜索栏 */
.search-section {
  margin-bottom: 20px;
}

.search-card {
  background: white;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
  display: flex;
  align-items: center;
  gap: 15px;
  transition: box-shadow 0.3s ease;
}

.search-card:hover {
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
}

.search-card .el-input {
  flex: 1;
  max-width: 250px;
}

.search-card .el-button {
  transition: transform 0.2s ease;
}

.search-card .el-button:hover {
  transform: translateY(-2px);
}

/* 操作按钮 */
.action-section {
  display: flex;
  margin-bottom: 20px;
  gap: 10px;
  align-items: center;
}

.action-section .el-button {
  transition: all 0.3s ease;
  border-radius: 6px;
}

.action-section .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

/* 角色表格 */
.table-section {
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.08);
  overflow: hidden;
  animation: fadeIn 0.5s ease-out;
}

.table-header {
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #f8f9fa;
}

.table-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
}

.table-count {
  font-size: 0.9rem;
  color: #666;
  background: #e9ecef;
  padding: 4px 12px;
  border-radius: 12px;
}

.table-section .el-table {
  border-radius: 0;
}

.table-section .el-table th {
  background: #f8f9fa;
  font-weight: 600;
  color: #333;
}

.table-section .el-table tr:hover {
  background-color: #f5f7fa;
}

.row-hover {
  transition: background-color 0.3s ease;
}

/* 空状态 */
.empty-state {
  padding: 60px 0;
  text-align: center;
}

/* 分页 */
.pagination-section {
  padding: 20px;
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid #f0f0f0;
}

/* 对话框 */
.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.dialog-footer .el-button {
  border-radius: 6px;
  transition: all 0.3s ease;
}

.dialog-footer .el-button:hover {
  transform: translateY(-1px);
}

/* 动画效果 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .role-container {
    padding: 10px;
  }
  
  .page-header {
    padding: 20px;
  }
  
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .header-text h1 {
    font-size: 1.6rem;
  }
  
  .header-stats {
    width: 100%;
    justify-content: space-around;
  }
  
  .search-card {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-card .el-input {
    width: 100% !important;
    max-width: none;
  }
  
  .action-section {
    flex-wrap: wrap;
  }
  
  .table-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .table-section {
    padding: 0;
  }
  
  .table-section .el-table {
    font-size: 0.9rem;
  }
  
  .table-section .el-table th,
  .table-section .el-table td {
    padding: 10px 8px;
  }
  
  .pagination-section {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .role-container {
    padding: 5px;
  }
  
  .page-header {
    padding: 15px;
  }
  
  .header-text h1 {
    font-size: 1.4rem;
  }
  
  .stat-item {
    padding: 10px 15px;
  }
  
  .stat-number {
    font-size: 1.5rem;
  }
  
  .search-card {
    padding: 15px;
  }
  
  .table-header {
    padding: 15px;
  }
}
</style>
