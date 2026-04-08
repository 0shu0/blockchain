package com.graduate.framework.mapper;

import com.graduate.framework.entity.Warehouse;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface WarehouseMapper {
    List<Warehouse> findAll();
    Warehouse findById(String id);
    void insert(Warehouse warehouse);
    void update(Warehouse warehouse);
    void deleteById(String id);
    void deleteBatch(@Param("ids") List<String> ids);
    List<Warehouse> findByProductName(String name);
}
