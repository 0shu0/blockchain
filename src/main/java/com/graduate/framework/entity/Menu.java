package com.graduate.framework.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.util.List;

@TableName("sys_menu")
public class Menu {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String name;

    private String path;

    private String icon;

    private String description;

    private Integer pid;

    private String pagePath;

    private Integer sortNum;

    @TableField(exist = false)
    private List<Menu> children;

    // 构造方法
    public Menu() {
    }

    public Menu(Integer id, String name, String path, String icon, String description, Integer pid, String pagePath, Integer sortNum, List<Menu> children) {
        this.id = id;
        this.name = name;
        this.path = path;
        this.icon = icon;
        this.description = description;
        this.pid = pid;
        this.pagePath = pagePath;
        this.sortNum = sortNum;
        this.children = children;
    }

    // Getter 方法
    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPath() {
        return path;
    }

    public String getIcon() {
        return icon;
    }

    public String getDescription() {
        return description;
    }

    public Integer getPid() {
        return pid;
    }

    public String getPagePath() {
        return pagePath;
    }

    public Integer getSortNum() {
        return sortNum;
    }

    public List<Menu> getChildren() {
        return children;
    }

    // Setter 方法
    public void setId(Integer id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public void setPagePath(String pagePath) {
        this.pagePath = pagePath;
    }

    public void setSortNum(Integer sortNum) {
        this.sortNum = sortNum;
    }

    public void setChildren(List<Menu> children) {
        this.children = children;
    }
}
