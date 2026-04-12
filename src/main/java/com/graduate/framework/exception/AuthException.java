package com.graduate.framework.exception;

import lombok.Data;

@Data
public class AuthException extends RuntimeException{

    private String code;

    public AuthException( String code,String msg) {
        super(msg);
        this.code = code;
    }

    // Getter and Setter methods
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
}
