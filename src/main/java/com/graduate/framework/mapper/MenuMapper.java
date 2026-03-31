package com.graduate.framework.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.graduate.framework.entity.Menu;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MenuMapper extends BaseMapper<Menu> {
    List<Menu> selectByIdList(@Param(value = "roleId") Integer roleId);
}
