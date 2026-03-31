import axios from 'axios'
import { Notification, MessageBox, Message, Loading } from 'element-ui'
import ElementUI from 'element-ui'
import router from "@/router";

const request = axios.create({
    baseURL:'http://localhost:8888/',
    timeout:5000
})

request.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=UTF-8'
    let user = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : null
    if(user){
        config.headers["token"] = user.token;
    }
    return config;
},error => {
    return Promise.reject(error)
})

request.interceptors.response.use(
    response => {
        let res = response.data;
        if(response.config.responseType === 'blob'){
            return res;
        }
        if(typeof res === 'string'){
            res = res ? JSON.parse(res) : res
        }
        // 当权限验证不通过的时候给出提示
        if (res.code === '401') {
            ElementUI.Message({
                message: res.msg,
                type: 'error'
            });
            if (router.currentRoute.fullPath  !== '/login') {
                router.push('/login')
            }
        }
        return res;
    },
    error => {
        if(error.code === '401'){
            router.push("/login")
        }
        Message.error(error)
        return Promise.reject(error);
    }
)

export default request