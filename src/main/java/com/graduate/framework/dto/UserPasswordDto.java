package com.graduate.framework.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserPasswordDto {

    private Integer id;

    private String password;

    private String newPassword;

    private String confirmPassword;
}
