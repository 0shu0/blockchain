package com.graduate.framework.service.impl;

import com.graduate.framework.entity.Shop;
import com.graduate.framework.mapper.ShopMapper;
import com.graduate.framework.service.ShopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ShopServiceImpl implements ShopService {

    @Autowired
    private ShopMapper shopMapper;

    @Override
    public List<Shop> findAll() {
        return shopMapper.findAll();
    }

    @Override
    public Shop findById(String id) {
        return shopMapper.findById(id);
    }

    @Override
    public void save(Shop shop) {
        if (shop.getId() != null) {
            shopMapper.update(shop);
        } else {
            shopMapper.insert(shop);
        }
    }

    @Override
    public void deleteById(String id) {
        shopMapper.deleteById(id);
    }

    @Override
    public void deleteBatch(List<String> ids) {
        shopMapper.deleteBatch(ids);
    }

    @Override
    public List<Shop> findByProductName(String name) {
        return shopMapper.findByProductName(name);
    }

    @Override
    public Shop findByTraceCode(String traceCode) {
        return shopMapper.findByTraceCode(traceCode);
    }
}
