<template>
  <div style="line-height: 60px;display: flex">
    <div style="flex: 1;font-size: 30px">
      <span :class="collapseBtnClass" style="cursor: pointer" @click="collapse"></span>
      <el-breadcrumb separator="/" style="display: inline-block;margin-left:10px;position: absolute;top:22px" >
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item><b>{{currentPathName}}</b></el-breadcrumb-item>
      </el-breadcrumb>
    </div>


    <el-dropdown style="width: 150px;cursor: pointer;text-align: center">
      <div style="display: inline-block">
        <img :src="avatarUrl" style="width:65px;height:45px;border-radius: 50%;position: relative;top:10px;right:8px"/>
        <el-tooltip  effect="dark" placement="top" :content="user.username">
          <span>{{ truncatedText }}</span>
          <i class="el-icon-arrow-down" style="margin-left:5px"></i>
        </el-tooltip>
      </div>

      <el-dropdown-menu slot="dropdown" style="width: 100px;text-align: center;text-decoration: none">
        <el-dropdown-item style="font-size: 15px;padding:5px 0">
          <router-link to="/person" style="text-decoration: none;color: #606266">个人信息</router-link>
        </el-dropdown-item>
        <el-dropdown-item style="font-size: 15px;padding:5px 0">
          <router-link to="/password" style="text-decoration: none;color: #606266">修改密码</router-link>
        </el-dropdown-item>
        <el-dropdown-item style="font-size: 15px;padding:5px 0">
          <div style="text-decoration: none" @click="logout">退出登录</div>
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
      // 如果用户有设置头像，则使用用户的头像
      if (this.user.headerUrl && this.user.headerUrl !== '') {
        return this.user.headerUrl;
      }
      // 否则使用默认头像，从file目录中选择
      // 这里使用一个默认的头像路径，可以根据实际情况修改
      return 'http://localhost:8888/file/猫.png';
    }
  },
  methods:{
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
    }
  }
}
</script>

<style scoped>

</style>
