package com.graduate.framework.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置静态资源目录，使file目录中的图片可以通过http://localhost:8888/file/访问
        registry.addResourceHandler("/file/**")
                .addResourceLocations("file:D:\\competition\\graduation-framework\\file\\");
    }
}
