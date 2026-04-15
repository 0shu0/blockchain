<template>
  <div class="header-content">
    <div class="header-left">
      <span :class="collapseBtnClass" class="collapse-btn" @click="collapse"></span>
      <el-breadcrumb separator="/" class="breadcrumb" >
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item><b>{{currentPathName}}</b></el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <el-dropdown class="user-dropdown" @command="handleCommand">
      <div class="user-info">
        <img :src="avatarUrl" class="user-avatar" @error="handleAvatarLoadError"/>
        <el-tooltip  effect="dark" placement="top" :content="user.username">
          <span class="user-name">{{ truncatedText }}</span>
          <i class="el-icon-arrow-down user-arrow"></i>
        </el-tooltip>
      </div>

      <el-dropdown-menu slot="dropdown" class="dropdown-menu">
        <el-dropdown-item command="person" class="dropdown-item">
          <i class="el-icon-user"></i>
          <span>个人信息</span>
        </el-dropdown-item>
        <el-dropdown-item command="password" class="dropdown-item">
          <i class="el-icon-lock"></i>
          <span>修改密码</span>
        </el-dropdown-item>
        <el-dropdown-item command="logout" class="dropdown-item">
          <i class="el-icon-switch-button"></i>
          <span>退出登录</span>
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>

  </div>
</template>

<script>
import router from "@/router";

export default {
  name: "Header",
  props:{
    collapseBtnClass:String,
    user:Object
  },
  data() {
    return {
      defaultAvatar: 'http://localhost:8888/file/猫.png',
      avatarLoadFailed: false
    };
  },
  watch: {
    'user.headerUrl'() {
      this.avatarLoadFailed = false;
    }
  },
  computed:{
    truncatedText() {
      if (this.user.username?.length > 8) {
        return this.user.username.substring(0, 8) + '...';
      }
      return this.user.username;
    },
    currentPathName(){
      return this.$store.state.currentPathName;
    },
    avatarUrl() {
      // 优先使用用户头像，加载失败后自动回退默认头像
      if (!this.avatarLoadFailed && this.user.headerUrl && this.user.headerUrl !== '') {
        return this.user.headerUrl;
      }
      return this.defaultAvatar;
    }
  },
  methods:{
    handleAvatarLoadError(event) {
      this.avatarLoadFailed = true;
      if (event && event.target) {
        event.target.src = this.defaultAvatar;
      }
    },
    collapse(){
      this.$emit('collapse')
    },
    logout(){
      this.request.post('/user/logout').then(res => {
        if(res.code === '200'){
          this.$store.commit('logout');
          this.$message.success('退出登录成功');
        }else{
          this.$message.error('退出登录失败');
        }
      })
    },
    handleCommand(command) {
      if (command === 'person') {
        this.$router.push('/person');
      } else if (command === 'password') {
        this.$router.push('/password');
      } else if (command === 'logout') {
        this.logout();
      }
    }
  }
}
</script>

<style scoped>
.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 100%;
}

.header-left {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: #333333;
  transition: color var(--transition-fast), transform var(--transition-fast);
  padding: var(--spacing-sm);
  border-radius: var(--border-radius);
}

.collapse-btn:hover {
  color: var(--primary-color);
  transform: scale(1.1);
  background-color: #f0f2f5;
}

.breadcrumb {
  font-size: var(--font-size-base);
}

.breadcrumb .el-breadcrumb__inner {
  color: #666666;
}

.breadcrumb .el-breadcrumb__item:last-child .el-breadcrumb__inner {
  color: var(--primary-color);
  font-weight: 500;
}

.user-dropdown {
  cursor: pointer;
  transition: all var(--transition-fast);
}

.user-info {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--border-radius);
  transition: background-color var(--transition-fast);
}

.user-info:hover {
  background-color: #f0f2f5;
}

.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #f0f2f5;
  transition: transform var(--transition-fast);
}

.user-info:hover .user-avatar {
  transform: scale(1.05);
}

.user-name {
  font-size: var(--font-size-base);
  color: #333333;
  font-weight: 500;
}

.user-arrow {
  font-size: 12px;
  color: #666666;
  transition: transform var(--transition-fast);
}

.user-info:hover .user-arrow {
  transform: rotate(180deg);
}

.dropdown-menu {
  min-width: 150px;
  border-radius: var(--border-radius-large);
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border: 1px solid #e4e7ed;
  animation: dropdownFadeIn 0.3s ease-out;
  background-color: #FFFFFF;
}

.dropdown-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-sm) var(--spacing-md);
  transition: all var(--transition-fast);
  font-size: var(--font-size-base);
  color: #333333;
}

.dropdown-item:hover {
  background-color: #f0f2f5;
  color: var(--primary-color);
}

.dropdown-item i {
  font-size: 14px;
  width: 16px;
  text-align: center;
}

/* 动画定义 */
@keyframes dropdownFadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .header-left {
    gap: var(--spacing-sm);
  }
  
  .breadcrumb {
    font-size: var(--font-size-small);
  }
  
  .user-name {
    display: none;
  }
  
  .user-avatar {
    width: 32px;
    height: 32px;
  }
}
</style>
