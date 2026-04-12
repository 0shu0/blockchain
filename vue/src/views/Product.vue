<template>
  <div class="product-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <img src="../../../file/农产品.png" alt="农产品管理" class="icon-img">
        </div>
        <div class="header-text">
          <h1>农产品管理</h1>
          <p>管理农产品信息，包括添加、编辑、删除和查询</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ tableData.length }}</span>
            <span class="stat-label">产品总数</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 搜索栏 -->
    <div class="search-section">
      <div class="search-card">
        <el-input style="width: 300px;" placeholder="请输入产品名称" v-model="name"
                  prefix-icon="el-icon-search" @keyup.enter="filterName"></el-input>
        <el-button type="primary" @click="filterName" class="el-icon-search" :loading="loading">搜索</el-button>
        <el-button type="warning" @click="reset" class="el-icon-refresh">重置</el-button>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="action-section">
      <el-button type="success" class="el-icon-plus" @click="save" :loading="submitting">新增</el-button>
      <el-popconfirm
          confirm-button-text='确定'
          cancel-button-text='取消'
          icon="el-icon-info"
          icon-color="red"
          title="确定删除选中的产品吗？"
          @confirm="deleteBatch"
          @cancel="cancel">
        <el-button slot="reference" type="danger" class="el-icon-delete" :disabled="multipleSelection.length === 0">批量删除</el-button>
      </el-popconfirm>
    </div>

    <!-- 产品表格 -->
    <div class="table-section">
      <div class="table-header">
        <h3>产品列表</h3>
        <span class="table-count">{{ tableData.length }} 个产品</span>
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
        <el-table-column prop="name" label="产品名称" min-width="120">
          <template slot-scope="scope">
            <div class="product-name">{{ scope.row.name }}</div>
          </template>
        </el-table-column>
        <el-table-column prop="origin" label="产地" min-width="120"></el-table-column>
        <el-table-column prop="manufacturer" label="厂家" min-width="150"></el-table-column>
        <el-table-column prop="traceCode" label="产品码" min-width="200" show-overflow-tooltip>
          <template slot-scope="scope">
            <el-tag size="small" type="info">{{ scope.row.traceCode }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button 
              type="warning" 
              size="small" 
              @click="showSendDialog(scope.row)"
              class="el-icon-message"
              circle
              title="发货"
            ></el-button>
            <el-button 
              type="primary" 
              size="small" 
              @click="handleEdit(scope.row)"
              class="el-icon-edit"
              circle
              title="编辑"
            ></el-button>
            <el-button 
              type="danger" 
              size="small" 
              @click="handleDelete(scope.row.traceCode)"
              class="el-icon-delete"
              circle
              title="删除"
            ></el-button>
          </template>
        </el-table-column>
      </el-table>
      <div v-if="tableData.length === 0" class="empty-state">
        <el-empty description="暂无产品数据" />
      </div>
    </div>

    <!-- 产品信息对话框 -->
    <el-dialog 
      title="产品信息" 
      :visible.sync="dialogFormVisible" 
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" :rules="rules" ref="productForm" label-position="top">
        <el-form-item label="产品名称" prop="name">
          <el-input 
            v-model="form.name" 
            autocomplete="off" 
            placeholder="请输入产品名称"
            :class="{ 'input-focus': focusName }"
            @focus="focusName = true"
            @blur="focusName = false"
          ></el-input>
        </el-form-item>
        <el-form-item label="产地" prop="origin">
          <el-input 
            v-model="form.origin" 
            autocomplete="off" 
            placeholder="请输入产地"
            :class="{ 'input-focus': focusOrigin }"
            @focus="focusOrigin = true"
            @blur="focusOrigin = false"
          ></el-input>
        </el-form-item>
        <el-form-item label="厂家" prop="manufacturer">
          <el-input 
            v-model="form.manufacturer" 
            autocomplete="off" 
            placeholder="请输入厂家"
            :class="{ 'input-focus': focusManufacturer }"
            @focus="focusManufacturer = true"
            @blur="focusManufacturer = false"
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAdd" :loading="submitting">确定</el-button>
      </div>
    </el-dialog>

    <!-- 发货对话框 -->
    <el-dialog 
      title="发货" 
      :visible.sync="sendDialogVisible" 
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form :model="sendForm" :rules="sendRules" ref="sendForm" label-position="top">
        <el-form-item label="产品信息" class="product-info">
          <el-card shadow="hover">
            <div class="product-detail">
              <p><strong>产品名称：</strong>{{ sendRow.name }}</p>
              <p><strong>产地：</strong>{{ sendRow.origin }}</p>
              <p><strong>厂家：</strong>{{ sendRow.manufacturer }}</p>
              <p><strong>产品码：</strong>{{ sendRow.traceCode }}</p>
            </div>
          </el-card>
        </el-form-item>
        <el-form-item label="发货数量" prop="amount">
          <el-input-number 
            v-model="sendForm.amount" 
            :min="1" 
            placeholder="请输入发货数量"
            :class="{ 'input-focus': focusAmount }"
            @focus="focusAmount = true"
            @blur="focusAmount = false"
          ></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="sendDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSend" :loading="sending">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { addProduct, getAllProduct, updateProduct, deleteProduct } from "@/http/Product";
import { generateUUID } from "@/utils/uuid";
import { addWarehouse, getAllWarehouse } from "@/http/Warehouse";

export default {
  name: "Product",
  data() {
    return {
      sendForm: {
        amount: 1,
      },
      sendDialogVisible: false,
      pageSize: 10,
      pageNum: 1,
      name: '',
      rowTableData: [],
      tableData: [],
      dialogFormVisible: false,
      form: {
        name: '',
        origin: '',
        manufacturer: '',
        traceCode: '',
      },
      formLabelWidth: '80px',
      sendRow: {},
      total: 0,
      multipleSelection: [],
      loading: false,
      submitting: false,
      sending: false,
      focusName: false,
      focusOrigin: false,
      focusManufacturer: false,
      focusAmount: false,
      searchTimer: null,
      rules: {
        'name': [
          { required: true, message: '请输入产品名称', trigger: 'blur' }
        ],
        'origin': [
          { required: true, message: '请输入产地', trigger: 'blur' }
        ],
        'manufacturer': [
          { required: true, message: '请输入厂家', trigger: 'blur' }
        ],
      },
      sendRules: {
        'amount': [{ required: true, message: '请输入发货数量', trigger: 'blur' }]
      }
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
    showSendDialog(row) {
      this.sendRow = row;
      this.sendForm.amount = 1;
      this.sendDialogVisible = true;
    },
    handleSend(row) {
      this.$refs.sendForm.validate((valid) => {
        if (!valid) return;
        // 检查产品是否为空或缺少必要字段
        if (!this.sendRow || !this.sendRow.traceCode || !this.sendRow.origin || !this.sendRow.name) {
          this.$message.error('产品信息不完整，无法发货');
          return;
        }
        this.sending = true;
        console.log('发货的产品信息：', this.sendRow);
        console.log('发货数量：', this.sendForm.amount);
        // 获取当前日期，格式为YYYY-MM-DD
        const now = new Date();
        const dateString = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
        // 发货日期和收获日期都使用YYYY-MM-DD格式
        const sendDate = dateString;
        const recvDate = dateString;
        
        let params = {
          id: generateUUID(),
          traceCode: this.sendRow.traceCode,
          productId: this.sendRow.traceCode,
          amount: this.sendForm.amount,
          sendDate: sendDate,
          origin: this.sendRow.origin,
          name: this.sendRow.name,
          recvDate: recvDate
        }
        console.log('发送给addWarehouse的参数：', params);
        addWarehouse(params).then(res => {
          this.sending = false;
          console.log('addWarehouse返回结果：', res);
          // 检查返回结果是否包含错误信息
          if (res && (res.code === 422 || res.error || res.message)) {
            console.error('addWarehouse返回错误：', res);
            this.$message.error('发货失败：' + (res.message || res.error || '合约调用异常'));
          } else {
            this.$message.success('发货成功');
            this.sendDialogVisible = false;
            // 重新加载库存管理页面的数据
            this.loadWarehouseData();
          }
        }).catch(err => {
          this.sending = false;
          console.error('addWarehouse调用失败：', err);
          // 尝试获取更详细的错误信息
          if (err.response && err.response.data) {
            console.error('错误详情：', err.response.data);
            this.$message.error('发货失败：' + (err.response.data.message || err.response.data.error || '合约调用异常'));
          } else {
            this.$message.error('发货失败：' + (err.message || '合约调用异常'));
          }
        });
      })
    },
    async load() {
      // 显示加载状态
      const loading = this.$loading({
        lock: true,
        text: '正在加载产品列表...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });

      try {
        const res = await getAllProduct();
        console.log('getAllProduct返回结果：', res);
        // 过滤掉空产品（缺少必要字段的产品）
        const validProducts = res.filter(item => item && item.traceCode && item.name && item.origin && item.manufacturer);
        console.log('过滤后的有效产品：', validProducts);
        this.rowTableData = validProducts;
        this.tableData = validProducts;
        if (validProducts.length === 0) {
          this.$message.info('当前暂无产品数据');
        }
      } catch (err) {
        this.$message.error('加载产品列表失败：' + (err.message || '未知错误'));
        this.rowTableData = [];
        this.tableData = [];
        console.error('加载产品列表错误:', err);
      } finally {
        loading.close();
        this.loading = false;
      }
    },
    tableRowClassName({ row, rowIndex }) {
      return {
        'row-hover': true
      };
    },
    
    filterName() {
      // 清除之前的定时器
      if (this.searchTimer) {
        clearTimeout(this.searchTimer);
      }
      
      // 设置新的定时器，300ms后执行搜索
      this.searchTimer = setTimeout(async () => {
        await this.load();
        if (!this.name) return;
        this.tableData = this.tableData.filter(item => {
          return item.name.toLowerCase().includes(this.name.toLowerCase());
        });
      }, 300);
    },
    reset() {
      this.name = '';
      this.load();
    },
    save() {
      this.dialogFormVisible = true;
      this.form = {
        name: '',
        origin: '',
        manufacturer: '',
        traceCode: '',
      };
      this.$nextTick(() => {
        this.$refs.productForm?.clearValidate();
      });
    },
    handleAdd() {
      this.$refs.productForm.validate((valid) => {
        if (!valid) return;
        this.submitting = true;
        if (!this.form.traceCode) {
          this.form.traceCode = generateUUID();
          console.log("生成的traceCode：", this.form.traceCode);
          addProduct(this.form).then(res => {
            this.submitting = false;
            this.dialogFormVisible = false;
            this.$message.success('产品新建成功！');
            this.load();
          }).catch(err => {
            this.submitting = false;
            this.$message.error('产品新建失败：' + (err.message || '合约调用异常'));
          });
        } else {
          updateProduct(this.form).then(res => {
            this.submitting = false;
            this.dialogFormVisible = false;
            this.$message.success('产品编辑成功！');
            this.load();
          }).catch(err => {
            this.submitting = false;
            this.$message.error('产品编辑失败：' + (err.message || '合约调用异常'));
          });
        }
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    handleDelete(traceCode) {
      if (traceCode) {
        this.$confirm('确定删除该产品吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          deleteProduct(traceCode).then(res => {
            this.$message.success('删除产品成功');
            this.load();
          }).catch(err => {
            this.$message.error('删除失败：' + (err.message || '合约调用异常'));
          });
        }).catch(() => {
          this.$message.info('已取消删除');
        });
      } else {
        this.$message.error('没有产品码信息，无法删除');
      }
    },
    cancel() {
      this.$message.success('取消操作成功');
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
      this.request.get("/product/findPage", {
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
    handleSelectionChange(val) {
      this.multipleSelection = val;
    },
    deleteBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message.warning("请先选择要删除的产品");
        return;
      }
      // 过滤掉空产品（没有traceCode的产品）
      const validProducts = this.multipleSelection.filter(v => v.traceCode);
      if (validProducts.length === 0) {
        this.$message.warning("所选产品中没有有效的产品码");
        return;
      }
      const traceCodes = validProducts.map(v => v.traceCode);
      // 批量删除产品
      Promise.all(traceCodes.map(traceCode => deleteProduct(traceCode))).then(() => {
        this.$message.success('批量删除成功');
        this.load();
      }).catch(err => {
        this.$message.error('批量删除失败：' + (err.message || '合约调用异常'));
      });
    },
    loadWarehouseData() {
      // 重新加载库存管理页面的数据
      // 这里可以通过事件总线或其他方式通知库存管理页面重新加载数据
      // 或者直接调用getAllWarehouse方法获取最新的库存记录
      getAllWarehouse().then(res => {
        console.log('库存数据已更新：', res);
        // 这里可以通过事件总线通知库存管理页面重新加载数据
        // 例如：this.$bus.$emit('refreshWarehouseData');
      }).catch(err => {
        console.error('加载库存数据失败：', err);
      });
    }
  }
}
</script>

<style scoped>
.product-container {
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
  max-width: 400px;
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

/* 产品表格 */
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

.product-name {
  font-weight: 500;
  color: #606266;
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

/* 产品信息卡片 */
.product-info {
  margin-bottom: 20px;
}

.product-detail p {
  margin: 8px 0;
  font-size: 0.95rem;
}

.product-detail strong {
  color: #333;
  margin-right: 8px;
}

/* 输入框焦点效果 */
.input-focus {
  border-color: #409eff !important;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2) !important;
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
  .product-container {
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
}

@media (max-width: 480px) {
  .product-container {
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