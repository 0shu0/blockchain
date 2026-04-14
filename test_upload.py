#!/usr/bin/env python3
"""
测试图片上传功能
"""

import requests


def upload_image():
    """
    上传图片
    """
    url = "http://10.12.52.1:8888/sysFile/upload"
    file_path = "vue/public/favicon.ico"
    
    try:
        with open(file_path, 'rb') as f:
            files = {'file': f}
            response = requests.post(url, files=files)
            response.raise_for_status()
            print(f"上传成功!")
            print(f"回传地址: {response.text}")
            return response.text
    except Exception as e:
        print(f"上传失败: {e}")
        return None


def add_image_to_config(upload_url, return_url):
    """
    添加图片到配置
    """
    url = "http://10.12.52.1:8888/sysFile/addImage"
    
    try:
        response = requests.post(url, json={
            "uploadUrl": upload_url,
            "returnUrl": return_url
        })
        response.raise_for_status()
        print("\n添加图片到配置成功!")
        return response.json()
    except Exception as e:
        print(f"添加图片到配置失败: {e}")
        return None


def get_config():
    """
    获取配置
    """
    url = "http://10.12.52.1:8888/sysFile/url-list"
    
    try:
        response = requests.get(url)
        response.raise_for_status()
        config = response.json()
        print("\n当前配置:")
        print(f"UploadImages: {config.get('UploadImages', [])}")
        print(f"ReturnImages: {config.get('ReturnImages', [])}")
        return config
    except Exception as e:
        print(f"获取配置失败: {e}")
        return None


def main():
    """
    主函数
    """
    print("测试图片上传功能...")
    
    # 上传图片
    return_url = upload_image()
    
    if return_url:
        # 添加图片到配置（使用完整的图片URL作为上传地址）
        add_image_to_config(return_url, return_url)
    
    # 获取配置
    get_config()


if __name__ == '__main__':
    main()
