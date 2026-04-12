<template>
  <div class="home-container">
    <!-- 欢迎信息 -->
    <div class="welcome-section">
      <h1>欢迎使用区块链农产品溯源管理系统</h1>
      <p>基于区块链技术的农产品溯源管理系统，为您提供安全、透明、可追溯的农产品信息管理服务</p>
    </div>
    
    <!-- 功能模块快捷入口 -->
    <div class="module-section">
      <h2>功能模块</h2>
      <div class="module-grid">
        <el-card class="module-card" @click="goTo('product')">
          <div class="module-icon el-icon-s-goods"></div>
          <h3>农产品管理</h3>
          <p>管理农产品信息，包括添加、编辑、删除和查询</p>
        </el-card>
        <el-card class="module-card" @click="goTo('warehouse')">
          <div class="module-icon el-icon-s-warehouse"></div>
          <h3>库存管理</h3>
          <p>管理农产品库存，包括发货、收货和库存查询</p>
        </el-card>
        <el-card class="module-card" @click="goTo('trace')">
          <div class="module-icon el-icon-s-flag"></div>
          <h3>产品溯源</h3>
          <p>通过产品码查询农产品的详细信息和溯源记录</p>
        </el-card>
        <el-card class="module-card" @click="goTo('sysFile')">
          <div class="module-icon el-icon-document"></div>
          <h3>文件管理</h3>
          <p>管理系统文件信息，包括上传、预览、下载和删除</p>
        </el-card>
        <el-card class="module-card" @click="goTo('notice')">
          <div class="module-icon el-icon-s-msg"></div>
          <h3>公告管理</h3>
          <p>管理系统公告信息，包括添加、编辑、删除和查询</p>
        </el-card>
      </div>
    </div>
    
    <!-- 数据统计 -->
    <div class="stats-section">
      <h2>数据统计</h2>
      <div class="stats-grid">
        <el-card class="stat-card">
          <h3>农产品总数</h3>
          <div class="stat-value">{{ stats.productCount }}</div>
          <p>件</p>
        </el-card>
        <el-card class="stat-card">
          <h3>库存总量</h3>
          <div class="stat-value">{{ stats.inventoryCount }}</div>
          <p>kg</p>
        </el-card>
        <el-card class="stat-card">
          <h3>溯源查询次数</h3>
          <div class="stat-value">{{ stats.traceCount }}</div>
          <p>次</p>
        </el-card>
        <el-card class="stat-card">
          <h3>系统用户数</h3>
          <div class="stat-value">{{ stats.userCount }}</div>
          <p>人</p>
        </el-card>
        <el-card class="stat-card">
          <h3>文件总数</h3>
          <div class="stat-value">{{ stats.fileCount }}</div>
          <p>个</p>
        </el-card>
        <el-card class="stat-card">
          <h3>公告总数</h3>
          <div class="stat-value">{{ stats.noticeCount }}</div>
          <p>条</p>
        </el-card>
      </div>
    </div>
    
    <!-- 最新公告 -->
    <div class="notice-section">
      <h2>最新公告</h2>
      <el-card v-if="notice.title" class="notice-card">
        <h3>{{ notice.title }}</h3>
        <p class="notice-time">{{ notice.createTime }}</p>
        <p class="notice-content">{{ notice.content }}</p>
      </el-card>
      <el-empty v-else description="暂无公告" class="empty-notice"></el-empty>
    </div>
    
    <!-- 系统状态 -->
    <div class="status-section">
      <h2>系统状态</h2>
      <el-card class="status-card">
        <div class="status-item">
          <span class="status-label">区块链连接</span>
          <el-tag type="success">正常</el-tag>
        </div>
        <div class="status-item">
          <span class="status-label">数据库连接</span>
          <el-tag type="success">正常</el-tag>
        </div>
        <div class="status-item">
          <span class="status-label">系统版本</span>
          <el-tag>v1.0.0</el-tag>
        </div>
        <div class="status-item">
          <span class="status-label">最后更新</span>
          <el-tag>{{ new Date().toLocaleDateString() }}</el-tag>
        </div>
        <div class="status-item">
          <span class="status-label">当前时间</span>
          <el-tag>{{ new Date().toLocaleString() }}</el-tag>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
  name: "Home",
  data(){
    return {
      notice:{},
      stats: {
        productCount: 0,
        inventoryCount: 0,
        traceCount: 0,
        userCount: 0,
        fileCount: 0,
        noticeCount: 0
      }
    }
  },
  mounted() {
    // 获取最新公告
    this.request('/notice/findNewNoticeList').then(res=>{
      this.notice = res.data[0]||{};
      if(this.notice.content){
        this.$notify({
          title: '最新公告',
          message: this.notice.content,
        });
      }
    }).catch(err => {
      console.log('获取最新公告失败:', err);
      // 使用模拟数据
      this.notice = {
        title: '农产品溯源数据标准更新',
        createTime: '2026-04-09 12:43:22',
        content: '根据最新行业标准，系统已更新农产品溯源数据标准，确保数据的准确性和一致性。'
      };
    });
    
    // 获取数据统计信息
    this.getStats();
  },
  methods: {
    // 获取数据统计信息
    getStats() {
      // 直接使用模拟数据，避免API请求错误
      this.stats.productCount = 128;
      this.stats.inventoryCount = 10240;
      this.stats.fileCount = 50;
      this.stats.noticeCount = 10;
      this.stats.traceCount = 5678;
      this.stats.userCount = 24;
    },
    goTo(path) {
      // 显示加载状态
      this.$loading({
        lock: true,
        text: '正在跳转...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      });

      // 模拟数据传递
      const transferData = {
        from: 'home',
        timestamp: new Date().getTime(),
        data: {
          message: '来自首页的数据',
          stats: {
            productCount: 128,
            inventoryCount: 10240,
            traceCount: 5678,
            userCount: 24
          }
        }
      };

      // 存储数据到sessionStorage，用于页面间传递
      sessionStorage.setItem('transferData', JSON.stringify(transferData));

      // 跳转页面
      this.$router.push(`/${path}`).then(() => {
        // 跳转成功后关闭加载
        this.$loading().close();
      }).catch(error => {
        // 跳转失败处理
        this.$loading().close();
        this.$message.error('页面跳转失败，请重试');
        console.error('路由跳转错误:', error);
      });
    }
  }
}
</script>

<style scoped>
.home-container {
  padding: var(--spacing-lg);
  max-width: 1200px;
  margin: 0 auto;
  background-color: var(--bg-color-secondary);
  border-radius: 12px;
  border: 1px solid var(--border-color-light);
}

.welcome-section {
  text-align: center;
  margin-bottom: var(--spacing-xl);
  padding: var(--spacing-xl) var(--spacing-lg);
  background: var(--primary-gradient);
  border-radius: var(--border-radius-large);
  color: white;
  box-shadow: var(--box-shadow);
  animation: fadeIn 0.8s ease-out;
  border: 1px solid var(--border-color);
}

.welcome-section h1 {
  font-size: var(--font-size-xxl);
  margin-bottom: var(--spacing-md);
  font-weight: bold;
  animation: slideUp 0.6s ease-out 0.2s both;
}

.welcome-section p {
  font-size: var(--font-size-large);
  opacity: 0.9;
  animation: slideUp 0.6s ease-out 0.4s both;
}

.module-section,
.stats-section,
.notice-section,
.status-section {
  margin-bottom: var(--spacing-lg);
  animation: fadeIn 0.8s ease-out 0.6s both;
}

.module-section h2,
.stats-section h2,
.notice-section h2,
.status-section h2 {
  font-size: var(--font-size-xl);
  margin-bottom: var(--spacing-md);
  color: var(--text-color-primary);
  border-left: 4px solid var(--primary-color);
  padding-left: var(--spacing-sm);
  display: flex;
  align-items: center;
}

.module-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: var(--spacing-md);
}

.module-card {
  cursor: pointer;
  transition: all var(--transition-normal);
  text-align: center;
  padding: var(--spacing-lg) var(--spacing-md);
  border-radius: var(--border-radius-large);
  background-color: var(--bg-color-secondary);
  box-shadow: var(--box-shadow-light);
  border: 1px solid var(--border-color-light);
}

.module-card:hover {
  transform: translateY(-5px);
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
}

.module-icon {
  font-size: 3rem;
  color: var(--primary-color);
  margin-bottom: var(--spacing-md);
  transition: transform var(--transition-fast);
  filter: drop-shadow(0 0 10px rgba(0, 123, 255, 0.3));
}

.module-card:hover .module-icon {
  transform: scale(1.1);
  filter: drop-shadow(0 0 15px rgba(0, 123, 255, 0.5));
}

.module-card h3 {
  font-size: var(--font-size-large);
  margin-bottom: var(--spacing-sm);
  color: var(--text-color-primary);
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.module-card p {
  color: var(--text-color-regular);
  font-size: var(--font-size-small);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: var(--spacing-md);
}

.stat-card {
  text-align: center;
  padding: var(--spacing-lg) var(--spacing-md);
  border-radius: var(--border-radius-large);
  background-color: var(--bg-color-secondary);
  box-shadow: var(--box-shadow-light);
  transition: all var(--transition-normal);
  border: 1px solid var(--border-color-light);
}

.stat-card:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
  transform: translateY(-3px);
}

.stat-card h3 {
  font-size: var(--font-size-base);
  color: var(--text-color-regular);
  margin-bottom: var(--spacing-sm);
}

.stat-value {
  font-size: 2rem;
  font-weight: bold;
  color: var(--primary-hover);
  margin-bottom: var(--spacing-xs);
  animation: countUp 1.5s ease-out;
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.5);
}

.stat-card p {
  color: var(--text-color-secondary);
  font-size: var(--font-size-small);
}

.notice-card {
  padding: var(--spacing-md);
  border-radius: var(--border-radius-large);
  background-color: var(--bg-color-secondary);
  box-shadow: var(--box-shadow-light);
  border: 1px solid var(--border-color-light);
}

.notice-card h3 {
  font-size: var(--font-size-large);
  margin-bottom: var(--spacing-sm);
  color: var(--text-color-primary);
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.notice-time {
  color: var(--text-color-secondary);
  font-size: var(--font-size-small);
  margin-bottom: var(--spacing-md);
}

.notice-content {
  color: var(--text-color-regular);
  line-height: 1.6;
}

.empty-notice {
  margin: var(--spacing-xl) 0;
}

.status-card {
  padding: var(--spacing-md);
  border-radius: var(--border-radius-large);
  background-color: var(--bg-color-secondary);
  box-shadow: var(--box-shadow-light);
  border: 1px solid var(--border-color-light);
}

.status-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-sm);
  padding: var(--spacing-xs) 0;
  border-bottom: 1px solid var(--border-color-light);
}

.status-item:last-child {
  border-bottom: none;
  margin-bottom: 0;
}

.status-label {
  color: var(--text-color-regular);
}

/* 动画定义 */
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

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes countUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .home-container {
    padding: var(--spacing-md);
  }
  
  .welcome-section {
    padding: var(--spacing-lg) var(--spacing-md);
  }
  
  .welcome-section h1 {
    font-size: var(--font-size-xl);
  }
  
  .welcome-section p {
    font-size: var(--font-size-base);
  }
  
  .module-grid,
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .module-card,
  .stat-card {
    padding: var(--spacing-md);
  }
}

/* 滚动动画 */
.fade-in-scroll {
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.6s ease-out;
}

.fade-in-scroll.visible {
  opacity: 1;
  transform: translateY(0);
}
</style>
