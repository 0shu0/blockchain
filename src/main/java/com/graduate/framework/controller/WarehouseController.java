package com.graduate.framework.controller;

import com.graduate.framework.entity.Warehouse;
import com.graduate.framework.service.WarehouseService;
import com.graduate.framework.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/warehouse")
public class WarehouseController {

    @Autowired
    private WarehouseService warehouseService;

    @GetMapping("/findAll")
    public Result findAll() {
        List<Warehouse> warehouses = warehouseService.findAll();
        return Result.success(warehouses);
    }

    @GetMapping("/findById/{id}")
    public Result findById(@PathVariable String id) {
        Warehouse warehouse = warehouseService.findById(id);
        return Result.success(warehouse);
    }

    @PostMapping("/save")
    public Result save(@RequestBody Warehouse warehouse) {
        warehouseService.save(warehouse);
        return Result.success();
    }

    @DeleteMapping("/deleteById/{id}")
    public Result deleteById(@PathVariable String id) {
        warehouseService.deleteById(id);
        return Result.success();
    }

    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<String> ids) {
        warehouseService.deleteBatch(ids);
        return Result.success();
    }

    @GetMapping("/findByProductName/{name}")
    public Result findByProductName(@PathVariable String name) {
        List<Warehouse> warehouses = warehouseService.findByProductName(name);
        return Result.success(warehouses);
    }

    @GetMapping("/findPage")
    public Result findPage(@RequestParam int pageNum, @RequestParam int pageSize, @RequestParam(required = false) String name) {
        List<Warehouse> warehouses;
        if (name != null && !name.isEmpty()) {
            warehouses = warehouseService.findByProductName(name);
        } else {
            warehouses = warehouseService.findAll();
        }
        // 简单分页处理
        int start = (pageNum - 1) * pageSize;
        int end = Math.min(start + pageSize, warehouses.size());
        List<Warehouse> pageData = warehouses.subList(start, end);
        return Result.success().put("total", warehouses.size()).put("rows", pageData);
    }
}
