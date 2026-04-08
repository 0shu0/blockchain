package com.graduate.framework.entity;

import lombok.Data;

@Data
public class Warehouse {
    private String id;
    private String traceCode;
    private String amount;
    private String sendDate;
    private String origin;
    private String name;
    private String recvDate;
    private String productId;
}
