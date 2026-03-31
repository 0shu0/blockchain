package com.graduate.framework.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.graduate.framework.common.Result;
import com.graduate.framework.dto.UserDto;
import com.graduate.framework.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService extends IService<User> {
    Result register(UserDto userDto);

    Result login(UserDto userDto);

    List<Map<String, Object>> echart();
}
