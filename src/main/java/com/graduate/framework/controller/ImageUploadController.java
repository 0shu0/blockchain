package com.graduate.framework.controller;

import com.graduate.framework.utils.FileUrlUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

/**
 * 图片上传控制器
 * 处理图片上传、URL生成、URL归档和共享访问
 */
@RestController
@RequestMapping("/image")
public class ImageUploadController {

    @Value("${files.upload.path}")
    private String fileUploadPath;

    @Value("${server.port}")
    private int serverPort;

    // URL列表文件路径
    private static final String URL_LIST_FILE = "url_list.txt";

    /**
     * 上传图片
     * @param file 上传的图片文件
     * @return 包含图片URL的响应
     */
    @PostMapping("/upload")
    public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            // 验证文件类型
            String contentType = file.getContentType();
            if (!isValidImageType(contentType)) {
                return ResponseEntity.badRequest().body("只支持jpg、png、webp格式的图片");
            }

            // 验证文件大小
            if (file.getSize() > 10 * 1024 * 1024) { // 10MB
                return ResponseEntity.badRequest().body("图片大小不能超过10MB");
            }

            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String fileExtension = getFileExtension(originalFilename);
            String uniqueFileName = UUID.randomUUID().toString() + "." + fileExtension;

            // 确保上传目录存在
            File uploadDir = new File(fileUploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 保存文件
            File destFile = new File(fileUploadPath + File.separator + uniqueFileName);
            file.transferTo(destFile);

            // 生成局域网可访问的URL
            String fileUrl = FileUrlUtil.generateFileUrl(uniqueFileName, serverPort);

            // 将URL追加写入文件
            writeUrlToFile(fileUrl);

            // 返回结果
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(java.util.Collections.singletonMap("url", fileUrl));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("上传失败：" + e.getMessage());
        }
    }

    /**
     * 获取URL列表
     * @param response HttpServletResponse
     * @throws IOException IOException
     */
    @GetMapping("/url-list")
    public void getUrlList(HttpServletResponse response) throws IOException {
        // 设置响应头
        response.setContentType("text/plain; charset=UTF-8");
        response.setHeader("Content-Disposition", "inline; filename=url_list.txt");

        // 读取URL列表文件
        File urlListFile = new File(fileUploadPath + File.separator + URL_LIST_FILE);
        if (!urlListFile.exists()) {
            response.getWriter().write("暂无URL记录");
            return;
        }

        // 读取文件内容并写入响应
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(urlListFile), StandardCharsets.UTF_8));
             BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    /**
     * 访问图片文件
     * @param filename 文件名
     * @return 图片资源
     */
    @GetMapping("/file/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        try {
            Path filePath = Paths.get(fileUploadPath).resolve(filename).normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists()) {
                return ResponseEntity.notFound().build();
            }

            // 设置缓存头
            HttpHeaders headers = new HttpHeaders();
            headers.setCacheControl("max-age=604800"); // 7天缓存

            // 确定文件类型
            String contentType = determineContentType(filename);
            headers.setContentType(MediaType.parseMediaType(contentType));

            // 编码文件名
            String encodedFilename = URLEncoder.encode(filename, "UTF-8");
            headers.setContentDispositionFormData("attachment", encodedFilename);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);

        } catch (MalformedURLException e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 验证图片类型是否有效
     * @param contentType 文件类型
     * @return 是否为有效图片类型
     */
    private boolean isValidImageType(String contentType) {
        return contentType != null && (
                contentType.equals("image/jpeg") ||
                contentType.equals("image/png") ||
                contentType.equals("image/webp")
        );
    }

    /**
     * 获取文件扩展名
     * @param filename 文件名
     * @return 文件扩展名
     */
    private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf(".");
        if (dotIndex > 0 && dotIndex < filename.length() - 1) {
            return filename.substring(dotIndex + 1).toLowerCase();
        }
        return "jpg";
    }

    /**
     * 将URL追加写入文件
     * @param url 要写入的URL
     * @throws IOException IOException
     */
    private void writeUrlToFile(String url) throws IOException {
        File urlListFile = new File(fileUploadPath + File.separator + URL_LIST_FILE);

        // 使用BufferedWriter提升效率
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(
                        new FileOutputStream(urlListFile, true), // 追加模式
                        StandardCharsets.UTF_8
                )
        )) {
            writer.write(url);
            writer.newLine();
        }
    }

    /**
     * 根据文件名确定内容类型
     * @param filename 文件名
     * @return 内容类型
     */
    private String determineContentType(String filename) {
        String extension = getFileExtension(filename);
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}
