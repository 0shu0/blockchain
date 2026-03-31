<template>
  <div>
    <el-autocomplete
        v-model="modelData"
        :fetch-suggestions="loadOptions"
        placeholder="请输入"
        @select="handleSelect">
      </el-autocomplete>
  </div>
</template>

<script>
export default {
  name: "DataAutocomplete",
  props:{
    value:{
      type:String,
      default:null
    },
    url:{
      type:String,
      required:true
    },
    fieldLabel:{
      type:String,
      required:true
    },
    fieldValue:{
      type:String,
      required:true
    }
  },
  data(){
    return{
      modelData:this.value,
      dataSource:[]
    }
  },
  methods:{
    loadOptions(queryString, cb) {
      console.log(queryString);
      this.request.get(this.url, {
        params: {
          pageNum: 1,
          pageSize: 99
        }
      }).then(res => {
        this.dataSource = res.data.records;
        cb(res.data.records.map(d => ({
          value: d[this.fieldValue],
          label: d[this.fieldLabel]
        })));
      })
    },
    handleSelect(item) {
      this.$emit('update:value', item.value);
      this.$emit('change',  this.dataSource.find(option => option[this.fieldLabel] === item.value));
    }
  },
  watch:{
    value(val) {
      this.modelData = val;
    }
  }
}
</script>

<style scoped>

</style>
