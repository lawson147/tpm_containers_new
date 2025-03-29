首先安装docker和docker-compose

运行./build.sh，目的是编译sd5镜像
运行./sub_tpm_server/build.sh，目的是编译sd5s镜像
sd5镜像里面安装了tpm2-abrmd、tss和tpm2-tools，
sd5s镜像里面安装了tpm-server，
sd5依赖于sd5s

以上两个镜像都编译成功后，运行
docker-compose up
指令以启动base于这两个镜像的容器


调试和开发：
build.sh脚本用于构建最新的latest版本的镜像
run.sh脚本用于快速启动和进入容器，检查Dockerfile的修改是否正确
stop.sh和remove.sh脚本用于删除所有容器（测试开发时常用）
