package com.graduate.framework.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.graduate.framework.annotation.NoAuth;
import com.graduate.framework.common.Result;
import com.graduate.framework.entity.Warehouse;
import com.graduate.framework.service.WarehouseService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/warehouse")
public class WarehouseController {
    @Resource
    private WarehouseService warehouseService;

    @NoAuth
    @GetMapping("/findPage")
    public Result findPage(@RequestParam Integer pageNum, @RequestParam Integer pageSize) {
        IPage<Warehouse> page = new Page<>(pageNum, pageSize);
        IPage<Warehouse> result = warehouseService.page(page);
        return Result.success(result);
    }
}