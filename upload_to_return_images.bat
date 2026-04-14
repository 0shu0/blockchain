@echo off

rem 局域网图片上传批处理脚本
rem 将图片上传到服务并添加到 ReturnImages 数组

rem 检查脚本文件是否存在
if not exist "%~dp0upload_to_return_images.py" (
    echo 错误: 找不到 upload_to_return_images.py 脚本文件
    pause
    exit /b 1
)

rem 尝试使用不同的 Python 命令
set PYTHON_CMD=python

rem 检查 python 命令是否可用
%PYTHON_CMD% --version >nul 2>&1
if %errorlevel% neq 0 (
    rem 尝试使用 python3 命令
    set PYTHON_CMD=python3
    %PYTHON_CMD% --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo 错误: 未找到 Python 解释器
        echo 请先安装 Python 3.6 或更高版本，并确保将其添加到系统 PATH 中
        pause
        exit /b 1
    )
)

rem 运行上传脚本
echo 使用 Python 命令: %PYTHON_CMD%
%PYTHON_CMD% "%~dp0upload_to_return_images.py" %*

pause
