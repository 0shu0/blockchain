<template>
  <el-container class="manage-container">
    <el-aside :width="sideWidth + 'px'" class="aside-container">
     <Aside :isCollapse="isCollapse" :logoTextShow="logoTextShow"></Aside>
    </el-aside>

    <el-container class="main-container">
      <el-header class="header-container">
       <Header @collapse="collapse" :collapseBtnClass="collapseBtnClass" :user="user"></Header>
      </el-header>

      <el-main class="main-content">
        <router-view @refreshUser="getUser"></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import Aside from "@/components/Aside";
import Header from "@/components/Header";
export default {
  name: "Manage",
  components:{
    Aside,Header
  },
  data(){
    return{
      isCollapse:false,
      logoTextShow:true,
      collapseBtnClass:'el-icon-s-fold',
      sideWidth:220,
      user:{}
    }
  },
  created() {
    this.getUser();
  },
  methods:{
    collapse(){
      this.isCollapse = !this.isCollapse;
      if(this.isCollapse){
        //收缩
        this.sideWidth = 60;
        this.logoTextShow = false;
        this.collapseBtnClass = 'el-icon-s-unfold';
      }else{
        this.sideWidth = 220;
        this.logoTextShow = true;
        this.collapseBtnClass = 'el-icon-s-fold';
      }
    },
    getUser(){
      let id = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).id : null;
      if(id){
        this.request.get("/user/findById/" + id).then(res => {
          if(res.code === '200'){
            this.user = res.data;
          }else{
            this.$message.error('找不到用户信息');
          }
        })
      }else{
        this.$message.error('找不到用户信息');
      }
    }
  }
}
</script>

<style scoped>
.manage-container {
  min-height: 100vh;
  background-color: var(--bg-color-secondary);
}

/* 侧边栏样式 */
.aside-container {
  transition: width var(--transition-normal);
  background-color: #2c3e50;
  box-shadow: var(--box-shadow-light);
  overflow: hidden;
}

/* 主容器样式 */
.main-container {
  transition: all var(--transition-normal);
  background-color: var(--bg-color-secondary);
}

/* 头部样式 */
.header-container {
  height: 60px;
  padding: 0 var(--spacing-lg);
  background-color: #FFFFFF;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* 主内容区样式 */
.main-content {
  padding: 0;
  min-height: calc(100vh - 60px);
  transition: all var(--transition-normal);
}

/* 页面过渡动画 */
.page-enter-active,
.page-leave-active {
  transition: opacity var(--transition-normal), transform var(--transition-normal);
}

.page-enter,
.page-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .main-content {
    padding: var(--spacing-md);
  }
  
  .header-container {
    padding: 0 var(--spacing-md);
  }
}
</style>