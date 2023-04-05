# SSPanel Uim Docker

使用 Docker 快速、简单地部署 SSPanel Uim！

优点：
- 将 SSPanel Uim 部署在 docker 上，允许你快速起步、集群管理
- 通过 Github Actions 快速构建镜像

## 部署方法

1. git clone 本项目到本地
2. 复制 `.env.example` 为 `.env` 并修改配置
3. 复制 `config.example` 到 config，并参考说明修改其中的配置
4. 复制 `docker-compose.example.yml` 为 `docker-compose.yml` 并修改其中的配置
5. 运行 `docker-compose up -d`
6. 容器首次启动后，请通过 `docker exec -it sspanel bash` 进入容器 bash，并运行 `sh firstup.sh` 完成初始化

## 构建镜像

如果你需要最新版本的 SSPanel Uim 代码，可以用以下方式构建镜像：

1. fork 本项目，手动运行 workflow
2. 也可以在 docker-compose.yml 中配置 `build: .`，然后运行 `docker-compose up -d --build`
