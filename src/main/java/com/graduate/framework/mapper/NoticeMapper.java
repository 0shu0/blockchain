package com.graduate.framework.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.graduate.framework.entity.Notice;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface NoticeMapper extends BaseMapper<Notice> {

    @Select("select * from notice order by  create_time desc limit 0,6")
    List<Notice> findNewNoticeList();
}
