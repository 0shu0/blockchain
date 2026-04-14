package com.graduate.framework.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 配置管理工具类
 * 负责配置文件的读写操作，确保线程安全
 */
@Component
public class ConfigUtil {

    // 配置文件路径
    @Value("${config.file.path:./config.json}")
    private String configFilePath;

    // JSON对象映射器
    private final ObjectMapper objectMapper = new ObjectMapper();

    // 读写锁，确保线程安全
    private final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

    /**
     * 获取配置
     * @return 配置对象
     */
    public Map<String, Object> getConfig() {
        lock.readLock().lock();
        try {
            File configFile = new File(configFilePath);
            if (!configFile.exists()) {
                // 文件不存在，释放读锁，获取写锁创建默认配置
                lock.readLock().unlock();
                lock.writeLock().lock();
                try {
                    // 再次检查文件是否存在，避免竞态条件
                    if (!configFile.exists()) {
                        return createDefaultConfig();
                    }
                    // 文件已存在，重新读取
                    return readConfig(configFile);
                } finally {
                    lock.writeLock().unlock();
                    lock.readLock().lock();
                }
            }

            // 读取配置文件
            return readConfig(configFile);
        } finally {
            lock.readLock().unlock();
        }
    }
    
    /**
     * 读取配置文件
     * @param configFile 配置文件
     * @return 配置对象
     */
    private Map<String, Object> readConfig(File configFile) {
        try (FileReader reader = new FileReader(configFile)) {
            Map<String, Object> config = objectMapper.readValue(reader, Map.class);
            // 确保配置格式正确
            return ensureConfigFormat(config);
        } catch (IOException e) {
            e.printStackTrace();
            // 读取失败，释放读锁，获取写锁创建默认配置
            lock.readLock().unlock();
            lock.writeLock().lock();
            try {
                return createDefaultConfig();
            } finally {
                lock.writeLock().unlock();
                lock.readLock().lock();
            }
        }
    }
    
    /**
     * 确保配置格式正确
     * @param config 配置对象
     * @return 格式化后的配置对象
     */
    private Map<String, Object> ensureConfigFormat(Map<String, Object> config) {
        // 检查并转换 UploadImages
        if (config.containsKey("UploadImage")) {
            // 旧格式，单个值
            Object uploadImage = config.remove("UploadImage");
            ArrayList<String> uploadImages = new ArrayList<>();
            if (uploadImage != null) {
                uploadImages.add(convertToFullUrl(uploadImage.toString()));
            }
            config.put("UploadImages", uploadImages);
        } else if (!config.containsKey("UploadImages")) {
            // 不存在，创建空数组
            config.put("UploadImages", new ArrayList<String>());
        } else {
            // 转换现有的相对路径为完整 URL
            ArrayList<String> uploadImages = (ArrayList<String>) config.get("UploadImages");
            for (int i = 0; i < uploadImages.size(); i++) {
                uploadImages.set(i, convertToFullUrl(uploadImages.get(i)));
            }
        }
        
        // 检查并转换 ReturnImages
        if (config.containsKey("ReturnImage")) {
            // 旧格式，单个值
            Object returnImage = config.remove("ReturnImage");
            ArrayList<String> returnImages = new ArrayList<>();
            if (returnImage != null) {
                returnImages.add(returnImage.toString());
            }
            config.put("ReturnImages", returnImages);
        } else if (!config.containsKey("ReturnImages")) {
            // 不存在，创建空数组
            config.put("ReturnImages", new ArrayList<String>());
        }
        
        return config;
    }
    
    /**
     * 将相对路径转换为完整的 URL
     * @param url 相对路径或完整 URL
     * @return 完整的 URL
     */
    private String convertToFullUrl(String url) {
        if (url.startsWith("http://") || url.startsWith("https://")) {
            // 已经是完整 URL，直接返回
            return url;
        }
        
        // 构建完整的 URL
        try {
            String hostname = java.net.InetAddress.getLocalHost().getHostAddress();
            return "http://" + hostname + ":8888" + url;
        } catch (Exception e) {
            e.printStackTrace();
            return url;
        }
    }

    /**
     * 更新配置
     * @param config 新的配置对象
     * @return 更新后的配置
     */
    public Map<String, Object> updateConfig(Map<String, Object> config) {
        lock.writeLock().lock();
        try {
            // 确保配置结构完整
            if (!config.containsKey("UploadImages")) {
                config.put("UploadImages", new ArrayList<String>());
            }
            if (!config.containsKey("ReturnImages")) {
                config.put("ReturnImages", new ArrayList<String>());
            }

            // 写入配置文件
            File configFile = new File(configFilePath);
            // 确保目录存在
            if (!configFile.getParentFile().exists()) {
                configFile.getParentFile().mkdirs();
            }

            try (FileWriter writer = new FileWriter(configFile)) {
                objectMapper.writeValue(writer, config);
            } catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("更新配置失败", e);
            }

            return config;
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * 添加图片地址
     * @param uploadUrl 上传地址
     * @param returnUrl 回传地址
     * @return 更新后的配置
     */
    public Map<String, Object> addImage(String uploadUrl, String returnUrl) {
        lock.writeLock().lock();
        try {
            // 获取当前配置
            Map<String, Object> config = getConfig();

            // 添加图片地址（只更新 UploadImages 数组）
            ArrayList<String> uploadImages = (ArrayList<String>) config.get("UploadImages");

            uploadImages.add(uploadUrl);

            // 更新配置
            return updateConfig(config);
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * 清空配置
     * @return 清空后的配置
     */
    public Map<String, Object> clearConfig() {
        lock.writeLock().lock();
        try {
            // 创建空配置
            Map<String, Object> config = new HashMap<>();
            config.put("UploadImages", new ArrayList<String>());
            config.put("ReturnImages", new ArrayList<String>());

            // 更新配置
            return updateConfig(config);
        } finally {
            lock.writeLock().unlock();
        }
    }

    /**
     * 创建默认配置
     * @return 默认配置
     */
    private Map<String, Object> createDefaultConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("UploadImages", new ArrayList<String>());
        config.put("ReturnImages", new ArrayList<String>());
        return updateConfig(config);
    }

    /**
     * 设置配置文件路径
     * @param configFilePath 配置文件路径
     */
    public void setConfigFilePath(String configFilePath) {
        this.configFilePath = configFilePath;
    }
}
