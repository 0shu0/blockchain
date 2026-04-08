package com.graduate.framework.service;

import com.graduate.framework.entity.Warehouse;

import java.util.List;

public interface WarehouseService {
    List<Warehouse> findAll();
    Warehouse findById(String id);
    void save(Warehouse warehouse);
    void deleteById(String id);
    void deleteBatch(List<String> ids);
    List<Warehouse> findByProductName(String name);
}
