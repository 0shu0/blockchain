import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.*;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class ImageUploadServer {

    private static final String UPLOAD_DIR = "D:\\competition\\graduation-framework\\file\\";
    private static final String URL_LIST_FILE = UPLOAD_DIR + "url_list.txt";
    private static final int PORT = 20000;

    public static void main(String[] args) throws Exception {
        // 确保上传目录存在
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 创建HTTP服务器
        HttpServer server = HttpServer.create(new InetSocketAddress(PORT), 0);
        server.createContext("/upload", new UploadHandler());
        server.createContext("/url-list", new UrlListHandler());
        server.createContext("/file", new FileHandler());
        server.setExecutor(null); // 使用默认的 executor
        server.start();

        // 获取局域网IP地址
        String lanIp = getLocalLanIp();
        System.out.println("服务器已启动，监听端口: " + PORT);
        System.out.println("上传接口: http://" + lanIp + ":" + PORT + "/upload");
        System.out.println("URL列表接口: http://" + lanIp + ":" + PORT + "/url-list");
        System.out.println("文件访问接口: http://" + lanIp + ":" + PORT + "/file/{filename}");
    }

    /**
     * 获取局域网IP地址
     */
    private static String getLocalLanIp() {
        try {
            InetAddress localhost = InetAddress.getLocalHost();
            return localhost.getHostAddress();
        } catch (Exception e) {
            e.printStackTrace();
            return "127.0.0.1";
        }
    }

    /**
     * 处理文件上传请求
     */
    static class UploadHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"POST".equals(exchange.getRequestMethod())) {
                exchange.sendResponseHeaders(405, 0);
                exchange.close();
                return;
            }

            // 解析 multipart/form-data 请求
            String boundary = extractBoundary(exchange.getRequestHeaders().getFirst("Content-Type"));
            if (boundary == null) {
                exchange.sendResponseHeaders(400, 0);
                exchange.close();
                return;
            }

            try (InputStream inputStream = exchange.getRequestBody();
                 BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {

                // 读取请求体
                StringBuilder requestBody = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    requestBody.append(line).append("\n");
                }

                // 提取文件内容
                String body = requestBody.toString();
                int fileStart = body.indexOf("Content-Type: image/") + body.substring(body.indexOf("Content-Type: image/")).indexOf("\n\n") + 4;
                int fileEnd = body.lastIndexOf("--" + boundary + "--");

                if (fileStart == -1 || fileEnd == -1) {
                    exchange.sendResponseHeaders(400, 0);
                    exchange.close();
                    return;
                }

                // 提取文件名
                String fileNameLine = body.substring(0, fileStart);
                int fileNameStart = fileNameLine.indexOf("filename=\"") + 10;
                int fileNameEnd = fileNameLine.indexOf("\"", fileNameStart);
                String originalFilename = fileNameLine.substring(fileNameStart, fileNameEnd);
                String fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1);

                // 生成唯一文件名
                String uniqueFileName = UUID.randomUUID().toString() + "." + fileExtension;
                File destFile = new File(UPLOAD_DIR + uniqueFileName);

                // 提取文件内容并写入文件
                byte[] fileContent = body.substring(fileStart, fileEnd).getBytes(StandardCharsets.ISO_8859_1);
                try (FileOutputStream fos = new FileOutputStream(destFile)) {
                    fos.write(fileContent);
                }

                // 生成URL
                String lanIp = getLocalLanIp();
                String fileUrl = "http://" + lanIp + ":" + PORT + "/file/" + uniqueFileName;

                // 将URL追加写入文件
                try (BufferedWriter writer = new BufferedWriter(
                        new OutputStreamWriter(
                                new FileOutputStream(URL_LIST_FILE, true),
                                StandardCharsets.UTF_8
                        )
                )) {
                    writer.write(fileUrl);
                    writer.newLine();
                }

                // 返回URL
                exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=UTF-8");
                exchange.sendResponseHeaders(200, fileUrl.length());
                try (OutputStream os = exchange.getResponseBody()) {
                    os.write(fileUrl.getBytes(StandardCharsets.UTF_8));
                }

            } catch (Exception e) {
                e.printStackTrace();
                exchange.sendResponseHeaders(500, 0);
                exchange.close();
            }
        }

        /**
         * 从Content-Type头中提取boundary
         */
        private String extractBoundary(String contentType) {
            if (contentType == null) return null;
            int boundaryIndex = contentType.indexOf("boundary=");
            if (boundaryIndex == -1) return null;
            return contentType.substring(boundaryIndex + 9);
        }
    }

    /**
     * 处理URL列表请求
     */
    static class UrlListHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"GET".equals(exchange.getRequestMethod())) {
                exchange.sendResponseHeaders(405, 0);
                exchange.close();
                return;
            }

            // 读取URL列表文件
            File urlListFile = new File(URL_LIST_FILE);
            if (!urlListFile.exists()) {
                String response = "暂无URL记录";
                exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=UTF-8");
                exchange.sendResponseHeaders(200, response.length());
                try (OutputStream os = exchange.getResponseBody()) {
                    os.write(response.getBytes(StandardCharsets.UTF_8));
                }
                return;
            }

            // 读取文件内容
            StringBuilder content = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new FileReader(urlListFile, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(line).append("\n");
                }
            }

            // 返回内容
            String response = content.toString();
            exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=UTF-8");
            exchange.sendResponseHeaders(200, response.length());
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(response.getBytes(StandardCharsets.UTF_8));
            }
        }
    }

    /**
     * 处理文件访问请求
     */
    static class FileHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            if (!"GET".equals(exchange.getRequestMethod())) {
                exchange.sendResponseHeaders(405, 0);
                exchange.close();
                return;
            }

            // 获取文件名
            String path = exchange.getRequestURI().getPath();
            String filename = path.substring(6); // 去掉 "/file/" 前缀

            // 读取文件
            File file = new File(UPLOAD_DIR + filename);
            if (!file.exists()) {
                exchange.sendResponseHeaders(404, 0);
                exchange.close();
                return;
            }

            // 设置响应头
            exchange.getResponseHeaders().set("Content-Type", getContentType(filename));
            exchange.getResponseHeaders().set("Content-Disposition", "inline; filename=" + filename);
            exchange.sendResponseHeaders(200, file.length());

            // 发送文件内容
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = exchange.getResponseBody()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
            }
        }

        /**
         * 根据文件名确定内容类型
         */
        private String getContentType(String filename) {
            String extension = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
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
}
