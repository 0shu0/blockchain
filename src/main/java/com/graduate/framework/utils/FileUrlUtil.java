package com.graduate.framework.utils;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;
import java.util.regex.Pattern;

/**
 * 文件URL工具类
 * 用于获取局域网IP和生成URL
 */
public class FileUrlUtil {
    
    /**
     * 获取局域网IP地址
     * 排除127.0.0.1和IPv6地址
     * @return 局域网IP地址，如192.168.1.100
     */
    public static String getLocalLanIp() {
        try {
            Enumeration<NetworkInterface> networkInterfaces = NetworkInterface.getNetworkInterfaces();
            while (networkInterfaces.hasMoreElements()) {
                NetworkInterface networkInterface = networkInterfaces.nextElement();
                // 跳过虚拟网卡和回环接口
                if (networkInterface.isVirtual() || networkInterface.isLoopback()) {
                    continue;
                }
                
                Enumeration<InetAddress> inetAddresses = networkInterface.getInetAddresses();
                while (inetAddresses.hasMoreElements()) {
                    InetAddress inetAddress = inetAddresses.nextElement();
                    // 排除IPv6地址和回环地址
                    if (!(inetAddress instanceof java.net.Inet6Address) && !inetAddress.isLoopbackAddress()) {
                        String ip = inetAddress.getHostAddress();
                        // 验证是否为局域网IP
                        if (isLanIp(ip)) {
                            return ip;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 如果没有找到局域网IP，返回127.0.0.1作为 fallback
        return "127.0.0.1";
    }
    
    /**
     * 验证是否为局域网IP
     * @param ip IP地址
     * @return 是否为局域网IP
     */
    private static boolean isLanIp(String ip) {
        // 局域网IP范围：
        // 10.0.0.0 ~ 10.255.255.255
        // 172.16.0.0 ~ 172.31.255.255
        // 192.168.0.0 ~ 192.168.255.255
        Pattern pattern = Pattern.compile(
            "^(10\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})|" +
            "(172\\.(1[6-9]|2[0-9]|3[0-1])\\.\\d{1,3}\\.\\d{1,3})|" +
            "(192\\.168\\.\\d{1,3}\\.\\d{1,3})$");
        return pattern.matcher(ip).matches();
    }
    
    /**
     * 生成文件URL
     * @param fileName 文件名
     * @param port 端口号
     * @return 局域网可访问的文件URL
     */
    public static String generateFileUrl(String fileName, int port) {
        String lanIp = getLocalLanIp();
        return "http://" + lanIp + ":" + port + "/image/file/" + fileName;
    }
}
