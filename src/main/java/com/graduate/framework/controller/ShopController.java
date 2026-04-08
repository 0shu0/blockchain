package com.graduate.framework.controller;

import com.graduate.framework.entity.Shop;
import com.graduate.framework.service.ShopService;
import com.graduate.framework.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/shop")
public class ShopController {

    @Autowired
    private ShopService shopService;

    @GetMapping("/findAll")
    public Result findAll() {
        List<Shop> shops = shopService.findAll();
        return Result.success(shops);
    }

    @GetMapping("/findById/{id}")
    public Result findById(@PathVariable String id) {
        Shop shop = shopService.findById(id);
        return Result.success(shop);
    }

    @PostMapping("/save")
    public Result save(@RequestBody Shop shop) {
        shopService.save(shop);
        return Result.success();
    }

    @DeleteMapping("/deleteById/{id}")
    public Result deleteById(@PathVariable String id) {
        shopService.deleteById(id);
        return Result.success();
    }

    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<String> ids) {
        shopService.deleteBatch(ids);
        return Result.success();
    }

    @GetMapping("/findByProductName/{name}")
    public Result findByProductName(@PathVariable String name) {
        List<Shop> shops = shopService.findByProductName(name);
        return Result.success(shops);
    }

    @GetMapping("/findByTraceCode/{traceCode}")
    public Result findByTraceCode(@PathVariable String traceCode) {
        Shop shop = shopService.findByTraceCode(traceCode);
        return Result.success(shop);
    }

    @GetMapping("/findPage")
    public Result findPage(@RequestParam int pageNum, @RequestParam int pageSize, @RequestParam(required = false) String name) {
        List<Shop> shops;
        if (name != null && !name.isEmpty()) {
            shops = shopService.findByProductName(name);
        } else {
            shops = shopService.findAll();
        }
        // 简单分页处理
        int start = (pageNum - 1) * pageSize;
        int end = Math.min(start + pageSize, shops.size());
        List<Shop> pageData = shops.subList(start, end);
        return Result.success().put("total", shops.size()).put("rows", pageData);
    }
}
