<template>
  <el-card style="width: 50%;margin: auto">
    <el-form label-width="100px" :model="form" :rules="rules" ref="userForm">
      <el-form-item label="原密码" prop="password">
        <el-input v-model="form.password" autocomplete="off" type="password" show-password></el-input>
      </el-form-item>
      <el-form-item label="新密码" prop="newPassword">
        <el-input v-model="form.newPassword" autocomplete="off" type="password" show-password></el-input>
      </el-form-item>
      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input v-model="form.confirmPassword" autocomplete="off" type="password" show-password></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="updatePassword('userForm')">确认修改 </el-button>
      </el-form-item>
    </el-form>
  </el-card>

</template>

<script>
export default {
  name: "Password",
  data(){
    return {
      form:{},
      rules: {
        password: [
          { required: true, message: '请输入原先密码', trigger: 'blur' },
          { min: 6, max: 50, message: '长度不能小于6位', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, max: 50, message: '长度不能小于6位', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请输入确认密码', trigger: 'blur' },
          { min: 6, max: 50, message: '长度不能小于6位', trigger: 'blur' }
        ]
      }
    }
  },
  methods:{
    updatePassword(formName){
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if(this.form.newPassword !== this.form.confirmPassword){
            this.$message.warning('新密码和确认密码不一致');
            return;
          }
          this.form.id = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')).id : null;
          this.request.post('/user/updatePassword',this.form).then(res => {
            if(res.code === '200'){
              this.$message.success('密码更新成功，请重新登录')
              this.request.post('/user/logout').then(res => {
                if(res.code === '200'){
                  this.$store.commit('logout');
                }else{
                  this.$message.error('退出登录失败');
                }
              })
            }else{
              this.$message.error(res.msg);
            }
          })
        }else{
          this.$message.warning('输入信息不正确');
          return;
        }


      })
    }
  }
}
</script>

<style scoped>

</style>