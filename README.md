# 智选数码 - 分布式电商订单系统

基于 Spring Cloud Alibaba 的分布式电商订单系统，实现了完整的"生成订单-扣库存-扣余额"业务流程。

## 技术栈

### 后端技术
- **Spring Boot 3.2.x** - 基础框架
- **Spring Cloud 2023.0.x** - 微服务框架
- **Spring Cloud Alibaba 2023.0.x** - 阿里巴巴微服务组件
- **Nacos** - 注册中心 + 配置中心
- **OpenFeign** - 声明式服务调用
- **Spring Cloud Gateway** - API 网关
- **Seata** - 分布式事务
- **MyBatis Plus** - ORM 框架
- **MySQL 8.0+** - 数据库

### 前端技术
- **Vue 3.4.x** - 前端框架
- **Vite** - 构建工具
- **Element Plus** - UI 组件库
- **Axios** - HTTP 客户端
- **Vue Router** - 路由管理

## 项目架构

```
┌─────────────────────────────────────────────────────────┐
│                     前端 (Vue3)                        │
│                   http://localhost:5173                │
└─────────────────────────┬───────────────────────────────┘
                          │ HTTP
┌─────────────────────────▼───────────────────────────────┐
│              Gateway (8080) - API 网关                   │
│          统一入口，路由转发，负载均衡                      │
└──────┬────────────────┬────────────────┬──────────────┘
       │                │                │
┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐
│user-service │ │product-service│ │order-service│
│  (8001)     │ │  (8002)      │ │  (8003)     │
│  用户管理    │ │  商品管理     │ │  订单管理    │
└──────┬──────┘ └──────┬──────┘ └──────┬──────┘
       │                │                │
       ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   db_user    │ │  db_product  │ │   db_order   │
│   用户库      │ │   商品库      │ │   订单库      │
└──────────────┘ └──────────────┘ └──────────────┘

┌─────────────────────────────────────────────────────────┐
│              Nacos (8848) - 注册中心 + 配置中心          │
│              Seata (7091/8091) - 分布式事务              │
└─────────────────────────────────────────────────────────┘
```

## 功能模块

### 用户模块
- [x] 用户注册（初始余额为0）
- [x] 用户登录
- [x] 余额查询
- [x] 余额充值
- [x] 余额扣减（分布式事务）

### 商品模块
- [x] 商品列表展示
- [x] 分类筛选（手机、笔记本、手表、耳机）
- [x] 商品详情查看
- [x] 库存管理
- [x] 库存扣减（分布式事务）

### 订单模块
- [x] 创建订单（分布式事务）
- [x] 订单查询
- [x] 订单列表展示

### 购物车模块
- [x] 添加购物车
- [x] 单个商品下单
- [x] 批量结算下单

## 核心特性

### 1. Nacos 注册中心
- 服务自动注册与发现
- 健康检查机制
- 负载均衡支持

### 2. OpenFeign 声明式调用
- 简化跨服务通信
- 负载均衡集成
- 声明式接口定义

### 3. Spring Cloud Gateway
- 统一 API 入口
- 路由转发
- 请求过滤

### 4. Nacos 配置中心
- 配置文件集中管理
- 配置动态刷新
- 环境隔离支持

### 5. Seata 分布式事务
- AT 模式自动处理
- 全局事务协调
- 异常自动回滚

## 项目结构

```
sca-order-vue-microservice/
├── backend/                          # 后端项目
│   └── backend-parent/               # 父工程
│       ├── common/                  # 公共模块
│       ├── user-service/           # 用户服务 (8001)
│       ├── product-service/         # 商品服务 (8002)
│       ├── order-service/          # 订单服务 (8003)
│       └── gateway-server/         # 网关服务 (8080)
├── frontend/                        # 前端项目
│   └── src/
│       ├── views/                  # 页面组件
│       │   ├── Auth/              # 认证模块
│       │   ├── Home/              # 首页模块
│       │   ├── Product/           # 商品模块
│       │   ├── Cart/              # 购物车模块
│       │   ├── Order/             # 订单模块
│       │   └── User/              # 用户模块
│       ├── assets/                # 静态资源
│       ├── router/                # 路由配置
│       └── utils/                 # 工具函数
├── nacos/                          # Nacos 配置
├── seata/                         # Seata 配置
├── sql/                           # 数据库脚本
└── README.md
```

## 环境要求

- JDK 21+
- Node.js 18+
- MySQL 8.0+
- Nacos 2.3.x
- Seata 2.0.x

## 快速启动

### 1. 启动基础设施

```bash
# 启动 Nacos
cd nacos/bin
startup.cmd -m standalone

# 启动 Seata
cd seata/bin
seata-server.bat
```

### 2. 初始化数据库

```bash
# 创建数据库并导入数据
mysql -u root -p < sql/*.sql
```

### 3. 启动后端服务

```bash
cd backend/backend-parent

# 启动用户服务
cd user-service
mvn spring-boot:run

# 启动商品服务
cd ../product-service
mvn spring-boot:run

# 启动订单服务
cd ../order-service
mvn spring-boot:run

# 启动网关服务
cd ../gateway-server
mvn spring-boot:run
```

### 4. 启动前端项目

```bash
cd frontend
npm install
npm run dev
```

### 5. 访问项目

- 前端地址：http://localhost:5173
- Nacos 控制台：http://localhost:8848/nacos （账号：nacos / nacos）
- Seata 控制台：http://localhost:7091

## 接口说明

### 用户服务 (8001)
| 接口 | 方法 | 说明 |
|------|------|------|
| /user/register | POST | 用户注册 |
| /user/login | POST | 用户登录 |
| /user/{id} | GET | 查询用户 |
| /user/{id}/balance | GET | 查询余额 |
| /user/{id}/deduct | POST | 扣减余额 |
| /user/recharge | POST | 充值 |

### 商品服务 (8002)
| 接口 | 方法 | 说明 |
|------|------|------|
| /product/{id} | GET | 商品详情 |
| /product/list | GET | 商品列表 |
| /product/deduct/{id} | POST | 扣减库存 |

### 订单服务 (8003)
| 接口 | 方法 | 说明 |
|------|------|------|
| /order/create/{userId}/{productId} | GET/POST | 创建订单 |
| /order/list/{userId} | GET | 订单列表 |

### 网关 (8080)
- 通过网关访问后端服务：http://localhost:8080/{service}/{path}

## 数据库说明

采用分库分表设计：

| 数据库 | 服务 | 说明 |
|--------|------|------|
| db_user | user-service | 用户信息 |
| db_product | product-service | 商品信息 |
| db_order | order-service | 订单信息 |

## 分布式事务流程

```
用户点击"立即下单"
        ↓
OrderController.createOrder()
        ↓
① 检查阶段（返回友好错误）
   ├─ 用户校验
   ├─ 商品信息获取
   ├─ 余额检查 → 余额不足返回错误
   └─ 库存检查 → 库存不足返回错误
        ↓
② 执行阶段（抛出异常触发回滚）
   ├─ 扣减库存 → 失败抛异常
   ├─ 扣减余额 → 失败抛异常
   └─ 创建订单
        ↓
③ Seata 事务提交/回滚
```

## 错误提示

| 场景 | 提示样式 | 提示信息 |
|------|----------|----------|
| 余额不足 | 黄色警告 | 💰 余额不足，当前余额：X元，商品价格：Y元 |
| 库存不足 | 黄色警告 | 📦 库存不足 |
| 下单成功 | 绿色提示 | ✅ 下单成功！ |
| 系统异常 | 红色错误 | ❌ 下单失败：XXX |

## 演示账号

注册后即可使用，无需预设账号。

## 技术亮点

1. **分布式事务一致性**：Seata AT 模式保证跨数据库操作的原子性
2. **服务治理**：Nacos 实现服务自动注册和配置集中管理
3. **声明式调用**：OpenFeign 简化跨服务通信
4. **统一入口**：Gateway 作为唯一入口，简化客户端调用
5. **实时数据同步**：下单后自动刷新库存和余额信息

## 许可证

MIT License
