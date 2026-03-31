package com.graduate.framework.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.graduate.framework.common.Result;
import com.graduate.framework.entity.Menu;
import com.graduate.framework.entity.Role;
import com.graduate.framework.entity.RoleMenu;
import com.graduate.framework.mapper.MenuMapper;
import com.graduate.framework.mapper.RoleMapper;
import com.graduate.framework.mapper.RoleMenuMapper;
import com.graduate.framework.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements RoleService {

    @Autowired
    private RoleMenuMapper roleMenuMapper;
    @Autowired
    private MenuMapper menuMapper;

    @Override
    @Transactional
    public Result saveRoleMenu(Integer roleId, List<Integer> menuIds) {
        //保存角色菜单关联数据前先删除roleId本来的菜单信息
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id",roleId);
        roleMenuMapper.delete(queryWrapper);
        //保存角色菜单关联数据
        for (Integer menuId : menuIds) {
            Menu menu = menuMapper.selectById(menuId);
            Integer pid = menu.getPid();
            if(pid != null && !menuIds.contains(pid)){
                //该菜单是二级菜单并且父菜单不在menuIds里面
                QueryWrapper<RoleMenu> wrapper = new QueryWrapper<>();
                wrapper.eq("role_id",roleId);
                wrapper.eq("menu_id",pid);
                RoleMenu existRoleMenu = roleMenuMapper.selectOne(wrapper);
                if(existRoleMenu == null){
                    existRoleMenu = new RoleMenu();
                    existRoleMenu.setRoleId(roleId);
                    existRoleMenu.setMenuId(pid);
                    roleMenuMapper.insert(existRoleMenu);
                }
            }
            RoleMenu roleMenu = new RoleMenu();
            roleMenu.setRoleId(roleId);
            roleMenu.setMenuId(menuId);
            roleMenuMapper.insert(roleMenu);
        }
        return Result.success();
    }

    @Override
    public List<RoleMenu> selectMenuByRole(Integer roleId) {
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id",roleId);
        return roleMenuMapper.selectList(queryWrapper);
    }

    @Override
    public void removeByMenuId(Integer menuId) {
        //根据菜单id删除角色菜单关联数据
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("menu_id",menuId);
        roleMenuMapper.delete(queryWrapper);
    }
}
