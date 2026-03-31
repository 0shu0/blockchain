<template>
  <el-container style="min-height: 100vh">
    <el-aside :width="sideWidth + 'px'">
     <Aside :isCollapse="isCollapse" :logoTextShow="logoTextShow"></Aside>
    </el-aside>

    <el-container>
      <el-header style="border-bottom: 1px solid #ccc">
       <Header @collapse="collapse" :collapseBtnClass="collapseBtnClass" :user="user"></Header>
      </el-header>

      <el-main>
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
      sideWidth:200,
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
        this.sideWidth = 48;
        this.logoTextShow = false;
        this.collapseBtnClass = 'el-icon-s-unfold';
      }else{
        this.sideWidth = 200;
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
/*去掉aside侧边栏的底部滚动条*/
.el-aside::-webkit-scrollbar {
  display: none;

}
</style>