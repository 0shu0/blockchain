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
            // 检查响应体中是否包含错误信息
            if(data && (data.code === 422 || data.error || data.message)) {
                ElementUI.Message({
                    message: data.message || data.error || '请求失败',
                    type: 'error'
                });
                return Promise.reject(data);
            }
            return data;
        }
        catch (e) {
            if(res.hasOwnProperty('errorMessage') || res.code==201151
                ||res.data[0]?.indexOf("error")>0 || res.data[0]?.indexOf("422")>0){
                data = res.data[0] || "未知错误";
                ElementUI.Message({
                    message: data,
                    type: 'error'
                });
                return Promise.reject(data);
            }
            // 如果响应体无法解析为JSON，返回Promise.reject
            return Promise.reject(new Error('响应体解析失败'));
        }
    },
    error => {
        Message.error('请求失败：' + (error.message || '未知错误'))
        return Promise.reject(error);
    }
)

export default webaseHttp