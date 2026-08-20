# 智慧图书馆微服务管理系统

基于 Spring Boot、Spring Cloud Gateway、MyBatis-Plus、Vue 3、Element Plus、MySQL、Redis、Nacos 和 Docker Compose 的前后端分离课程项目。

## 演示账号

- 系统管理员：`admin / Admin@123`
- 图书管理员：`librarian / Library@123`
- 读者：`reader / Reader@123`

## Docker启动

```bash
cd docker
docker compose up -d --build
```

浏览器访问 `http://localhost:8088`。后端统一入口为 `http://localhost:8080`。

## 本地启动

1. 执行 `sql/library_all.sql`。
2. 启动 Nacos、MySQL 和 Redis。
3. 在根目录运行 `mvn clean package -DskipTests`。
4. 分别启动各服务。
5. 进入 `library-web`，执行 `npm install` 和 `npm run dev`。

详细说明见 `docs/运行与答辩说明.md`。

