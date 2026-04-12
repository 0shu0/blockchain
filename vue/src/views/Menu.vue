<template>
  <div class="menu-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <i class="el-icon-menu icon-lg"></i>
        </div>
        <div class="header-text">
          <h1>菜单管理</h1>
          <p>管理系统菜单信息，包括添加、编辑、删除和查询</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ tableData.length }}</span>
            <span class="stat-label">菜单总数</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 200px;" placeholder="请输入菜单名称" v-model="name" prefix-icon="el-icon-search"></el-input>
        <el-button type="primary" @click="load" class="el-icon-search">搜索</el-button>
        <el-button type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="action-section">
      <el-button type="success" class="el-icon-plus" @click="save(null)">新增</el-button>
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

    <!-- 菜单表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>菜单列表</h3>
        <span class="table-count">{{ tableData.length }} 个菜单</span>
      </div>
      <el-table 
        :data="tableData" 
        border 
        stripe 
        @selection-change="handleSelectionChange"
        row-key="id"
        default-expand-all
        :row-class-name="tableRowClassName"
        style="width: 100%"
      >
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="name" label="菜单名称" min-width="150"></el-table-column>
        <el-table-column prop="path" label="菜单路径" min-width="150"></el-table-column>
        <el-table-column label="菜单图标" width="100">
          <template slot-scope="scope">
            <i :class="scope.row.icon" style="font-size: 18px;"></i>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="菜单描述" min-width="200"></el-table-column>
        <el-table-column prop="pagePath" label="页面路径" min-width="180"></el-table-column>
        <el-table-column prop="sortNum" label="排序" width="80"></el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="success" 
              size="small" 
              class="el-icon-circle-plus"
              @click="save(scope.row.id)"
              v-if="!scope.row.pid && !scope.row.path"
              title="新增子菜单"
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
        <el-empty description="暂无菜单数据" />
      </div>
    </div>

    <!-- 菜单信息对话框 -->
    <el-dialog 
      title="菜单信息" 
      :visible.sync="dialogFormVisible" 
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" :rules="rules" ref="menuForm">
        <el-form-item label="菜单名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off" placeholder="请输入菜单名称"></el-input>
        </el-form-item>
        <el-form-item label="菜单路径" :label-width="formLabelWidth">
          <el-input v-model="form.path" autocomplete="off" placeholder="请输入菜单路径"></el-input>
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
          <el-input v-model="form.pagePath" autocomplete="off" placeholder="请输入页面路径"></el-input>
        </el-form-item>
        <el-form-item label="排序" :label-width="formLabelWidth">
          <el-input v-model="form.sortNum" autocomplete="off" type="number" placeholder="请输入排序"></el-input>
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
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
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
.menu-container {
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

/* 菜单表格 */
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
  .menu-container {
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
  
  .table-section .el-table .el-button {
    margin-right: 5px;
  }
}

@media (max-width: 480px) {
  .menu-container {
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
