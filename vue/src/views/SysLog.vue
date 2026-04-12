<template>
  <div class="syslog-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <i class="el-icon-notebook-1 icon-lg"></i>
        </div>
        <div class="header-text">
          <h1>日志管理</h1>
          <p>管理系统操作日志，包括查看、搜索和筛选</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ total }}</span>
            <span class="stat-label">日志总数</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 200px;" placeholder="请输入操作用户名称" v-model="username" prefix-icon="el-icon-user"></el-input>
        <el-input style="width: 200px;" placeholder="请输入操作类型" v-model="type" prefix-icon="el-icon-info"></el-input>
        <el-button type="primary" @click="load" class="el-icon-search">搜索</el-button>
        <el-button type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
      </div>
    </div>

    <!-- 日志表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>操作日志列表</h3>
        <span class="table-count">{{ tableData.length }} 条日志</span>
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
        <el-table-column prop="username" label="操作用户" min-width="120"></el-table-column>
        <el-table-column prop="record" label="操作记录" min-width="300"></el-table-column>
        <el-table-column prop="type" label="操作类型" min-width="120"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" min-width="180"></el-table-column>
      </el-table>
      <div v-if="tableData.length === 0" class="empty-state">
        <el-empty description="暂无日志数据" />
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
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
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
.syslog-container {
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

/* 日志表格 */
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
  .syslog-container {
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
  .syslog-container {
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