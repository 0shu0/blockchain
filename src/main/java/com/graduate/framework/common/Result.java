package com.graduate.framework.common;

import java.io.Serializable;

public class Result implements Serializable {
    private String code;

    private String msg;

    private Object data;

    // 构造方法
    public Result() {
    }

    public Result(String code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    // Getter 方法
    public String getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

    public Object getData() {
        return data;
    }

    // Setter 方法
    public void setCode(String code) {
        this.code = code;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public static Result success(){
        return new Result("200","执行成功",null);
    }
    public static Result success(Object data){
        return new Result("200","执行成功",data);
    }
    public static Result error(){
        return new Result("500","执行失败",null);
    }
    public static Result error(String code,String msg){
        return new Result(code,msg,null);
    }
}
