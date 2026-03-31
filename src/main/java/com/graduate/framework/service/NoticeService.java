package com.graduate.framework.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.graduate.framework.entity.Notice;

import java.util.List;

public interface NoticeService extends IService<Notice> {
    List<Notice> findNewNoticeList();
}
