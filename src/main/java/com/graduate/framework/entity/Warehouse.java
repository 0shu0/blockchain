package com.graduate.framework.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@TableName("warehouse")
public class Warehouse implements Serializable {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String trace_code;
    private Integer amount;
    private Date send_date;
    private String origin;
    private String name;
    private String product_id;
    private Date recv_date;
}