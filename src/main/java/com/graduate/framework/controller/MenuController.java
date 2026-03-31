package com.graduate.framework.controller;

import com.graduate.framework.common.Result;
import com.graduate.framework.entity.Menu;
import com.graduate.framework.service.MenuService;
import com.graduate.framework.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;
    @Autowired
    private RoleService roleService;

    /**
     * 新增/修改
     * @param menu
     * @return
     */
    @PostMapping("/save")
    public Result save(@RequestBody Menu menu){
        boolean b = menuService.saveOrUpdate(menu);
        if(b){
            return Result.success();
        }else{
            return Result.error();
        }
    }

    /**
     * 根据id删除
     * @param id
     * @return
     */
    @DeleteMapping("/deleteById/{id}")
    public Result deleteById(@PathVariable Integer id){
        boolean b = menuService.removeById(id);
        roleService.removeByMenuId(id);
        if(b){
            return Result.success();
        }else{
            return Result.error();
        }
    }

    /**
     * 根据id批量删除
     * @param idList
     * @return
     */
    @PostMapping("/deleteBatch")
    public Result deleteBatch(@RequestBody List<Integer> idList){
        boolean b = menuService.removeByIds(idList);
        if(b){
            return Result.success();
        }else{
            return Result.error();
        }
    }
    /**
     * 构造树形菜单数据
     * @return
     */
    @GetMapping("/findAll")
    public Result findAll(@RequestParam(name = "name",defaultValue = "") String name){
        List<Menu> list = menuService.findAll(name);
        return Result.success(list);
    }
    /**
     * 获取全部的菜单id
     * @return
     */
    @GetMapping("/findAllMenuId")
    public Result findAllMenuId(@RequestParam(name = "name",defaultValue = "") String name){
        List<Menu> list = menuService.list();
        List<Integer> menuIdList = list.stream().map(menu -> menu.getId()).collect(Collectors.toList());
        return Result.success(menuIdList);
    }

}
