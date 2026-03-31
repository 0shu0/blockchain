<template>
  <el-menu default-active="1-4-1"
           class="el-menu-vertical-demo"
           :default-openeds="opens"
           style="min-height:100%;overflow-x: hidden;"
           text-color="#fff"
           active-text-color="#ffd046"
           background-color="rgb(48,65,86)"
           :collapse-transition="false"
           router
           :collapse="isCollapse">
    <div style="height: 60px;line-height: 60px;text-align: center">
<!--      <img src="../assets/logo.png" style="width:30px;position: relative;margin-right: 5px;top:6px">-->
      <b style="color:white" v-show="logoTextShow">管理系统</b>
    </div>
    <div v-for="item in menus" :key="item.id">
      <div v-if="item.path">
        <el-menu-item :index="item.path">
          <i :class="item.icon"></i>
          <span slot="title">{{item.name}}</span>
        </el-menu-item>
      </div>
      <div v-else>
        <el-submenu :index="item.id + ''">
          <template slot="title">
            <i :class="item.icon"></i>
            <span slot="title">{{item.name}}</span>
          </template>
          <div v-for="subItem in item.children" :key="subItem.id">
            <el-menu-item  :index="subItem.path">
              <template slot="title">
                <i :class="subItem.icon"></i>
                <span slot="title">{{subItem.name}}</span>
              </template>
            </el-menu-item >
          </div>
        </el-submenu>
      </div>

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
  width: 200px;
  min-height: 400px;
}
::-webkit-scrollbar {
  width: 0 !important;
}
::-webkit-scrollbar {
  width: 0 !important;height: 0;
}
</style>
