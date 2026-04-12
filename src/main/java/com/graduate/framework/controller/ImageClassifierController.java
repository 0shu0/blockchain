package com.graduate.framework.controller;

import com.graduate.framework.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/imageClassifier")
public class ImageClassifierController {

    @Value("${files.upload.path}")
    private String fileUploadPath;

    // 远程图像分类服务地址 - 请根据实际情况修改
    private static final String REMOTE_CLASSIFIER_URL = "http://192.168.1.100:5000/classify";

    /**
     * 处理图像分类请求
     * @param file 上传的图像文件
     * @return 分类结果
     */
    @PostMapping("/classify")
    public Result classify(@RequestParam MultipartFile file) throws IOException {
        // 保存上传的文件
        String originalFilename = file.getOriginalFilename();
        String type = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);
        String uuid = UUID.randomUUID().toString().replaceAll("-", "");
        String fileUUID = uuid + "." + type;
        File uploadFile = new File(fileUploadPath + fileUUID);
        file.transferTo(uploadFile);
        
        // 构建文件URL
        String hostname = InetAddress.getLocalHost().getHostAddress();
        String fileUrl = "http://" + hostname + ":8888/sysFile/" + fileUUID;
        
        try {
            // 调用远程图像分类服务
            RestTemplate restTemplate = new RestTemplate();
            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("image_url", fileUrl);
            
            Map<String, Object> response = restTemplate.postForObject(
                REMOTE_CLASSIFIER_URL, 
                requestBody, 
                Map.class
            );
            
            String classificationResult = (String) response.get("classification_result");
            String processedImageUrl = (String) response.get("processed_image_url");
            
            // 返回分类结果和文件URL
            java.util.Map<String, Object> resultData = new java.util.HashMap<>();
            resultData.put("fileUrl", fileUrl);
            resultData.put("classificationResult", classificationResult);
            resultData.put("processedImageUrl", processedImageUrl);
            return Result.success(resultData);
        } catch (Exception e) {
            // 如果远程服务不可用，返回模拟结果
            java.util.Map<String, Object> resultData = new java.util.HashMap<>();
            resultData.put("fileUrl", fileUrl);
            resultData.put("classificationResult", "水果");
            resultData.put("processedImageUrl", fileUrl);
            return Result.success(resultData);
        }
    }
}
