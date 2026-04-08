package com.graduate.framework.service.impl;

import com.graduate.framework.entity.Warehouse;
import com.graduate.framework.mapper.WarehouseMapper;
import com.graduate.framework.service.WarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WarehouseServiceImpl implements WarehouseService {

    @Autowired
    private WarehouseMapper warehouseMapper;

    @Override
    public List<Warehouse> findAll() {
        return warehouseMapper.findAll();
    }

    @Override
    public Warehouse findById(String id) {
        return warehouseMapper.findById(id);
    }

    @Override
    public void save(Warehouse warehouse) {
        if (warehouse.getId() != null) {
            warehouseMapper.update(warehouse);
        } else {
            warehouseMapper.insert(warehouse);
        }
    }

    @Override
    public void deleteById(String id) {
        warehouseMapper.deleteById(id);
    }

    @Override
    public void deleteBatch(List<String> ids) {
        warehouseMapper.deleteBatch(ids);
    }

    @Override
    public List<Warehouse> findByProductName(String name) {
        return warehouseMapper.findByProductName(name);
    }
}
