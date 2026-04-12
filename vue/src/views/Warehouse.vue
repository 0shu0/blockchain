<template>
  <div class="warehouse-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <img src="../../../file/库存.png" alt="库存管理" class="icon-img">
        </div>
        <div class="header-text">
          <h1>库存管理</h1>
          <p>管理系统库存信息，包括添加、编辑、删除和查询</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ tableData.length }}</span>
            <span class="stat-label">库存记录</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 200px;" placeholder="请输入产品名称" v-model="name" prefix-icon="el-icon-search"></el-input>
        <el-button type="primary" @click="filterName" class="el-icon-search">搜索</el-button>
        <el-button type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="action-section">
      <el-button type="primary" class="el-icon-plus" @click="save">新增</el-button>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除选中的库存记录吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" class="el-icon-delete" :disabled="multipleSelection.length === 0">批量删除</el-button>
      </el-popconfirm>
    </div>

    <!-- 库存表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>库存记录列表</h3>
        <span class="table-count">{{ tableData.length }} 条记录</span>
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
        <el-table-column prop="traceCode" label="溯源码" min-width="200"></el-table-column>
        <el-table-column prop="amount" label="发货数量" width="120"></el-table-column>
        <el-table-column prop="sendDate" label="发货日期" width="150"></el-table-column>
        <el-table-column prop="origin" label="产地" min-width="120"></el-table-column>
        <el-table-column prop="name" label="产品名称" min-width="120"></el-table-column>
        <el-table-column prop="recvDate" label="收货日期" width="150"></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="primary" 
              size="small" 
              class="el-icon-view"
              @click="viewDetail(scope.row)"
              title="查看详情"
            ></el-button>
            <el-button 
              type="warning" 
              size="small" 
              class="el-icon-edit"
              @click="handleEdit(scope.row)"
              title="编辑"
            ></el-button>
            <el-button 
              type="danger" 
              size="small" 
              class="el-icon-delete"
              @click="handleDelete(scope.row.id)"
              title="删除"
            ></el-button>
          </template>
        </el-table-column>
      </el-table>
      <div v-if="tableData.length === 0" class="empty-state">
        <el-empty description="暂无库存数据" />
      </div>
    </div>

    <!-- 信息对话框 -->
    <el-dialog 
      title="库存信息" 
      :visible.sync="dialogFormVisible" 
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" :rules="rules" ref="warehouseForm">
        <el-form-item label="溯源码" :label-width="formLabelWidth" prop="traceCode">
          <el-input v-model="form.traceCode" autocomplete="off" placeholder="请输入溯源码"></el-input>
        </el-form-item>
        <el-form-item label="发货数量" :label-width="formLabelWidth" prop="amount">
          <el-input v-model="form.amount" autocomplete="off" placeholder="请输入发货数量"></el-input>
        </el-form-item>
        <el-form-item label="发货日期" :label-width="formLabelWidth" prop="sendDate">
          <el-input v-model="form.sendDate" autocomplete="off" placeholder="请输入发货日期"></el-input>
        </el-form-item>
        <el-form-item label="产地" :label-width="formLabelWidth" prop="origin">
          <el-input v-model="form.origin" autocomplete="off" placeholder="请输入产地"></el-input>
        </el-form-item>
        <el-form-item label="产品名称" :label-width="formLabelWidth" prop="name">
          <el-input v-model="form.name" autocomplete="off" placeholder="请输入产品名称"></el-input>
        </el-form-item>
        <el-form-item label="产品ID" :label-width="formLabelWidth" prop="productId">
          <el-input v-model="form.productId" autocomplete="off" placeholder="请输入产品ID"></el-input>
        </el-form-item>
        <el-form-item label="收货日期" :label-width="formLabelWidth" prop="recvDate">
          <el-input v-model="form.recvDate" autocomplete="off" placeholder="请输入收货日期"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAdd">确定</el-button>
      </div>
    </el-dialog>
    
    <!-- 发货信息对话框 -->
    <el-dialog title="发货信息" :visible.sync="dialogSendVisible" width="300px">
      <el-form :model="sendForm" :rules="sendRules" ref="sendForm">
        <el-form-item label="发货数量" :label-width="formLabelWidth" prop="amount">
          <el-input-number v-model="sendForm.amount" :min="1"></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogSendVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSend">确定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
import {addWarehouse, deleteWarehouse, getAllWarehouse, updateWarehouse} from "@/http/Warehouse";
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
      searchTimer: null,
      form: {
        traceCode: '',
        amount: '',
        sendDate: '',
        origin: '',
        name: '',
        recvDate: '',
        productId: '',
      },
      sendForm:{
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
    // 检查是否有从首页传递的数据
    this.checkTransferData();
    this.load();
  },
  methods: {
    // 检查从首页传递的数据
    checkTransferData() {
      const transferData = sessionStorage.getItem('transferData');
      if (transferData) {
        try {
          const data = JSON.parse(transferData);
          if (data.from === 'home') {
            // 显示接收数据的提示
            this.$message({
              message: '从首页接收数据成功',
              type: 'success',
              duration: 2000
            });
            // 可以在这里使用传递的数据
            console.log('接收的数据:', data);
            // 清除传递的数据，避免重复处理
            sessionStorage.removeItem('transferData');
          }
        } catch (error) {
          console.error('解析传递数据失败:', error);
        }
      }
    },
    filterName() {
      // 清除之前的定时器
      if (this.searchTimer) {
        clearTimeout(this.searchTimer);
      }
      
      // 设置新的定时器，300ms后执行搜索
      this.searchTimer = setTimeout(async () => {
        await this.load();
        if (this.name == '')
          return;
        this.tableData = this.tableData.filter(item => {
          return item.name.toLowerCase().includes(this.name.toLowerCase());
        });
      }, 300);
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
        // 由于移除了商品管理功能，不再调用addShop函数
        this.$message.success('发货成功');
        this.dialogSendVisible = false;
        this.load();
      });
    },
    async load() {
      // 显示加载状态
      const loading = this.$loading({
        lock: true,
        text: '正在加载库存数据...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });

      try {
        const res = await getAllWarehouse();
        // 确保数据顺序正确
        this.tableData = res.map(item => ({
          traceCode: item.traceCode,
          amount: item.amount,
          sendDate: item.sendDate,
          origin: item.origin,
          name: item.name,
          recvDate: item.recvDate,
          id: item.id,
          productId: item.productId
        }));

        if (this.tableData.length === 0) {
          this.$message.info('当前暂无库存数据');
        }
      } catch (err) {
        this.$message.error('加载库存数据失败：' + (err.message || '未知错误'));
        this.tableData = [];
        console.error('加载库存数据错误:', err);
      } finally {
        loading.close();
      }
    },
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
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
      this.$refs.warehouseForm.validate((valid) => {
        if (!valid) return;
        // 生成唯一ID
        if (!this.form.id) {
          this.form.id = generateUUID();
        }
        addWarehouse(this.form).then(res => {
          this.$message.success('新增成功');
          this.dialogFormVisible = false;
          this.load();
        }).catch(err => {
          this.$message.error('新增失败：' + (err.message || '未知错误'));
        });
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(id) {
      if (id) {
        this.$confirm('确定删除该库存记录吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          deleteWarehouse(id).then(res => {
            this.$message.success('删除数据成功');
            this.load();
          }).catch(err => {
            this.$message.error('删除失败：' + (err.message || '未知错误'));
          });
        }).catch(() => {
          this.$message.info('已取消删除');
        });
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
      // 批量删除库存记录
      Promise.all(ids.map(id => deleteWarehouse(id))).then(() => {
        this.$message.success('批量删除成功');
        this.load();
      }).catch(err => {
        this.$message.error('批量删除失败：' + (err.message || '未知错误'));
      });
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
    },
    viewDetail(row) {
      // 显示库存记录的详情
      this.dialogFormVisible = true;
      this.form = JSON.parse(JSON.stringify(row));
    }
  }
}
</script>

<style scoped>
.warehouse-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  min-height: calc(100vh - 120px);
  background-color: var(--bg-color-secondary);
  border-radius: 12px;
  border: 1px solid var(--border-color-light);
}

/* 页面标题 */
.page-header {
  margin-bottom: 30px;
  padding: 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
  border-radius: 16px;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
  color: white;
  animation: fadeInUp 0.6s ease-out;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-icon {
  width: 70px;
  height: 70px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10px);
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
  font-size: 2.2rem;
  font-weight: bold;
  margin-bottom: 10px;
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
  background: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
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
  background: var(--bg-color-secondary);
  padding: 20px;
  border-radius: 10px;
  box-shadow: var(--box-shadow-light);
  display: flex;
  align-items: center;
  gap: 15px;
  transition: box-shadow 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.search-card:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
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
  border: 1px solid var(--border-color-light);
}

.action-section .el-button:hover {
  transform: translateY(-2px);
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
}

/* 库存表格 */
.table-section {
  background: var(--bg-color-secondary);
  border-radius: 10px;
  box-shadow: var(--box-shadow-light);
  overflow: hidden;
  animation: fadeIn 0.5s ease-out;
  border: 1px solid var(--border-color-light);
}

.table-header {
  padding: 20px;
  border-bottom: 1px solid var(--border-color-light);
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: var(--bg-color-tertiary);
}

.table-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-color-primary);
}

.table-count {
  font-size: 0.9rem;
  color: var(--text-color-regular);
  background: var(--bg-color-tertiary);
  padding: 4px 12px;
  border-radius: 12px;
  border: 1px solid var(--border-color-light);
}

.table-section .el-table {
  border-radius: 0;
  background: var(--bg-color-secondary);
}

.table-section .el-table th {
  background: var(--bg-color-tertiary);
  font-weight: 600;
  color: var(--text-color-primary);
  border-bottom: 1px solid var(--border-color-light);
}

.table-section .el-table td {
  color: var(--text-color-regular);
  border-bottom: 1px solid var(--border-color-lighter);
}

.table-section .el-table tr:hover {
  background-color: var(--bg-color-tertiary);
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
  .warehouse-container {
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
  .warehouse-container {
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
