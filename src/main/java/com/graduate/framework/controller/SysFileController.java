package com.graduate.framework.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.graduate.framework.annotation.Log;
import com.graduate.framework.annotation.NoAuth;
import com.graduate.framework.common.Result;
import com.graduate.framework.entity.SysFile;
import com.graduate.framework.service.SysFileService;
import com.graduate.framework.utils.ConfigUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/sysFile")
public class SysFileController {

    @Autowired
    private SysFileService sysFileService;

    @Autowired
    private ConfigUtil configUtil;

    @Value("${files.upload.path}")
    private String fileUploadPath;

    /**
     * 批量删除文件
     * @param idList
     * @return
     */
    @PostMapping("/deleteBatch")
    @Log(record = "批量删除文件",type = "删除")
    public Result deleteBatch(@RequestBody List<Integer> idList){
        for (Integer id : idList) {
            SysFile sysFile = sysFileService.getById(id);
            sysFile.setIsDelete(1);
            sysFileService.updateById(sysFile);
        }
        return Result.success();
    }
    /**
     * 改变启用状态
     * @param sysFile
     * @return
     */
    @PostMapping("/updateEnable")
    @Log(record = "updateEnable",type = "修改")
    public Result updateEnable(@RequestBody SysFile sysFile){
        boolean b = sysFileService.updateById(sysFile);
        if(b){
            return Result.success();
        }else{
            return Result.error();
        }
    }

    /**
     * 根据id删除
     * @param id
     * @return
     */
    @DeleteMapping("/deleteById/{id}")
    @Log(record = "根据id删除文件",type = "删除")
    public Result deleteById(@PathVariable Integer id){
        SysFile sysFile = sysFileService.getById(id);
        sysFile.setIsDelete(1);
        boolean b = sysFileService.updateById(sysFile);
        if(b){
            return Result.success();
        }else{
            return Result.error();
        }
    }

    /**
     * 上传文件
     * @param file
     * @return
     */
    @PostMapping("/upload")
    @NoAuth
    public String upload(@RequestParam MultipartFile file) throws IOException {
        String md5 = DigestUtils.md5Hex(file.getBytes());
        String originalFilename = file.getOriginalFilename();  //文件的名称
        String type = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);//文件类型
        long size = file.getSize();
        File uploadParentFile = new File(fileUploadPath);
        if(!uploadParentFile.exists()){
            uploadParentFile.mkdirs();
        }
        List<SysFile> existFileList = sysFileService.getByMD5(md5);
        String url = null;
        if(CollectionUtils.isNotEmpty(existFileList)){
            //文件已经存在上传目录
            url = existFileList.get(0).getUrl();
        }else{
            //文件不存在上传目录
            String uuid = UUID.randomUUID().toString().replaceAll("-", "");
            String fileUUID = uuid + "." + type;
            File uploadFile = new File(fileUploadPath + fileUUID);
            // 使用局域网IP地址生成URL，确保其他机器能够访问
            String hostname = InetAddress.getLocalHost().getHostAddress();
            url = "http://" + hostname + ":8888/sysFile/" + fileUUID;
            file.transferTo(uploadFile);
        }

        //存储数据库
        SysFile sysFile = new SysFile();
        sysFile.setName(originalFilename);
        sysFile.setSize(size / 1024);
        sysFile.setType(type);
        sysFile.setUrl(url);
        sysFile.setMd5(md5);
        sysFileService.save(sysFile);
        
        // 上传地址的添加由前端通过 addImageToConfig 方法处理
        // 这里不再重复添加，避免出现重复 URL 的情况
        
        return url;
    }

    /**
     * 下载文件
     * @param fileUUID
     */
    @GetMapping("/{fileUUID}")
    @NoAuth
    public void download(@PathVariable String fileUUID, HttpServletResponse response){
        File downloadFile = new File(fileUploadPath + fileUUID);
        try {
            FileInputStream fileInputStream = new FileInputStream(downloadFile);
            // 设置输出流的格式
            response.setCharacterEncoding("UTF-8");
            response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileUUID, "UTF-8"));
            //作用是使客户端浏览器区分不同种类的数据，并根据不同的MIME调用浏览器内不同的程序嵌入模块来处理相应的数据。
            response.setContentType("application/octet-stream");  //.*（ 二进制流，不知道下载文件类型）
            ServletOutputStream outputStream = response.getOutputStream();
            int len = 0;
            byte[] bytes = new byte[1024];
            while((len = fileInputStream.read(bytes)) != -1){
                outputStream.write(bytes,0,len);
                outputStream.flush();
            }
            outputStream.flush();
            outputStream.close();
            fileInputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    /**
     * 查询全部数据
     * @return
     */
    @GetMapping("/findAll")
    @Log(record = "查询全部文件",type = "查询")
    public Result findAll(@RequestParam(name = "type",defaultValue = "") String type){
        QueryWrapper<SysFile> queryWrapper = new QueryWrapper<>();
        if(StringUtils.isNotBlank(type)){
            queryWrapper.eq("type",type);
        }
        return Result.success(sysFileService.list(queryWrapper));
    }

    /**
     * 分页查询
     * @param pageNum：页码
     * @param pageSize：每页条数
     * @param name：角色名称
     * @return
     */
    @GetMapping("/findPage")
    @Log(record = "查询文件分页",type = "查询")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(name = "name",defaultValue = "") String name){
        Page<SysFile> page = new Page<>(pageNum,pageSize);
        QueryWrapper<SysFile> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("is_delete",0);
        if(StringUtils.isNotBlank(name)){
            queryWrapper.like("name",name);
        }
        Page<SysFile> sysFilePage = sysFileService.page(page, queryWrapper);
        return Result.success(sysFilePage);
    }
    
    /**
     * 获取URL列表
     * @return Map<String, Object>
     */
    @GetMapping("/url-list")
    @NoAuth
    public Map<String, Object> getUrlList() {
        try {
            // 获取配置
            return configUtil.getConfig();
        } catch (Exception e) {
            e.printStackTrace();
            // 返回空配置
            Map<String, Object> emptyConfig = new java.util.HashMap<>();
            emptyConfig.put("UploadImages", new java.util.ArrayList<String>());
            emptyConfig.put("ReturnImages", new java.util.ArrayList<String>());
            return emptyConfig;
        }
    }
    
    /**
     * 清空URL列表
     * @return Result
     */
    @PostMapping("/clear-url-list")
    @NoAuth
    public Result clearUrlList() {
        try {
            // 清空配置文件
            configUtil.clearConfig();
            
            // 清空 url_list.txt 文件
            File urlListFile = new File(fileUploadPath + File.separator + "url_list.txt");
            if (urlListFile.exists()) {
                // 清空文件内容
                try (java.io.BufferedWriter writer = new java.io.BufferedWriter(
                        new java.io.OutputStreamWriter(
                                new java.io.FileOutputStream(urlListFile, false), // 覆盖模式
                                java.nio.charset.StandardCharsets.UTF_8
                        )
                )) {
                    writer.write("");
                }
            }
            return Result.success();
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("500", "清空URL列表失败");
        }
    }
    
    /**
     * 获取配置
     * @return Result
     */
    @GetMapping("/config.json")
    @NoAuth
    public Result getConfig() {
        try {
            Map<String, Object> config = configUtil.getConfig();
            return Result.success(config);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("500", "配置读取失败");
        }
    }
    
    /**
     * 更新配置
     * @param config 配置对象
     * @return Result
     */
    @PostMapping("/updateConfig")
    @NoAuth
    public Result updateConfig(@RequestBody Map<String, Object> config) {
        try {
            Map<String, Object> updatedConfig = configUtil.updateConfig(config);
            return Result.success(updatedConfig);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("500", "更新配置失败");
        }
    }
    
    /**
     * 添加图片地址
     * @param request 请求体
     * @return Result
     */
    @PostMapping("/addImage")
    @NoAuth
    public Result addImage(@RequestBody Map<String, String> request) {
        try {
            String uploadUrl = request.get("uploadUrl");
            String returnUrl = request.get("returnUrl");
            
            if (uploadUrl == null || returnUrl == null) {
                return Result.error("400", "参数缺失");
            }
            
            Map<String, Object> updatedConfig = configUtil.addImage(uploadUrl, returnUrl);
            return Result.success(updatedConfig);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("500", "添加图片地址失败");
        }
    }
    
    /**
     * 清空配置
     * @return Result
     */
    @PostMapping("/clearConfig")
    @NoAuth
    public Result clearConfig() {
        try {
            Map<String, Object> config = configUtil.clearConfig();
            return Result.success(config);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("500", "清空配置失败");
        }
    }
}
