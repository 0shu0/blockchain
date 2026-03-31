<template>
  <div>
  </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
  name: "Home",
  data(){
    return {
      notice:{}
    }
  },
  mounted() {
    this.request('/notice/findNewNoticeList').then(res=>{
      this.notice = res.data[0]||{};
      if(this.notice.content){
        this.$notify({
          title: '最新公告',
          message: this.notice.content,
        });
      }
    })
  }
}
</script>

<style scoped>

</style>
