package com.graduate.framework.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.Date;

@TableName("notice")
public class Notice {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String title;

    private String content;

    private String user;

    private Date createTime;

    // 构造方法
    public Notice() {
    }

    public Notice(Integer id, String title, String content, String user, Date createTime) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.user = user;
        this.createTime = createTime;
    }

    // Getter 方法
    public Integer getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getUser() {
        return user;
    }

    public Date getCreateTime() {
        return createTime;
    }

    // Setter 方法
    public void setId(Integer id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

}
