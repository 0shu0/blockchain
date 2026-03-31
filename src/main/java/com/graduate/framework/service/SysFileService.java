package com.graduate.framework.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.graduate.framework.entity.SysFile;

import java.util.List;

public interface SysFileService extends IService<SysFile> {
    List<SysFile> getByMD5(String md5);
}
