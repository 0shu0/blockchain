<template>
  <div class="login-container">
    <div class="login-form">
      <div class="left-side">
        <img src="@/assets/login_inset.png" alt="Logo" class="logo-img">
      </div>
      <div class="right-side">
        <div style="font-size: 20px;margin-bottom:30px;font-weight: bold;text-align: center">注册用户</div>
        <el-form :model="userForm" :rules="rules" ref="userForm" label-width="100px" class="demo-ruleForm">
          <el-form-item label="用户名" prop="username">
            <el-input v-model="userForm.username" prefix-icon="el-icon-user"></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input v-model="userForm.password" prefix-icon="el-icon-lock" type="password" show-password></el-input>
          </el-form-item>
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input v-model="userForm.confirmPassword" prefix-icon="el-icon-lock" type="password"
                      show-password></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="register('userForm')">注册</el-button>
            <el-button type="success" @click="$router.push('/login')">返回登录</el-button>
            <el-button type="warning" @click="resetForm('userForm')">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>

  <!--  <div class="wrapper">-->

  <!--&lt;!&ndash;    项目名称&ndash;&gt;-->
  <!--    <div style="display: flex;width:55%;height:50%;margin: 150px auto;background-color: white;border-radius: 10px;overflow: hidden;background-color: bisque">-->
  <!--&lt;!&ndash;      左侧图片显示&ndash;&gt;-->
  <!--      <div style="width: 50%;margin-top: 30px;margin-left: 30px">-->
  <!--        <img src="../assets/register.png" alt="" style="width:100%;height:90%" />-->
  <!--      </div>-->
  <!--&lt;!&ndash;      提交表单&ndash;&gt;-->
  <!--      <div style="width:350px;margin-top: 30px">-->
  <!--        <div style="margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 10%">注册页面</div>-->
  <!--        <el-form :model="userForm" :rules="rules" ref="userForm" label-width="100px" class="demo-ruleForm">-->
  <!--          <el-form-item label="用户名" prop="username">-->
  <!--            <el-input v-model="userForm.username" prefix-icon="el-icon-user"></el-input>-->
  <!--          </el-form-item>-->
  <!--          <el-form-item label="密码" prop="password">-->
  <!--            <el-input v-model="userForm.password" prefix-icon="el-icon-lock" type="password" show-password></el-input>-->
  <!--          </el-form-item>-->
  <!--          <el-form-item label="确认密码" prop="confirmPassword">-->
  <!--            <el-input v-model="userForm.confirmPassword" prefix-icon="el-icon-lock" type="password" show-password></el-input>-->
  <!--          </el-form-item>-->
  <!--          <el-form-item>-->
  <!--            <el-button type="primary" @click="register('userForm')">注册</el-button>-->
  <!--            <el-button type="success" @click="$router.push('/login')">返回登录</el-button>-->
  <!--&lt;!&ndash;            <el-button type="warning" @click="resetForm('userForm')">重置</el-button>&ndash;&gt;-->
  <!--          </el-form-item>-->
  <!--        </el-form>-->
  <!--      </div>-->
  <!--    </div>-->
  <!--  </div>-->
</template>

<script>
export default {
  name: "Register",
  data() {
    return {
      userForm: {
      },
      rules: {
        username: [
          {required: true, message: '请输入用户名称', trigger: 'blur'},
          {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'blur'}
        ],
        password: [
          {required: true, message: '请输入密码', trigger: 'blur'},
          {min: 6, max: 50, message: '长度不能小于6位', trigger: 'blur'}
        ],
        confirmPassword: [
          {required: true, message: '请输入确认密码', trigger: 'blur'},
          {min: 6, max: 50, message: '长度不能小于6位', trigger: 'blur'}
        ]
      }
    }
  },
  methods: {
    //提交数据
    register(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if (this.userForm.password !== this.userForm.confirmPassword) {
            this.$message.warning("两次密码不一致，请重新输入");
            return;
          }
          this.request.post("/user/register", this.userForm).then(res => {
            if (res.code !== '200') {
              this.$message.error(res.msg);
            } else {
              this.$message.success("注册成功，请前往登录");
              this.$router.push("/login")
            }
          })
        } else {
          console.log('输入数据不正确，请重新输入');
          return false;
        }
      });
    },
    // 重置数据
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },

    // 验证码方法
    refreshCode() {
      this.identifyCode = ''
      this.makeCode(this.identifyCodes, 4);
    },
    makeCode(o, l) {
      for (let i = 0; i < l; i++) {
        this.identifyCode += this.identifyCodes[
            this.randomNum(0, this.identifyCodes.length)
            ]
      }
    },
    randomNum(min, max) {
      return Math.floor(Math.random() * (max - min) + min);
    }
  }
}
</script>

<style scoped>
.login-form {
  /*display: flex;*/
  width: 55%;
  height: 60%;
  margin: 150px auto;
  background-color: white;
  border-radius: 16px;
  overflow: hidden;
  background-color: white;
  box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.2);
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh; /* 使用视口单位使容器占据整个视口高度 */
  background-color: #f0f0f0;
  background-image: url("../assets/background.png");
}

.login-form {
  display: flex;
  width: 50%;
  height: 50%;
  background-color: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
}

.left-side {
  width: 50%;
  height: 100%; /* 占满高度 */
  background-color: #f0f0f0; /* 仅用于示例，实际使用时可去掉 */
}

.logo-img {
  width: 100%; /* 图片宽度占满 */
  height: 100%; /* 图片高度占满 */
  object-fit: cover; /* 保持宽高比填充 */
}

.right-side {
  display: flex;
  flex-direction: column;
  justify-content: center; /* 垂直居中 */
  width: 50%;
  padding: 20px;
}
</style>
