#!/usr/bin/env python3
"""
局域网图片上传脚本
用于将图片文件上传到局域网配置中心服务，并将 URL 存入 ReturnImages 数组
"""

import argparse
import json
import os
import requests


def upload_image(image_path, upload_url):
    """
    上传图片
    :param image_path: 图片文件路径
    :param upload_url: 上传地址
    :return: 上传结果（图片 URL）
    """
    try:
        with open(image_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(upload_url, files=files)
            response.raise_for_status()
            return response.text
    except Exception as e:
        print(f"上传失败: {e}")
        return None


def add_to_return_images(image_url, config_url):
    """
    将图片 URL 添加到 ReturnImages 数组
    :param image_url: 图片 URL
    :param config_url: 配置接口 URL
    :return: 是否成功
    """
    try:
        # 获取当前配置
        response = requests.get(config_url)
        response.raise_for_status()
        config = response.json()
        
        # 更新 ReturnImages 数组
        if 'ReturnImages' not in config:
            config['ReturnImages'] = []
        config['ReturnImages'].append(image_url)
        
        # 保存配置
        update_url = config_url.replace('/url-list', '/updateConfig')
        response = requests.post(update_url, json=config)
        response.raise_for_status()
        return True
    except Exception as e:
        print(f"添加到 ReturnImages 失败: {e}")
        return False


def main():
    """
    主函数
    """
    # 解析命令行参数
    parser = argparse.ArgumentParser(description='局域网图片上传脚本')
    parser.add_argument('image', help='图片文件路径')
    parser.add_argument('--upload-url', default='http://10.12.52.1:8888/sysFile/upload',
                        help='上传接口 URL (默认: http://10.12.52.1:8888/sysFile/upload)')
    parser.add_argument('--config-url', default='http://10.12.52.1:8888/sysFile/url-list',
                        help='配置接口 URL (默认: http://10.12.52.1:8888/sysFile/url-list)')
    
    args = parser.parse_args()
    image_path = args.image
    upload_url = args.upload_url
    config_url = args.config_url
    
    # 检查图片文件是否存在
    if not os.path.exists(image_path):
        print(f"错误: 图片文件 '{image_path}' 不存在")
        return
    
    if not os.path.isfile(image_path):
        print(f"错误: '{image_path}' 不是一个文件")
        return
    
    print(f"正在上传图片...")
    print(f"上传地址: {upload_url}")
    
    # 上传图片
    image_url = upload_image(image_path, upload_url)
    if not image_url:
        return
    
    print(f"上传成功!")
    print(f"图片 URL: {image_url}")
    
    # 将图片 URL 添加到 ReturnImages 数组
    print(f"\n正在将图片 URL 添加到 ReturnImages 数组...")
    if add_to_return_images(image_url, config_url):
        print("添加成功!")
        
        # 显示更新后的配置
        print("\n更新后的配置:")
        response = requests.get(config_url)
        if response.status_code == 200:
            config = response.json()
            print(json.dumps(config, indent=2, ensure_ascii=False))
    else:
        print("添加失败，请检查网络连接或配置")


if __name__ == '__main__':
    main()
