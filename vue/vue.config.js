const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave:false,
  devServer: {
    proxy: {
      '/WeBASE-Front': {
        target: 'http://192.168.217.141:5002', // 目标地址
        changeOrigin: true, // 是否更改源
        pathRewrite: {
          '^/WeBASE-Front': '/WeBASE-Front/trans/handle' // 路径重写
        }
      }
    }
  }
})
