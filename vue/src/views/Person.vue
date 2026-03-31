<template>
  <el-card style="width: 500px">
    <el-form label-width="100px">
      <el-form-item label="用户名">
        <el-input v-model="form.username" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="用户头像" >
        <el-upload
            class="avatar-uploader"
            action="http://localhost:8888/sysFile/upload"
            :show-file-list="false"
            :on-success="handleAvatarSuccess"
            :before-upload="beforeAvatarUpload"
            :on-error="handleAvatarError">
          <img v-if="form.headerUrl" :src="form.headerUrl" class="avatar" style="border: 1px dashed gray;">
          <i v-else class="el-icon-plus avatar-uploader-icon" style="border: 1px dashed gray;"></i>
        </el-upload>
      </el-form-item>
      <el-form-item label="昵称">
        <el-input v-model="form.nickname" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="地址">
        <el-input v-model="form.address" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="邮箱">
        <el-input v-model="form.email" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="电话">
        <el-input v-model="form.phone" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="save">确认修改 </el-button>
      </el-form-item>
    </el-form>
  </el-card>
</template>

<script>
export default {
  name: "Person",
  data(){
    return{
      form:{}
    }
  },
  created() {
    let id = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).id : null;
    if(id){
      this.request.get("/user/findById/" + id).then(res => {
        if(res.code === '200'){
          this.form = res.data;
        }else{
          this.$message.error('找不到用户信息');
        }
      })
    }else{
      this.$message.error('找不到用户信息');
    }
  },
  methods:{
    save(){
      this.request.post("/user/save",this.form).then(res => {
        if(res.code === '200'){
          this.$message.success("更新成功")
          this.$emit('refreshUser');  //调用父组件的方法更新

          let existUser = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : {}
          existUser.headerUrl = this.form.headerUrl
          localStorage.removeItem('user')
          localStorage.setItem('user',JSON.stringify(existUser));

        }else{
          this.$message.error('更新失败，请联系管理员');
        }
      })
    },
    handleAvatarSuccess(res, file) {
      this.form.headerUrl = res
      this.$message.success("上传成功")
      //页面传的数值动态改变，但是接受的数据不会及时显示，通过这个方法强制刷新页面解决问题
      this.$forceUpdate();
    },
    beforeAvatarUpload(file) {
      const isLt2M = file.size / 1024 / 1024 < 2;
      if (!isLt2M) {
        this.$message.error('上传轮播图大小不能超过 2MB!');
      }
      return  isLt2M;
    },
    handleAvatarError(){
      this.$message.error('上传失败!');
    }
  }
}
</script>

<style scoped>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}
.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>