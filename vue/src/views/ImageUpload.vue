<template>
  <div class="image-upload-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <img src="../../../file/图片.png" alt="图片处理" class="icon-img">
        </div>
        <div class="header-text">
          <h1>局域网图片上传与共享</h1>
          <p>上传图片并生成可访问的URL，支持局域网内所有设备访问</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-number">{{ uploadedImages.length }}</span>
            <span class="stat-label">已上传</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 上传区域 -->
    <div class="upload-section">
      <div class="section-card">
        <div class="section-header">
          <el-icon><el-icon-upload-filled /></el-icon>
          <h3>图片上传</h3>
        </div>
        <div class="upload-content">
          <el-upload
            class="image-uploader"
            :action="''"
            :show-file-list="false"
            :http-request="uploadImage"
            :before-upload="beforeUpload"
            accept="image/jpeg,image/png,image/webp"
            multiple
          >
            <div class="upload-area">
              <el-icon class="upload-icon"><el-icon-upload-filled /></el-icon>
              <h3>点击或拖拽图片到此处上传</h3>
              <p class="upload-tip">支持jpg、png、webp格式，多文件上传，单文件最大10MB</p>
              <el-button type="primary" :loading="uploading" class="upload-button">
                <i class="el-icon-upload"></i> 选择图片
              </el-button>
            </div>
          </el-upload>
          
          <!-- 上传进度条 -->
          <el-progress 
            v-if="uploading" 
            :percentage="uploadProgress" 
            :format="formatProgress" 
            :status="uploadStatus"
            class="upload-progress"
          />
        </div>
      </div>
    </div>
    
    <!-- 图片预览 -->
    <div class="preview-section" v-if="uploadedImages.length > 0">
      <div class="section-card">
        <div class="section-header">
          <el-icon><el-icon-picture /></el-icon>
          <h3>图片预览</h3>
        </div>
        <div class="preview-content">
          <div class="image-grid">
            <div v-for="(imageUrl, index) in uploadedImages" :key="index" class="image-item">
              <el-image
                :src="imageUrl"
                fit="cover"
                class="preview-image"
              >
                <div slot="error" class="image-slot">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
              <div class="image-url">
                <el-input
                  :value="imageUrl"
                  readonly
                  class="url-input"
                >
                  <template slot="append">
                    <el-button @click="copyUrl(imageUrl)" class="copy-button">
                      <i class="el-icon-document-copy"></i> 复制
                    </el-button>
                  </template>
                </el-input>
                <div class="image-actions">
                  <el-button type="success" @click="openImageUrl(imageUrl)" class="open-button">
                    <i class="el-icon-view"></i> 打开
                  </el-button>
                  <el-button type="danger" @click="removeImage(index)" class="remove-button">
                    <i class="el-icon-delete"></i> 删除
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 共享访问 -->
    <div class="share-section">
      <div class="section-card">
        <div class="section-header">
          <el-icon><el-icon-link /></el-icon>
          <h3>共享访问</h3>
        </div>
        <div class="share-content">
          <p class="share-description">局域网内所有设备可通过以下地址访问所有图片URL：</p>
          <el-input
            v-model="shareUrl"
            readonly
            class="share-url-input"
          >
            <template slot="append">
              <el-button @click="copyUrl(shareUrl)" class="copy-button">
                <i class="el-icon-document-copy"></i> 复制
              </el-button>
            </template>
          </el-input>
          <el-button type="success" @click="openShareUrl" class="share-button">
            <i class="el-icon-view"></i> 打开共享页面
          </el-button>
        </div>
      </div>
    </div>
    
    <!-- 操作按钮 -->
    <div class="action-section">
      <el-button @click="resetForm" class="reset-button">
        <i class="el-icon-refresh-left"></i> 重置
      </el-button>
      <el-button type="warning" @click="initData" class="init-button">
        <i class="el-icon-remove-outline"></i> 数据初始化
      </el-button>
    </div>
  </div>
</template>

<script>
import request from '../utils/request'
import axios from 'axios'

export default {
  name: "ImageUpload",
  data() {
    return {
      uploadedImages: [],
      uploading: false,
      uploadProgress: 0,
      uploadStatus: '',
      shareUrl: ''
    };
  },
  mounted() {
    // 初始化共享地址
    // 使用主机的局域网IP地址，确保虚拟机能够访问
    // 请根据实际情况修改为你的主机局域网IP
    this.shareUrl = `http://10.12.52.1:8888/sysFile/url-list`;
  },
  methods: {
    /**
     * 上传前校验
     * @param file 上传的文件
     * @returns {boolean} 是否允许上传
     */
    beforeUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png' || file.type === 'image/webp';
      const isLt10M = file.size / 1024 / 1024 < 10;

      if (!isJPG) {
        this.$message.error('上传图片只能是 JPG、PNG 或 WEBP 格式!');
        return false;
      }
      if (!isLt10M) {
        this.$message.error('上传图片大小不能超过 10MB!');
        return false;
      }

      // 开始上传
      this.uploading = true;
      this.uploadProgress = 0;
      this.uploadStatus = '';
      return true;
    },

    /**
     * 上传进度回调
     * @param event 上传事件
     * @param file 文件对象
     * @param fileList 文件列表
     */
    handleUploadProgress(event, file, fileList) {
      this.uploadProgress = Math.round((event.loaded / event.total) * 100);
    },

    /**
     * 上传成功回调
     * @param response 响应数据
     * @param file 文件对象
     * @param fileList 文件列表
     */
    handleUploadSuccess(response, file, fileList) {
      this.uploading = false;
      this.uploadStatus = 'success';
      
      try {
        // 解析响应
        const responseData = typeof response === 'string' ? JSON.parse(response) : response;
        this.uploadedImageUrl = responseData.url;
        this.$message.success('图片上传成功！');
      } catch (error) {
        this.$message.error('上传成功但解析响应失败');
        console.error('解析响应失败:', error);
      }
    },

    /**
     * 上传失败回调
     * @param error 错误对象
     * @param file 文件对象
     * @param fileList 文件列表
     */
    handleUploadError(error, file, fileList) {
      this.uploading = false;
      this.uploadStatus = 'exception';
      this.$message.error('上传失败：' + (error.message || '未知错误'));
    },

    /**
     * 格式化进度条显示
     * @param percentage 百分比
     * @returns {string} 格式化后的文本
     */
    formatProgress(percentage) {
      return `${percentage}%`;
    },

    /**
     * 复制URL到剪贴板
     * @param url 要复制的URL
     */
    copyUrl(url) {
      navigator.clipboard.writeText(url)
        .then(() => {
          this.$message.success('URL已复制到剪贴板');
        })
        .catch(err => {
          this.$message.error('复制失败，请手动复制');
          console.error('复制失败:', err);
        });
    },

    /**
     * 打开共享页面
     */
    openShareUrl() {
      window.open(this.shareUrl, '_blank');
    },

    /**
     * 打开图片
     * @param imageUrl 图片URL
     */
    openImageUrl(imageUrl) {
      window.open(imageUrl, '_blank');
    },

    /**
     * 删除图片
     * @param index 图片索引
     */
    removeImage(index) {
      this.$confirm('确定要删除这张图片吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.uploadedImages.splice(index, 1);
        this.$message.success('图片删除成功！');
      }).catch(() => {
        // 取消删除
      });
    },



    /**
     * 上传图片
     * @param options 上传选项
     */
    uploadImage(options) {
      const file = options.file;
      const formData = new FormData();
      formData.append('file', file);
      
      this.uploading = true;
      this.uploadProgress = 0;
      this.uploadStatus = '';
      
      // 使用后端的SysFileController接口
      axios({
        url: '/sysFile/upload',
        method: 'post',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data'
        },
        onUploadProgress: (progressEvent) => {
          this.uploadProgress = Math.round((progressEvent.loaded / progressEvent.total) * 100);
        }
      }).then(response => {
        this.uploading = false;
        this.uploadStatus = 'success';
        
        try {
          // 解析响应
          console.log('完整响应:', response);
          console.log('响应状态:', response.status);
          console.log('响应头:', response.headers);
          
          let responseData = response.data;
          console.log('响应数据类型:', typeof responseData);
          console.log('响应数据:', responseData);
          
          // SysFileController的upload方法返回的是直接的URL字符串
          if (typeof responseData === 'string' && responseData.startsWith('http')) {
            this.uploadedImages.push(responseData);
            this.$message.success('图片上传成功！');
            options.onSuccess({ url: responseData });
          } else {
            this.$message.error('上传成功但响应格式错误');
            console.error('响应格式错误:', responseData);
            options.onError(new Error('响应格式错误'));
          }
        } catch (error) {
          this.$message.error('上传成功但解析响应失败');
          console.error('解析响应失败:', error);
          options.onError(error);
        }
      }).catch(error => {
        this.uploading = false;
        this.uploadStatus = 'exception';
        this.$message.error('上传失败：' + (error.message || '未知错误'));
        console.error('上传失败:', error);
        options.onError(error);
      });
    },
    
    /**
     * 重置表单
     */
    resetForm() {
      this.uploadedImages = [];
      this.uploading = false;
      this.uploadProgress = 0;
      this.uploadStatus = '';
    },
    
    /**
     * 数据初始化
     */
    initData() {
      this.$confirm('确定要清空所有图片URL列表吗？此操作不可恢复！', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 调用后端API清空URL列表
        axios.post('/sysFile/clear-url-list')
          .then(response => {
            if (response.data.code === "200") {
              this.$message.success('数据初始化成功！');
              // 同时清空本地图片列表
              this.uploadedImages = [];
            } else {
              this.$message.error('数据初始化失败：' + (response.data.msg || '未知错误'));
            }
          })
          .catch(error => {
            this.$message.error('数据初始化失败：' + (error.message || '网络错误'));
            console.error('清空URL列表失败:', error);
          });
      }).catch(() => {
        // 取消操作
      });
    }
  }
}
</script>

<style scoped>
.image-upload-container {
  padding: var(--spacing-lg);
  max-width: 1200px;
  margin: 0 auto;
  min-height: calc(100vh - 120px);
  background-color: var(--bg-color-secondary);
  border-radius: 12px;
  border: 1px solid var(--border-color-light);
}

/* 页面标题 */
.page-header {
  margin-bottom: var(--spacing-xl);
  padding: var(--spacing-xl);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: var(--border-radius-large);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
  color: white;
  animation: fadeInUp 0.6s ease-out;
  border: 1px solid var(--border-color);
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

/* 通用区块样式 */
.upload-section,
.preview-section,
.share-section {
  margin-bottom: var(--spacing-lg);
  animation: fadeIn 0.8s ease-out;
}

.section-card {
  background: var(--bg-color-secondary);
  border-radius: var(--border-radius-large);
  box-shadow: var(--box-shadow-light);
  overflow: hidden;
  border: 1px solid var(--border-color-light);
  transition: all 0.3s ease;
}

.section-card:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
}

.section-header {
  padding: var(--spacing-md) var(--spacing-lg);
  border-bottom: 1px solid var(--border-color-light);
  display: flex;
  align-items: center;
  background: var(--bg-color-tertiary);
}

.section-header el-icon {
  font-size: 20px;
  margin-right: 10px;
  color: var(--primary-color);
}

.section-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-color-primary);
}

/* 上传区域 */
.upload-content {
  padding: var(--spacing-lg);
}

.upload-area {
  border: 2px dashed var(--border-color-light);
  border-radius: var(--border-radius);
  padding: 40px 20px;
  text-align: center;
  transition: all 0.3s ease;
  background-color: var(--bg-color-tertiary);
}

.upload-area:hover {
  border-color: var(--primary-color);
  background-color: rgba(64, 158, 255, 0.05);
}

.upload-icon {
  font-size: 48px;
  color: var(--primary-color);
  margin-bottom: 16px;
  filter: drop-shadow(0 0 10px rgba(0, 123, 255, 0.3));
}

.upload-area h3 {
  margin: 0 0 12px 0;
  color: var(--text-color-primary);
  font-size: 18px;
  text-shadow: 0 0 10px rgba(100, 255, 218, 0.3);
}

.upload-tip {
  margin: 0 0 20px 0;
  color: var(--text-color-secondary);
  font-size: 14px;
}

.upload-button {
  margin-top: 10px;
  background: var(--primary-gradient);
  border: none;
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
}

.upload-button:hover {
  transform: translateY(-2px);
  box-shadow: var(--box-shadow);
}

.upload-progress {
  margin: 20px 0;
  height: 8px;
}

/* 预览区域 */
.preview-content {
  padding: var(--spacing-lg);
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--spacing-md);
  width: 100%;
}

.image-item {
  background: var(--bg-color-secondary);
  padding: var(--spacing-md);
  border-radius: var(--border-radius);
  box-shadow: var(--box-shadow-light);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.image-item:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
  transform: translateY(-3px);
}

.preview-image {
  width: 100%;
  height: 200px;
  border-radius: var(--border-radius);
  box-shadow: var(--box-shadow-light);
  margin-bottom: var(--spacing-md);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.preview-image:hover {
  transform: scale(1.02);
  box-shadow: var(--box-shadow);
}

.image-url {
  width: 100%;
}

.image-actions {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.image-actions .el-button {
  flex: 1;
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.image-actions .el-button:hover {
  transform: translateY(-2px);
  box-shadow: var(--box-shadow);
}

.remove-button:hover {
  box-shadow: 0 4px 12px rgba(255, 73, 73, 0.4);
}

.open-button:hover {
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.4);
}

.url-input {
  margin-bottom: 12px;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.copy-button {
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
}

.copy-button:hover {
  color: var(--primary-color);
  border-color: var(--primary-color);
}

/* 共享访问 */
.share-content {
  padding: var(--spacing-lg);
}

.share-description {
  margin: 0 0 16px 0;
  color: var(--text-color-regular);
  line-height: 1.5;
}

.share-url-input {
  margin-bottom: 16px;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.share-button {
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.share-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(103, 194, 58, 0.4);
}

/* 操作按钮 */
.action-section {
  display: flex;
  margin-bottom: var(--spacing-lg);
  gap: 10px;
  align-items: center;
}

.reset-button {
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.reset-button:hover {
  color: var(--primary-color);
  border-color: var(--primary-color);
  transform: translateY(-2px);
  box-shadow: var(--box-shadow);
}

.init-button {
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
}

.init-button:hover {
  color: var(--warning-color);
  border-color: var(--warning-color);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(230, 162, 60, 0.4);
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background-color: var(--bg-color-tertiary);
  color: var(--text-color-secondary);
  font-size: 48px;
  border-radius: var(--border-radius);
  border: 1px solid var(--border-color-light);
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
  .image-upload-container {
    padding: var(--spacing-md);
  }
  
  .page-header {
    padding: var(--spacing-lg);
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
  
  .section-card {
    padding: 0;
  }
  
  .upload-content,
  .preview-content,
  .share-content {
    padding: var(--spacing-md);
  }
  
  .upload-area {
    padding: 30px 15px;
  }
  
  .image-grid {
    grid-template-columns: 1fr;
  }
  
  .image-item {
    padding: var(--spacing-md);
  }
  
  .action-section {
    flex-wrap: wrap;
  }
}

@media (max-width: 480px) {
  .image-upload-container {
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
  
  .section-header {
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .upload-content,
  .preview-content,
  .share-content {
    padding: var(--spacing-sm);
  }
}
</style>
