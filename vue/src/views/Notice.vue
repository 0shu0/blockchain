<template>
  <div class="notice-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <img src="../../../file/公告.png" alt="公告管理" class="icon-img">
        </div>
        <div class="header-text">
          <h1>公告管理</h1>
          <p>管理系统公告信息，包括添加、编辑、删除和查询</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ total }}</span>
            <span class="stat-label">公告总数</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 200px;" placeholder="请输入标题" v-model="title" prefix-icon="el-icon-search"></el-input>
        <el-input style="width: 200px;" placeholder="请输入创建者" v-model="user" prefix-icon="el-icon-user"></el-input>
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
        <el-button slot="reference" type="danger" class="el-icon-delete" :disabled="multipleSelection.length === 0">批量删除</el-button>
      </el-popconfirm>
    </div>

    <!-- 公告表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>公告列表</h3>
        <span class="table-count">{{ tableData.length }} 个公告</span>
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
        <el-table-column prop="title" label="公告标题" min-width="200"></el-table-column>
        <el-table-column prop="content" label="公告内容" min-width="300">
          <template slot-scope="scope">
            <div class="notice-content">{{ scope.row.content }}</div>
          </template>
        </el-table-column>
        <el-table-column prop="user" label="创建者" width="120"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="180" fixed="right">
          <template slot-scope="scope">
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
        <el-empty description="暂无公告数据" />
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

    <!-- 公告信息对话框 -->
    <el-dialog 
      title="公告信息" 
      :visible.sync="dialogFormVisible" 
      width="500px"
      @close="handleCancel"
      :close-on-click-modal="false"
    >
      <el-form :model="form" :rules="rules" ref="noticeForm">
        <el-form-item label="公告标题" :label-width="formLabelWidth" prop="title">
          <el-input v-model="form.title" autocomplete="off" placeholder="请输入公告标题"></el-input>
        </el-form-item>
        <el-form-item label="公告内容" :label-width="formLabelWidth" prop="content">
          <el-input v-model="form.content" autocomplete="off" type="textarea" :rows="10" placeholder="请输入公告内容"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleCancel">取消</el-button>
        <el-button type="primary" @click="handleAdd">确定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import DataSelect from "@/components/DataSelect";
import ImgUpload from "@/components/ImgUpload";
export default {
  name: "Notice",
  components: {ImgUpload, DataSelect},
  data() {
    return {
      pageSize: 10,
      pageNum: 1,
      title: '',
      user: '',
      tableData: [],
      dialogFormVisible: false,
      form: {
        title: '',
        content: ''
      },
      formLabelWidth: '80px',
      multipleSelection: [],
      total: 0,
      searchTimer: null,
      rules: {
        title: [
          {required: true, message: '请输入公告标题', trigger: 'blur'}
        ],
        content: [
          {required: true, message: '请输入公告内容', trigger: 'blur'}
        ]
      }
    }
  },
  created() {
    this.load();
  },
  methods: {
    load() {
      // 清除之前的定时器
      if (this.searchTimer) {
        clearTimeout(this.searchTimer);
      }
      
      // 设置新的定时器，300ms后执行搜索
      this.searchTimer = setTimeout(() => {
        this.request.get("/notice/findPage", {
          params: {
            pageNum: this.pageNum,
            pageSize: this.pageSize,
            title: this.title,
            user: this.user,
          }
        }).then(res => {
          this.tableData = res.data.records;
          this.total = res.data.total;
        })
      }, 300);
    },
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
    },
    reset() {
      this.title = '';
      this.user = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      this.form = {};
    },
    handleCancel(){
      this.dialogFormVisible = false;
      Object.keys(this.form).forEach(key => {
        this.form[key] = '';
      });
      console.log(this.form);
    },
    handleAdd() {
      this.request.post("/notice/save", this.form).then(res => {
        if (res.code === '200') {
          if (this.form.id) {
            this.$message.success('编辑成功');
          } else {
            this.$message.success('新增成功');
          }
          this.dialogFormVisible = false;
          this.load();
        } else {
          this.$message.error(res.msg)
        }
      })
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(id) {
      if (id) {
        this.request.delete('/notice/deleteById/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除数据成功');
            this.handleCalPageNum();
          } else {
            this.$message.error(res.msg)
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
      //批量删除数据
      if (this.multipleSelection.length === 0) {
        this.$message.warning("请先选择要删除的数据");
        return
      }
      const ids = this.multipleSelection.map(v => v.id);
      this.request.post('/notice/deleteBatch', ids).then(res => {
        if (res.code === '200') {
          this.$message.success('批量删除成功');
          this.handleCalPageNum();
        } else {
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
    handleCalPageNum() {
      this.request.get("/notice/findPage", {
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
.notice-container {
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

.icon-img {
  width: 50px;
  height: 50px;
  object-fit: contain;
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

/* 公告表格 */
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

/* 公告内容样式 */
.notice-content {
  max-height: 100px;
  overflow-y: auto;
  padding: 10px;
  background: #f8f9fa;
  border-radius: 6px;
  font-size: 0.9rem;
  line-height: 1.6;
}

.notice-content::-webkit-scrollbar {
  width: 4px;
}

.notice-content::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 2px;
}

.notice-content::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.notice-content::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
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
  .notice-container {
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
  
  .notice-content {
    max-height: 80px;
  }
  
  .pagination-section {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .notice-container {
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
  
  .notice-content {
    max-height: 60px;
    font-size: 0.85rem;
  }
}
</style>
