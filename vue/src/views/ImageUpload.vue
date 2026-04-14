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
        <div class="table-header">
          <h3>图片上传列表</h3>
          <span class="table-count">{{ uploadedImages.length }} 条记录</span>
        </div>
        <div class="preview-content">
          <el-table 
            :data="uploadedImages" 
            border 
            stripe 
            style="width: 100%"
          >
            <el-table-column type="index" width="50" label="序号"></el-table-column>
            <el-table-column label="图片" width="80">
              <template slot-scope="scope">
                <el-image
                  :src="scope.row"
                  fit="cover"
                  class="table-image"
                >
                  <div slot="error" class="image-slot">
                    <i class="el-icon-picture-outline"></i>
                  </div>
                </el-image>
              </template>
            </el-table-column>
            <el-table-column prop="url" label="图片URL" min-width="400">
              <template slot-scope="scope">
                <el-input
                  :value="scope.row"
                  readonly
                  class="url-input"
                >
                  <template slot="append">
                    <el-button @click="copyUrl(scope.row)" class="copy-button">
                      <i class="el-icon-document-copy"></i> 复制
                    </el-button>
                  </template>
                </el-input>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="180" fixed="right">
              <template slot-scope="scope">
                <el-button 
                  type="primary" 
                  size="small" 
                  class="el-icon-view"
                  @click="openImageUrl(scope.row)"
                  title="打开"
                ></el-button>
                <el-button 
                  type="danger" 
                  size="small" 
                  class="el-icon-delete"
                  @click="removeImage(scope.$index)"
                  title="删除"
                ></el-button>
              </template>
            </el-table-column>
          </el-table>
          <div v-if="uploadedImages.length === 0" class="empty-state">
            <el-empty description="暂无图片数据" />
          </div>
        </div>
      </div>
    </div>
    
    <!-- 图片回传列表 -->
    <div class="return-section" v-if="returnImages.length > 0">
      <div class="section-card">
        <div class="table-header">
          <h3>图片回传列表</h3>
          <span class="table-count">{{ returnImages.length }} 条记录</span>
        </div>
        <div class="preview-content">
          <el-table 
            :data="returnImages" 
            border 
            stripe 
            style="width: 100%"
          >
            <el-table-column type="index" width="50" label="序号"></el-table-column>
            <el-table-column label="图片" width="80">
              <template slot-scope="scope">
                <el-image
                  :src="scope.row"
                  fit="cover"
                  class="table-image"
                >
                  <div slot="error" class="image-slot">
                    <i class="el-icon-picture-outline"></i>
                  </div>
                </el-image>
              </template>
            </el-table-column>
            <el-table-column prop="url" label="图片URL" min-width="400">
              <template slot-scope="scope">
                <el-input
                  :value="scope.row"
                  readonly
                  class="url-input"
                >
                  <template slot="append">
                    <el-button @click="copyUrl(scope.row)" class="copy-button">
                      <i class="el-icon-document-copy"></i> 复制
                    </el-button>
                  </template>
                </el-input>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" fixed="right">
              <template slot-scope="scope">
                <el-button 
                  type="primary" 
                  size="small" 
                  class="el-icon-view"
                  @click="openImageUrl(scope.row)"
                  title="打开"
                ></el-button>
              </template>
            </el-table-column>
          </el-table>
          <div v-if="returnImages.length === 0" class="empty-state">
            <el-empty description="暂无回传图片数据" />
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
      <el-button type="primary" @click="refreshData" class="refresh-button">
        <i class="el-icon-refresh"></i> 刷新
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
      returnImages: [],
      uploading: false,
      uploadProgress: 0,
      uploadStatus: '',
      shareUrl: '',
      config: {
        UploadImages: [],
        ReturnImages: []
      },
      loading: false
    };
  },
  mounted() {
    // 初始化共享地址
    // 使用主机的局域网IP地址，确保虚拟机能够访问
    // 请根据实际情况修改为你的主机局域网IP
    this.shareUrl = `http://10.12.52.1:8888/sysFile/url-list`;
    // 获取配置
    this.getConfig();
  },
  methods: {
    /**
     * 获取配置
     */
    getConfig() {
      this.loading = true;
      axios.get('/sysFile/config.json')
        .then(response => {
          if (response.data.code === "200") {
            this.config = response.data.data;
            // 渲染回传图片
            this.uploadedImages = this.config.UploadImages || [];
            // 渲染图片回传列表
            this.returnImages = this.config.ReturnImages || [];
          } else {
            this.$message.error('获取配置失败：' + (response.data.msg || '未知错误'));
          }
        })
        .catch(error => {
          this.$message.error('获取配置失败：' + (error.message || '网络错误'));
          console.error('获取配置失败:', error);
        })
        .finally(() => {
          this.loading = false;
        });
    },

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
      
      // 确定上传地址
      let uploadUrl = '/sysFile/upload';
      if (this.config.UploadImages && this.config.UploadImages.length > 0) {
        // 使用配置中的上传地址
        const index = this.uploadedImages.length;
        uploadUrl = this.config.UploadImages[index] || uploadUrl;
      }
      
      // 使用后端的SysFileController接口
      axios({
        url: uploadUrl,
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
            // 添加到配置中（使用完整的图片URL作为上传地址）
            this.addImageToConfig(responseData, responseData);
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
     * 添加图片到配置
     * @param uploadUrl 上传地址
     * @param returnUrl 回传地址
     */
    addImageToConfig(uploadUrl, returnUrl) {
      axios.post('/sysFile/addImage', {
        uploadUrl: uploadUrl,
        returnUrl: returnUrl
      }).then(response => {
        if (response.data.code === "200") {
          // 更新配置
          this.config = response.data.data;
          // 更新图片回传列表
          this.returnImages = this.config.ReturnImages || [];
        }
      }).catch(error => {
        console.error('添加图片到配置失败:', error);
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
              // 清空配置
              return axios.post('/sysFile/clearConfig');
            } else {
              throw new Error('清空URL列表失败');
            }
          })
          .then(response => {
            if (response.data.code === "200") {
              this.$message.success('数据初始化成功！');
              // 同时清空本地图片列表和配置
              this.uploadedImages = [];
              this.returnImages = [];
              this.config = {
                UploadImages: [],
                ReturnImages: []
              };
            } else {
              this.$message.error('清空配置失败：' + (response.data.msg || '未知错误'));
            }
          })
          .catch(error => {
            this.$message.error('数据初始化失败：' + (error.message || '网络错误'));
            console.error('清空URL列表失败:', error);
          });
      }).catch(() => {
        // 取消操作
      });
    },
    
    /**
     * 刷新数据
     */
    refreshData() {
      this.$message.info('正在刷新数据...');
      this.getConfig();
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
  height: 10px;
  border-radius: 5px;
  overflow: hidden;
}

.upload-progress .el-progress-bar__inner {
  border-radius: 5px;
  background: linear-gradient(90deg, var(--primary-color), #3a8ee6);
  transition: width 0.3s ease;
  box-shadow: 0 0 10px rgba(64, 158, 255, 0.5);
}

.upload-progress .el-progress__text {
  color: var(--text-color-secondary);
  font-size: 14px;
  margin-top: 5px;
}

/* 表格区域 */
.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-md) var(--spacing-lg);
  border-bottom: 1px solid var(--border-color-light);
  background: var(--bg-color-tertiary);
}

.table-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-color-primary);
  display: flex;
  align-items: center;
  gap: 10px;
}

.table-count {
  font-size: 14px;
  color: var(--text-color-secondary);
  background: var(--bg-color-secondary);
  padding: 5px 12px;
  border-radius: 20px;
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.table-count:hover {
  background: var(--primary-color);
  color: white;
  transform: scale(1.05);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
}

.preview-content {
  padding: var(--spacing-lg);
}

.el-table {
  border-radius: var(--border-radius);
  overflow: hidden;
  box-shadow: var(--box-shadow-light);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.el-table:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
}

.el-table th {
  background-color: var(--bg-color-tertiary) !important;
  font-weight: 600;
  color: var(--text-color-primary) !important;
  border-bottom: 1px solid var(--border-color-light) !important;
}

.el-table tr:hover {
  background-color: rgba(64, 158, 255, 0.05) !important;
  transition: background-color 0.3s ease;
}

.el-table td {
  border-bottom: 1px solid var(--border-color-light) !important;
  transition: all 0.3s ease;
}

.table-image {
  width: 40px;
  height: 40px;
  border-radius: var(--border-radius);
  object-fit: cover;
  transition: all 0.3s ease;
  cursor: pointer;
  border: 1px solid var(--border-color-light);
}

.table-image:hover {
  transform: scale(1.2);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  border-color: var(--primary-color);
}

.url-input {
  width: 100%;
  border-radius: var(--border-radius);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.url-input:hover {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.copy-button {
  min-width: 80px;
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
}

.copy-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
  background: var(--primary-color);
  border-color: var(--primary-color);
  color: white;
}

.empty-state {
  padding: 40px 20px;
  text-align: center;
  color: var(--text-color-secondary);
  background-color: var(--bg-color-tertiary);
  border-radius: var(--border-radius);
  margin-top: 20px;
  border: 1px solid var(--border-color-light);
}

/* 共享访问区域 */
.share-content {
  padding: var(--spacing-lg);
}

.share-description {
  font-size: 14px;
  color: var(--text-color-secondary);
  margin-bottom: 16px;
  line-height: 1.5;
}

.share-url-input {
  margin-bottom: 16px;
  border-radius: var(--border-radius);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color-light);
}

.share-url-input:hover {
  border-color: var(--primary-color);
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.share-button {
  margin-top: 8px;
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  background: var(--success-gradient);
  border: none;
}

.share-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(41, 182, 141, 0.4);
}

/* 操作按钮区域 */
.action-section {
  display: flex;
  gap: 12px;
  margin-top: var(--spacing-lg);
  justify-content: flex-start;
  flex-wrap: wrap;
  padding: var(--spacing-lg);
  background: var(--bg-color-secondary);
  border-radius: var(--border-radius-large);
  box-shadow: var(--box-shadow-light);
  border: 1px solid var(--border-color-light);
}

.reset-button,
.init-button,
.refresh-button {
  min-width: 120px;
  transition: all 0.3s ease;
  border-radius: var(--border-radius);
  font-weight: 500;
}

.reset-button {
  background: var(--bg-color-tertiary);
  border: 1px solid var(--border-color);
  color: var(--text-color-primary);
}

.reset-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  border-color: var(--primary-color);
  color: var(--primary-color);
}

.init-button {
  background: var(--warning-gradient);
  border: none;
  color: white;
}

.init-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
}

.refresh-button {
  background: var(--primary-gradient);
  border: none;
  color: white;
}

.refresh-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
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

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .header-stats {
    width: 100%;
    justify-content: space-around;
  }
  
  .action-section {
    flex-direction: column;
    gap: 10px;
  }
  
  .upload-area {
    padding: 30px 15px;
  }
  
  .section-card {
    margin-bottom: var(--spacing-lg);
  }
  
  .el-table {
    font-size: 14px;
  }
  
  .table-image {
    width: 30px;
    height: 30px;
  }
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: var(--bg-color-tertiary);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 4px;
  transition: all 0.3s ease;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--primary-color);
}

/* 图片回传列表样式 */
.return-section {
  margin-bottom: var(--spacing-lg);
  animation: fadeIn 0.8s ease-out;
}

.return-section .section-card {
  background: var(--bg-color-secondary);
  border-radius: var(--border-radius-large);
  box-shadow: var(--box-shadow-light);
  overflow: hidden;
  border: 1px solid var(--border-color-light);
  transition: all 0.3s ease;
}

.return-section .section-card:hover {
  box-shadow: var(--box-shadow);
  border-color: var(--border-color);
}

.return-section .section-header {
  padding: var(--spacing-md) var(--spacing-lg);
  border-bottom: 1px solid var(--border-color-light);
  display: flex;
  align-items: center;
  background: var(--bg-color-tertiary);
}

.return-section .section-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--text-color-primary);
  display: flex;
  align-items: center;
  gap: 10px;
}

/* 预览区域 */
.preview-content {
  padding: 0;
}

/* 表格样式 */
.table-header {
  padding: var(--spacing-md) var(--spacing-lg);
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

.preview-content .el-table {
  border-radius: 0;
  background: var(--bg-color-secondary);
}

.preview-content .el-table th {
  background: var(--bg-color-tertiary);
  font-weight: 600;
  color: var(--text-color-primary);
  border-bottom: 1px solid var(--border-color-light);
}

.preview-content .el-table td {
  color: var(--text-color-regular);
  border-bottom: 1px solid var(--border-color-lighter);
  padding: 12px;
}

.preview-content .el-table tr:hover {
  background-color: var(--bg-color-tertiary);
}

/* 空状态 */
.empty-state {
  padding: 60px 0;
  text-align: center;
}

/* URL输入框 */
.url-input {
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

/* 表格中的图片样式 */
.table-image {
  width: 40px;
  height: 40px;
  border-radius: 4px;
  border: 1px solid var(--border-color-light);
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 40px;
  height: 40px;
  background-color: var(--bg-color-tertiary);
  color: var(--text-color-secondary);
  font-size: 20px;
  border-radius: 4px;
  border: 1px solid var(--border-color-light);
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
