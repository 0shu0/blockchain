package com.graduate.framework.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

@TableName("sys_user")
public class User {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String username;

    private String password;

    private String nickname;

    private String address;

    private String email;

    private String phone;

    private Integer roleId;

    private Date createTime;

    private String headerUrl;

    // 构造方法
    public User() {
    }

    public User(Integer id, String username, String password, String nickname, String address, String email, String phone, Integer roleId, Date createTime, String headerUrl) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.nickname = nickname;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.roleId = roleId;
        this.createTime = createTime;
        this.headerUrl = headerUrl;
    }

    // Getter 方法
    public Integer getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getNickname() {
        return nickname;
    }

    public String getAddress() {
        return address;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public String getHeaderUrl() {
        return headerUrl;
    }

    // Setter 方法
    public void setId(Integer id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public void setHeaderUrl(String headerUrl) {
        this.headerUrl = headerUrl;
    }


}
