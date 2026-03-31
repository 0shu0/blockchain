package com.graduate.framework.aspect;

import com.graduate.framework.annotation.Log;
import com.graduate.framework.entity.SysLog;
import com.graduate.framework.mapper.SysLogMapper;
import com.graduate.framework.utils.JwtUtils;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

@Aspect
@Component
@Slf4j
public class SysLogAspect {

    @Autowired
    private SysLogMapper sysLogMapper;

    @Pointcut("@annotation(com.graduate.framework.annotation.Log)")
    public void pointCut(){}

    @After("pointCut()")
    public void recordLog(JoinPoint joinPoint){
        MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
        Method method = methodSignature.getMethod();
        Log log = method.getAnnotation(Log.class);
        String record = log.record();
        String type = log.type();
        SysLog sysLog = new SysLog();
        sysLog.setRecord(record);
        sysLog.setType(type);
        sysLog.setUsername(JwtUtils.getCurrentUser().getUsername());
        sysLogMapper.insert(sysLog);
    }

}
