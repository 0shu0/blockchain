package com.graduate.framework.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("sys_file")
public class SysFile {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String name;

    private String type;

    private Long size;

    private String url;

    private String md5;

    private Integer isDelete;

    private Integer enable;

    // 构造方法
    public SysFile() {
    }

    public SysFile(Integer id, String name, String type, Long size, String url, String md5, Integer isDelete, Integer enable) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.size = size;
        this.url = url;
        this.md5 = md5;
        this.isDelete = isDelete;
        this.enable = enable;
    }

    // Getter 方法
    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public Long getSize() {
        return size;
    }

    public String getUrl() {
        return url;
    }

    public String getMd5() {
        return md5;
    }

    public Integer getIsDelete() {
        return isDelete;
    }

    public Integer getEnable() {
        return enable;
    }

    // Setter 方法
    public void setId(Integer id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setSize(Long size) {
        this.size = size;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setMd5(String md5) {
        this.md5 = md5;
    }

    public void setIsDelete(Integer isDelete) {
        this.isDelete = isDelete;
    }

    public void setEnable(Integer enable) {
        this.enable = enable;
    }


}
