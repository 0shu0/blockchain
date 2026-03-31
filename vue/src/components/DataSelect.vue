<template>
  <div>
    <el-select
        mode="combobox"
        style="width:100%"
        v-model="selectedLabel"
        :filter-option="false"
        :not-found-content="null"
        :placeholder="placeholder"
        @search="onSearch"
        @change="onChange"
    >
      <el-option
          v-for="(option, index) in dynamicOptions"
          :key="option.label"
          :value="option.value"
      >
        {{ option.label }}
      </el-option>
    </el-select>
  </div>
</template>

<script>


export default {
  name: "DataSelect",
  props: {
    value: {
      type: String,
      default: null
    },
    placeholder: {
      type: String,
      default: '请选择'
    },
    url: {
      type: String,
      required: true
    },
    urlParams: {
      type: Object,
      default: null
    },
    displayField: {
      type: String,
      default: 'name'
    }
  },
  data() {
    return {
      selectedLabel: this.value,
      selectedValue: this.value,
      dynamicOptions: [],
      dataSource:[]
    };
  },
  created() {
    this.loadData();
  },
  methods: {
    onChange(value) {
      this.selectedValue = value;
      this.selectedLabel = this.dynamicOptions.find(option => option.value === value)?.label || '';
      this.$emit('update:value', value);
      this.$emit('change', this.dataSource.find(option => option[this.displayField] === value));
    },
    loadData() {
      this.fetchOptions(this.urlParams);
    },
    onSearch(query) {
      let params = {};
      params[this.displayField] = query;
      this.dynamicOptions = [];
      this.fetchOptions(params);
    },
    async fetchOptions(urlParams) {
      let params = {...{pageNum: 1, pageSize: 99}, ...urlParams}
      this.request.get(this.url+'?pageNum=1&pageSize=99', params).then(res => {
        this.dataSource = res.data.records;
        this.dynamicOptions = res.data.records.map(material => ({
          value: material[this.displayField],
          label: material[this.displayField]
        }));
      })
    },
    resetVal(){
      this.selectedLabel = '';
      this.value = '';
    }
  },
  watch:{
    value(val) {
      this.onChange(val);
    }
  }
}
</script>

<style scoped>

</style>
