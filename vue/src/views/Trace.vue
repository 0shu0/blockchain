<template>
  <div class="trace-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <img src="../../../file/溯源.png" alt="产品溯源" class="icon-img">
        </div>
        <div class="header-text">
          <h1>产品溯源</h1>
          <p>输入产品码查询农产品溯源信息，了解产品全生命周期</p>
        </div>
      </div>
    </div>

    <!-- 搜索区域 -->
    <div class="search-section">
      <div class="search-card">
        <div class="search-title">
          <i class="el-icon-search"></i>
          <span>溯源查询</span>
        </div>
        <div class="search-input-group">
          <span class="input-prefix">···</span>
          <el-input 
            v-model="code" 
            placeholder="请输入产品码进行溯源查询" 
            class="search-input"
            @keyup.enter.native="search"
            clearable
          >
          </el-input>
          <el-button type="primary" @click="search" class="search-button" :loading="loading">
            <i class="el-icon-search"></i> 溯源查询
          </el-button>
        </div>
      </div>
    </div>

    <!-- 查询结果 -->
    <transition name="fade">
      <div class="result-section" v-if="hasResult">
        <el-card class="result-card" shadow="hover">
          <div slot="header" class="card-header">
            <div class="header-left">
              <i class="el-icon-s-order"></i>
              <span>溯源查询结果</span>
            </div>
            <el-tag type="success" effect="dark" size="small">查询成功</el-tag>
          </div>
          
          <div class="result-content">
            <!-- 产品信息卡片 -->
            <div class="info-section">
              <div class="section-title">
                <i class="el-icon-goods"></i>
                <span>产品信息</span>
              </div>
              <div class="info-grid">
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-s-goods"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">产品名称</span>
                    <span class="info-value">{{traceData.name || '-'}}</span>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-location"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">产地</span>
                    <span class="info-value">{{traceData.origin || '-'}}</span>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-office-building"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">生产厂家</span>
                    <span class="info-value">{{traceData.manufacturer || '-'}}</span>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-date"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">上架日期</span>
                    <span class="info-value">{{traceData.listDate || '-'}}</span>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-price-tag"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">产品价格</span>
                    <span class="info-value price">{{traceData.price || 0}} 元</span>
                  </div>
                </div>
                <div class="info-item">
                  <div class="info-icon">
                    <i class="el-icon-s-grid"></i>
                  </div>
                  <div class="info-detail">
                    <span class="info-label">产品码</span>
                    <span class="info-value code">{{code}}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 溯源时间线 -->
            <div class="timeline-section" v-if="traceData.name">
              <div class="section-title">
                <i class="el-icon-time"></i>
                <span>溯源流程</span>
              </div>
              <div class="timeline">
                <div class="timeline-item active">
                  <div class="timeline-dot"></div>
                  <div class="timeline-content">
                    <div class="timeline-title">产品生产</div>
                    <div class="timeline-desc">产品于 {{traceData.origin}} 生产完成</div>
                    <div class="timeline-time">{{traceData.listDate}}</div>
                  </div>
                </div>
                <div class="timeline-item active">
                  <div class="timeline-dot"></div>
                  <div class="timeline-content">
                    <div class="timeline-title">质量检测</div>
                    <div class="timeline-desc">产品通过质量检测，符合安全标准</div>
                    <div class="timeline-time">{{traceData.listDate}}</div>
                  </div>
                </div>
                <div class="timeline-item active">
                  <div class="timeline-dot"></div>
                  <div class="timeline-content">
                    <div class="timeline-title">入库上架</div>
                    <div class="timeline-desc">产品已入库并上架销售</div>
                    <div class="timeline-time">{{traceData.listDate}}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </div>
    </transition>

    <!-- 空状态 -->
    <transition name="fade">
      <div class="empty-section" v-if="showEmpty">
        <el-empty description="请输入产品码进行溯源查询">
          <template #image>
            <div class="custom-empty-image">
              <i class="el-icon-search"></i>
            </div>
          </template>
          <template #description>
            <div class="empty-description">
              <p class="empty-title">暂无查询结果</p>
              <p class="empty-subtitle">请在上方输入产品码进行溯源查询</p>
            </div>
          </template>
        </el-empty>
      </div>
    </transition>
  </div>
</template>

<script>
import {getProductByCode} from "@/http/Product";

export default {
  name: "Trace",
  data() {
    return {
      code: '',
      loading: false,
      hasResult: false,
      showEmpty: true,
      searchTimer: null,
      traceData:{
        name:'',
        origin:'',
        manufacturer:'',
        listDate:'',
        price:0,
      }
    }
  },
  methods: {
    search() {
      // 清除之前的定时器
      if (this.searchTimer) {
        clearTimeout(this.searchTimer);
      }
      
      // 设置新的定时器，300ms后执行搜索
      this.searchTimer = setTimeout(() => {
        console.log('Search button clicked');
        console.log('Code:', this.code);
        
        if(this.code=='') {
          console.log('Code is empty');
          this.$message.warning('请输入产品码');
          return;
        }
        
        this.loading = true;
        console.log('Calling getProductByCode with code:', this.code);
        
        getProductByCode(this.code).then(res=>{
          console.log('getProductByCode resolved with:', res);
          this.loading = false;
          
          if (res && res.name) {
            this.traceData.name=res.name || '';
            this.traceData.origin=res.origin || '';
            this.traceData.manufacturer=res.manufacturer || '';
            this.traceData.listDate=res.listDate || '';
            this.traceData.price=res.price || 0;
            
            this.hasResult = true;
            this.showEmpty = false;
            
            console.log('Trace data updated:', this.traceData);
            this.$message.success('查询成功');
          } else {
            this.hasResult = false;
            this.showEmpty = true;
            this.$message.warning('未查询到该产品信息');
          }
        }).catch(err=>{
          console.error('getProductByCode rejected with:', err);
          this.loading = false;
          this.hasResult = false;
          this.showEmpty = true;
          this.$message.error('查询失败：' + (err.message || '未知错误'));
          this.traceData = {
            name:'',
            origin:'',
            manufacturer:'',
            listDate:'',
            price:0
          };
        });
      }, 300);
    }
  }
}
</script>

<style scoped>
.trace-container {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;
  min-height: calc(100vh - 120px);
}

/* 页面标题 */
.page-header {
  margin-bottom: 30px;
  padding: 30px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
}

.icon-img {
  width: 40px;
  height: 40px;
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

/* 搜索区域 */
.search-section {
  margin-bottom: 30px;
  animation: fadeIn 0.5s ease-out 0.2s both;
}

.search-card {
  background: white;
  padding: 30px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: box-shadow 0.3s ease;
}

.search-card:hover {
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.search-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.3rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
}

.search-title i {
  color: #667eea;
  font-size: 1.5rem;
}

.search-input-group {
  display: flex;
  align-items: center;
  gap: 12px;
}

.input-prefix {
  font-size: 1.2rem;
  color: #667eea;
  font-weight: bold;
  letter-spacing: 2px;
  white-space: nowrap;
}

.search-input {
  flex: 1;
}

.search-input ::v-deep .el-input__inner {
  height: 50px;
  font-size: 1rem;
  border-radius: 10px;
}

.search-button {
  height: 50px;
  padding: 0 30px;
  font-size: 1.1rem;
  border-radius: 10px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  transition: all 0.3s ease;
}

.search-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

/* 结果区域 */
.result-section {
  animation: fadeInUp 0.5s ease-out;
}

.result-card {
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.result-card ::v-deep .el-card__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px 25px;
  border: none;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: white;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.2rem;
  font-weight: 600;
}

.header-left i {
  font-size: 1.4rem;
}

.result-content {
  padding: 10px;
}

/* 信息区域 */
.info-section {
  margin-bottom: 30px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.section-title i {
  color: #667eea;
  font-size: 1.3rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.info-item:hover {
  background: #eef1f6;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.info-icon {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.5rem;
}

.info-detail {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.info-label {
  font-size: 0.85rem;
  color: #909399;
}

.info-value {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
}

.info-value.price {
  color: #f56c6c;
  font-size: 1.2rem;
}

.info-value.code {
  font-family: 'Courier New', monospace;
  font-size: 0.95rem;
  color: #667eea;
}

/* 时间线区域 */
.timeline-section {
  margin-top: 30px;
}

.timeline {
  position: relative;
  padding-left: 25px;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 10px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: linear-gradient(to bottom, #667eea, #764ba2);
}

.timeline-item {
  position: relative;
  padding-bottom: 30px;
  opacity: 0.5;
  transition: opacity 0.3s ease;
}

.timeline-item.active {
  opacity: 1;
}

.timeline-dot {
  position: absolute;
  left: -25px;
  top: 5px;
  width: 16px;
  height: 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  border: 3px solid white;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.4);
}

.timeline-content {
  background: #f8f9fa;
  padding: 20px;
  border-radius: 12px;
}

.timeline-title {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.timeline-desc {
  font-size: 0.95rem;
  color: #666;
  margin-bottom: 8px;
}

.timeline-time {
  font-size: 0.85rem;
  color: #909399;
}

/* 空状态 */
.empty-section {
  animation: fadeIn 0.5s ease-out;
}

.custom-empty-image {
  width: 120px;
  height: 120px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.custom-empty-image i {
  font-size: 3rem;
  color: white;
}

.empty-description {
  text-align: center;
}

.empty-title {
  font-size: 1.2rem;
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.empty-subtitle {
  font-size: 0.95rem;
  color: #909399;
  margin: 0;
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

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .trace-container {
    padding: 10px;
  }
  
  .page-header {
    padding: 20px;
    border-radius: 12px;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
    gap: 15px;
  }
  
  .header-text h1 {
    font-size: 1.6rem;
  }
  
  .search-card {
    padding: 20px;
  }
  
  .search-input-group {
    flex-direction: column;
  }
  
  .search-button {
    width: 100%;
  }
  
  .info-grid {
    grid-template-columns: 1fr;
  }
  
  .timeline {
    padding-left: 20px;
  }
  
  .timeline-dot {
    left: -20px;
    width: 12px;
    height: 12px;
  }
}

@media (max-width: 480px) {
  .page-header {
    padding: 15px;
  }
  
  .header-icon {
    width: 50px;
    height: 50px;
  }
  
  .icon-lg {
    font-size: 1.8rem;
  }
  
  .header-text h1 {
    font-size: 1.4rem;
  }
  
  .search-card {
    padding: 15px;
  }
  
  .info-item {
    padding: 15px;
  }
  
  .info-icon {
    width: 40px;
    height: 40px;
    font-size: 1.2rem;
  }
}
</style>
