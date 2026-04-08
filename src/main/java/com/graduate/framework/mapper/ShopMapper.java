package com.graduate.framework.mapper;

import com.graduate.framework.entity.Shop;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ShopMapper {
    List<Shop> findAll();
    Shop findById(String id);
    void insert(Shop shop);
    void update(Shop shop);
    void deleteById(String id);
    void deleteBatch(@Param("ids") List<String> ids);
    List<Shop> findByProductName(String name);
    Shop findByTraceCode(String traceCode);
}
