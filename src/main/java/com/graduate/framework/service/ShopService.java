package com.graduate.framework.service;

import com.graduate.framework.entity.Shop;

import java.util.List;

public interface ShopService {
    List<Shop> findAll();
    Shop findById(String id);
    void save(Shop shop);
    void deleteById(String id);
    void deleteBatch(List<String> ids);
    List<Shop> findByProductName(String name);
    Shop findByTraceCode(String traceCode);
}
