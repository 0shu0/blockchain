import Vue, {set} from 'vue'
import VueRouter from 'vue-router'
import store from '../store'
Vue.use(VueRouter)
import { Notification, MessageBox, Message, Loading } from 'element-ui'
import ElementUI from 'element-ui'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import(/* webpackChunkName: "about" */ '../views/Login.vue'),
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import(/* webpackChunkName: "about" */ '../views/Register.vue'),
  },
  {
    path: '/404',
    name: '404',
    component: () => import(/* webpackChunkName: "about" */ '../views/404.vue'),
  },
  {
    path: '/front',
    name: 'front',
    redirect:'./front/home',
    component: () => import(/* webpackChunkName: "about" */ '../views/front/Front.vue'),
    children:[
      {
        path: 'home',
        name: 'home',
        component: () => import(/* webpackChunkName: "about" */ '../views/front/Home.vue'),
      },
      {
        path: 'password',
        name: 'password',
        component: () => import(/* webpackChunkName: "about" */ '../views/front/Password.vue'),
      },
      {
        path: 'person',
        name: 'person',
        component: () => import(/* webpackChunkName: "about" */ '../views/front/Person.vue'),
      },
    ]
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

//重置路由器里面的路由集合
export const resetRoutes = () => {
    router.matcher = new VueRouter({
      mode: 'history',
      base: process.env.BASE_URL,
      routes
  })
}

export const setRoutes  = () => {
  //获取浏览器缓存的菜单数据
  const localMenus = localStorage.getItem("menus") ;
  if(localMenus){
   const currentRoutes =  router.getRoutes().map(v => v.name);
   if(!currentRoutes.includes('manage')){
     //当前Router不包含manage，在拼装
     const manageRoute =  {
           path: '/',
           name: 'manage',
           redirect:'/home',
           component: () => import(/* webpackChunkName: "about" */ '../views/Manage.vue'),
           children:[
             {
               path: 'person',
               name: 'person',
               component: () => import(/* webpackChunkName: "about" */ '../views/Person.vue'),
             },
             {
               path: 'password',
               name: 'password',
               component: () => import(/* webpackChunkName: "about" */ '../views/Password.vue'),
             },
             {
               path: 'home',
               name: '主页',
               component: () => import(/* webpackChunkName: "about" */ '../views/Home.vue'),
             },
             {
               path: 'imageUpload',
               name: '图片处理',
               component: () => import(/* webpackChunkName: "about" */ '../views/ImageUpload.vue'),
             },
             {
               path: 'productVisualization',
               name: '农产品可视化',
               component: () => import(/* webpackChunkName: "about" */ '../views/ProductVisualization.vue'),
             }
           ]
         };
     const menus = JSON.parse(localMenus);
     menus.forEach(item => {
       if(item.path){
         const itemMenu = {
           path:item.path.replace("/",""),
           name:item.name,
           component: () => import(/* webpackChunkName: "about" */ '../views/' + item.pagePath + '.vue'),
         };
         manageRoute.children.push(itemMenu);
       }else if(item.children.length){
         item.children.forEach(item => {
           const itemMenu = {
             path:item.path.replace("/",""),
             name:item.name,
             component: () => import(/* webpackChunkName: "about" */ '../views/' + item.pagePath + '.vue'),
           };
           manageRoute.children.push(itemMenu);
         })
       }
     })
     router.addRoute(manageRoute);
     console.log('1---重新加入manage路由')
     console.log('1---重新加入manage路由')
     console.log('1---重新加入manage路由')
     console.log(router.getRoutes())
   }else{
     console.log('未重新加入manage路由')
     console.log('未重新加入manage路由')
     console.log('未重新加入manage路由')
     console.log(router.getRoutes())
   }
  }
}

setRoutes()

router.beforeEach((to,from,next) => {
  localStorage.setItem('currentPathName',to.name);
  store.commit('setPath')
  const localMenus = localStorage.getItem("menus");
  if(!to.matched.length){
    //没有匹配到路由（也就是未找到路由)
    if(localMenus){
      //用户登录了
      next('/404')
    }else{
      ElementUI.Message({
        message: '请先登录',
        type: 'warning'
      });
      next('/login')
    }
  }
  next();
})
export default router
