FROM jupyter/minimal-notebook:python-3.11.5

# 复制 requirements.txt 文件到容器
COPY requirements.txt /tmp/

# 安装 requirements.txt 中的依赖
RUN pip install --no-cache-dir -r /tmp/requirements.txt