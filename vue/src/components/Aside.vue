<template>
  <el-menu default-active="1-4-1"
           class="el-menu-vertical-demo"
           :default-openeds="opens"
           style="min-height:100%;overflow-x: hidden;"
           text-color="#c0c4cc"
           active-text-color="#409eff"
           background-color="#2c3e50"
           :collapse-transition="true"
           router
           :collapse="isCollapse">
    <div class="logo-container">
<!--      <img src="../assets/logo.png" style="width:30px;position: relative;margin-right: 5px;top:6px">-->
      <b class="logo-text" v-show="logoTextShow">管理系统</b>
    </div>
    <div v-for="item in menus" :key="item.id" class="menu-item-wrapper">
      <div v-if="item.path">
        <el-menu-item :index="item.path" class="custom-menu-item">
          <img v-if="item.name === '主页'" src="../../../file/主页.png" alt="主页" class="menu-icon-img">
          <img v-else-if="item.name === '农产品管理'" src="../../../file/农产品.png" alt="农产品管理" class="menu-icon-img">
          <img v-else-if="item.name === '库存管理'" src="../../../file/库存.png" alt="库存管理" class="menu-icon-img">
          <img v-else-if="item.name === '溯源'" src="../../../file/溯源.png" alt="溯源" class="menu-icon-img">
          <img v-else-if="item.name === '公告管理'" src="../../../file/公告.png" alt="公告管理" class="menu-icon-img">
          <img v-else-if="item.name === '文件管理'" src="../../../file/文件.png" alt="文件管理" class="menu-icon-img">
          <i v-else :class="item.icon" class="menu-icon"></i>
          <span slot="title" class="menu-text">{{item.name}}</span>
        </el-menu-item>
      </div>
      <div v-else>
        <el-submenu :index="item.id + ''" class="custom-submenu">
          <template slot="title" class="submenu-title">
            <img v-if="item.name === '系统管理'" src="../../../file/四宫格.png" alt="系统管理" class="menu-icon-img">
            <i v-else :class="item.icon" class="menu-icon"></i>
            <span slot="title" class="menu-text">{{item.name}}</span>
          </template>
          <div v-for="subItem in item.children" :key="subItem.id" class="submenu-item-wrapper">
            <el-menu-item :index="subItem.path" class="custom-submenu-item">
              <template slot="title" class="submenu-item-title">
                <img v-if="subItem.name === '库存管理'" src="../../../file/库存.png" alt="库存管理" class="menu-icon-img">
                <i v-else :class="subItem.icon" class="menu-icon"></i>
                <span slot="title" class="menu-text">{{subItem.name}}</span>
              </template>
            </el-menu-item>
          </div>
        </el-submenu>
      </div>
    </div>
    <div class="menu-item-wrapper">
      <el-menu-item index="imageUpload" class="custom-menu-item">
        <img src="../../../file/图片.png" alt="图片处理" class="menu-icon-img">
        <span slot="title" class="menu-text">图片处理</span>
      </el-menu-item>
    </div>
    <div class="menu-item-wrapper">
      <el-menu-item index="productVisualization" class="custom-menu-item">
        <img src="../../../file/可视化.png" alt="农产品可视化" class="menu-icon-img">
        <span slot="title" class="menu-text">农产品可视化</span>
      </el-menu-item>
    </div>
  </el-menu>
</template>

<script>
export default {
  name: "Aside",
  props:{
    isCollapse:Boolean,
    logoTextShow:Boolean
  },
  data(){
    return{
      menus:localStorage.getItem("menus") ? JSON.parse(localStorage.getItem("menus")) : [],
      opens:localStorage.getItem("menus") ? JSON.parse(localStorage.getItem("menus")).map(v => v.id + '') : [],
    }
  }
}
</script>

<style scoped>
.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 220px;
  min-height: 100vh;
  border-right: none;
}

.el-menu-vertical-demo.el-menu--collapse {
  width: 60px;
  min-height: 100vh;
  border-right: none;
}

.el-menu-vertical-demo {
  box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);
}

.logo-container {
  height: 60px;
  line-height: 60px;
  text-align: center;
  background: linear-gradient(135deg, #1890ff 0%, #096dd9 100%);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  margin-bottom: 20px;
  transition: all 0.3s ease-in-out;
}

.el-menu--collapse .logo-container {
  margin-bottom: 10px;
}

.logo-text {
  color: white;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: 1px;
}

.menu-item-wrapper {
  margin-bottom: 8px;
}

.custom-menu-item {
  height: 50px;
  line-height: 50px;
  margin: 0 10px;
  border-radius: 6px;
  transition: all 0.3s ease;
  text-align: left;
}

.custom-menu-item:hover {
  background-color: rgba(64, 158, 255, 0.1) !important;
}

.custom-menu-item.is-active {
  background-color: rgba(64, 158, 255, 0.2) !important;
}

.custom-submenu {
  margin: 0 10px;
  border-radius: 6px;
  overflow: hidden;
}

.submenu-title {
  height: 50px;
  line-height: 50px;
  transition: all 0.3s ease;
  text-align: left;
}

.custom-submenu:hover .submenu-title {
  background-color: rgba(64, 158, 255, 0.1) !important;
}

.submenu-item-wrapper {
  padding-left: 10px;
  transition: all 0.3s ease;
}

.custom-submenu-item {
  height: 44px;
  line-height: 44px;
  border-radius: 6px;
  transition: all 0.3s ease;
  text-align: left;
}

.custom-submenu-item:hover {
  background-color: rgba(64, 158, 255, 0.1) !important;
}

.custom-submenu-item.is-active {
  background-color: rgba(64, 158, 255, 0.2) !important;
}

/* 收缩状态下的样式 */
.el-menu--collapse .custom-menu-item {
  margin: 0 5px;
  text-align: center;
}

.el-menu--collapse .custom-submenu {
  margin: 0 5px;
}

.el-menu--collapse .submenu-title {
  text-align: center;
}

.el-menu--collapse .submenu-item-wrapper {
  padding-left: 0;
}

.el-menu--collapse .custom-submenu-item {
  margin: 0 5px;
  text-align: center;
}

.el-menu--collapse .menu-icon-img {
  margin-right: 0;
}

.el-menu--collapse .menu-icon {
  margin-right: 0;
}

/* 确保收起导航栏时没有文字显示 */
.el-menu--collapse .menu-text {
  display: none;
}

.el-menu--collapse .el-submenu__title span {
  display: none;
}

.el-menu--collapse .el-menu-item__content span {
  display: none;
}

.menu-icon-img {
  width: 20px;
  height: 20px;
  object-fit: contain;
  margin-right: 12px;
  vertical-align: middle;
}

.menu-icon {
  font-size: 18px;
  margin-right: 12px;
  vertical-align: middle;
}

.menu-text {
  font-size: 14px;
  font-weight: 400;
  vertical-align: middle;
}

.submenu-item-title {
  display: flex;
  align-items: center;
  width: 100%;
  height: 100%;
}

/* 滚动条样式 */
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}
</style>
