package com.graduate.framework.dto;

import com.graduate.framework.entity.Menu;
import lombok.Data;

import java.util.List;

@Data
public class UserDto {

    private Integer id;

    private Integer roleId;

    private String username;

    private String password;

    private String nickname;

    private String headerUrl;

    private String token;

    private List<Menu> menuList;
}
