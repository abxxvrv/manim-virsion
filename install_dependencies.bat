@echo off
echo 安装 Manim 及其依赖项

REM 确保已安装 Python 3.9+ (Manim 不建议使用 Python 3.13)
python --version

REM 安装 Manim
echo 安装 Manim Community v0.19.0...
pip install manim==0.19.0

REM 安装 FFmpeg
echo 检查 FFmpeg...
where ffmpeg >nul 2>&1
if %errorlevel% neq 0 (
    echo FFmpeg 未找到，将安装 FFmpeg...
    
    REM 使用 chocolatey 安装 FFmpeg (如果有)
    where choco >nul 2>&1
    if %errorlevel% equ 0 (
        echo 使用 Chocolatey 安装 FFmpeg...
        choco install ffmpeg -y
    ) else (
        echo 请手动安装 FFmpeg 并添加到 PATH 环境变量
        echo 下载地址: https://ffmpeg.org/download.html
        echo 或者使用 pip install imageio-ffmpeg
        pip install imageio-ffmpeg
    )
) else (
    echo FFmpeg 已安装
)

REM 安装 LaTeX (MiKTeX)
echo 检查 LaTeX (如果需要渲染公式)...
where pdflatex >nul 2>&1
if %errorlevel% neq 0 (
    echo LaTeX 未找到，建议安装 MiKTeX 以支持公式渲染
    echo 下载地址: https://miktex.org/download
) else (
    echo LaTeX 已安装
)

REM 测试 Manim 安装
echo 创建测试文件...
echo from manim import * > test_manim.py
echo. >> test_manim.py
echo class CircleTest(Scene): >> test_manim.py
echo     def construct(self): >> test_manim.py
echo         circle = Circle() >> test_manim.py
echo         self.add(circle) >> test_manim.py

echo 测试 Manim 安装...
manim -ql test_manim.py CircleTest

echo 安装完成
pause 