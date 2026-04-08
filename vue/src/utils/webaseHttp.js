import axios from 'axios'
import { Notification, MessageBox, Message, Loading } from 'element-ui'
import ElementUI from 'element-ui'
import router from "@/router";

const webaseHttp = axios.create({
    baseURL:'',
    timeout: 5000,
})

webaseHttp.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=UTF-8'
    return config;
},error => {
    return Promise.reject(error)
})

webaseHttp.interceptors.response.use(
    response => {
        let res = response;

        let data = "";
        try{
            if(res.data.hasOwnProperty('statusMsg'))
                return res.data;
            data = JSON.parse(res.data);
            return data;
        }
        catch (e) {
            if(res.hasOwnProperty('errorMessage') || res.code==201151
                ||res.data[0]?.indexOf("error")>0){
                data = res.data[0] || "未知错误";
                ElementUI.Message({
                    message: data,
                    type: 'error'
                });
                return res.data[0];
            }
        }
    },
    error => {
        Message.error(error)
        return Promise.reject(error);
    }
)

export default webaseHttp