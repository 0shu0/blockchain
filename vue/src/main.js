import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

import './assets/global.css'

import request from "@/utils/request";

// main.js全局注册
import mavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import {Notification} from "element-ui";
// use
Vue.use(mavonEditor)

Vue.use(ElementUI);

Vue.config.productionTip = false

Vue.prototype.request = request
Vue.prototype.$notify = Notification


new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
