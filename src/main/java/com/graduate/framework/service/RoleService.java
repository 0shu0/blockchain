package com.graduate.framework.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.graduate.framework.common.Result;
import com.graduate.framework.entity.Role;
import com.graduate.framework.entity.RoleMenu;

import java.util.List;

public interface RoleService extends IService<Role> {
    Result saveRoleMenu(Integer roleId, List<Integer> menuIds);

    List<RoleMenu> selectMenuByRole(Integer roleId);

    void removeByMenuId(Integer id);
}
