<template>
  <div>
    <div>
      <el-input v-model="code" placeholder="请输入关键字"></el-input>
      <el-button type="primary" @click="search">溯源</el-button>
    </div>
    <div>
      <div>产品名称:{{traceData.name}}</div>
      <div>产地:{{traceData.origin}}</div>
      <div>厂家:{{traceData.manufacturer}}</div>
      <div>上架日期:{{traceData.listDate}}</div>
      <div>产品价格:{{traceData.price}}</div>
    </div>
  </div>
</template>

<script>
import {getProductByCode} from "@/http/Product";
import {getShopByCode} from "@/http/Shop";

export default {
  name: "Trace",
  data() {
    return {
      code: '',
      traceData:{
        name:'',
        origin:'',
        manufacturer:'',
        listDate:'',
        price:'',
      }
    }
  },
  methods: {
    search() {
      if(this.code=='')return;
      getProductByCode(this.code).then(res=>{
        console.log("pro=",res);
        this.traceData.name=res.name;
        this.traceData.origin=res.origin;
        this.traceData.manufacturer=res.manufacturer;
      });
      getShopByCode(this.code).then(res=>{
        console.log("shop=",res);
        this.traceData.listDate=res.listDate;
        this.traceData.price=res.price;
      });
    }
  }
}
</script>

<style scoped>

</style>
