import Vue from 'vue'
import Vuex from 'vuex'
import router, {resetRoutes} from "@/router";

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    currentPathName:''
  },
  getters: {
  },
  mutations: {
    setPath(state){
      state.currentPathName = localStorage.getItem('currentPathName');
    },
    logout(){
      localStorage.removeItem("user")
      localStorage.removeItem("currentPathName")
      localStorage.removeItem("menus")
      resetRoutes();
      router.push('/login');
    }
  },
  actions: {
  },
  modules: {
  }
})
