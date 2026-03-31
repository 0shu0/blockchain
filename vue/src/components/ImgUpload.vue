<template>
  <div>
    <el-upload
        class="avatar-uploader"
        action=""
        :show-file-list="false"
        :on-change="handleAvatarChange"
        :before-upload="beforeAvatarUpload"
    >
      <img v-if="imageUrl" :src="imageUrl" class="avatar" style="max-width: 150px;height:auto">
      <i v-else class="el-icon-plus avatar-uploader-icon"></i>
    </el-upload>
  </div>
</template>

<script>
export default {
  name: "ImgUpload",
  props: {
    value: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      imageUrl: this.value
    };
  },
  methods: {
    handleAvatarChange(file) {
      const isJPG = file.raw.type === 'image/jpeg' || file.raw.type === 'image/png' || file.raw.type === 'image/jpg';
      const isLt3M = file.size / 1024 / 1024 < 3;

      if (!isJPG) {
        this.$message.error('上传头像图片只能是 JPG/JPEG或 PNG 格式!');
      }
      if (!isLt3M) {
        this.$message.error('上传头像图片大小不能超过 3MB!');
      }
      if (isJPG && isLt3M) {
        this.convertToBase64(file);
      }
    },
    beforeAvatarUpload(file) {
      // 这里可以进行一些额外的验证
      return true;
    },
    convertToBase64(file) {
      let reader = new FileReader();
      reader.onload = (e) => {
        this.imageUrl = e.target.result;
        this.$emit('update:value',  this.imageUrl);
      }
      reader.readAsDataURL(file.raw); // 注意这里使用 raw 属性获取原始文件
    },
    resetImg(){
      this.imageUrl = null;
    }
  },
  watch:{
    value(val) {
      this.imageUrl = val;
    }
  }
}
</script>

<style scoped>

</style>
