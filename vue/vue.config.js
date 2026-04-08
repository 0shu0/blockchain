const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false,
  devServer: {
    host: '0.0.0.0',
    port: 8080,
    historyApiFallback: true,
    proxy: {
      '/WeBASE-Front': {
        target: 'http://192.168.88.133:5002',
        changeOrigin: true,
        timeout: 60000,
      }
    }
  }
})