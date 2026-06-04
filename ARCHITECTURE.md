# 网易云音乐 Flutter 架构设计文档

## 1. 技术选型

| 层级 | 方案 | 理由 |
|------|------|------|
| 状态管理 | **GetX** | 轻量、响应式、依赖注入、路由一体化 |
| 网络请求 | **Dio** | 拦截器、取消请求、FormData支持 |
| 本地存储 | **GetStorage** | 轻量KV存储，GetX生态 |
| 路由 | **GetX路由** | 命名路由、中间件、转场动画 |
| 音频播放 | **just_audio** | 跨平台、后台播放、锁屏控制 |
| 图片缓存 | **cached_network_image** | 内存+磁盘双缓存 |
| JSON序列化 | **json_annotation + freezed** | 不可变模型、代码生成 |

## 2. 项目分层架构

```
lib/
├── app/                        # 应用层配置
│   ├── app.dart                # MaterialApp入口
│   ├── routes.dart             # 路由表定义
│   ├── pages.dart              # 页面导出桶文件
│   └── middlewares/            # 路由中间件(登录守卫等)
│
├── config/                     # 全局配置
│   ├── theme/                  # 主题系统
│   │   ├── app_colors.dart     # 颜色常量
│   │   ├── app_text_styles.dart # 文字样式
│   │   ├── app_dimensions.dart  # 尺寸/间距/圆角
│   │   ├── app_theme.dart       # ThemeData组装
│   │   └── glass_decorations.dart # 液态玻璃组件样式
│   ├── constants.dart          # API地址、存储Key等
│   └── env.dart                # 环境变量(dev/prod)
│
├── core/                       # 核心基础设施
│   ├── network/                # 网络层
│   │   ├── api_client.dart     # Dio单例 + 拦截器
│   │   ├── api_response.dart   # 统一响应模型
│   │   └── api_exception.dart  # 自定义异常
│   ├── storage/                # 存储层
│   │   └── local_storage.dart  # GetStorage封装
│   ├── audio/                  # 音频引擎
│   │   ├── audio_player.dart   # just_audio封装
│   │   ├── audio_state.dart    # 播放状态模型
│   │   └── audio_service.dart  # 后台播放服务
│   └── utils/                  # 工具类
│       ├── logger.dart         # 日志工具
│       ├── formatters.dart     # 数字/时间格式化
│       └── extensions.dart     # Dart扩展方法
│
├── data/                       # 数据层(全局共享)
│   ├── models/                 # 数据模型(freezed)
│   │   ├── song_model.dart
│   │   ├── playlist_model.dart
│   │   ├── artist_model.dart
│   │   ├── album_model.dart
│   │   ├── user_model.dart
│   │   ├── banner_model.dart
│   │   └── comment_model.dart
│   ├── providers/              # 数据源
│   │   ├── song_provider.dart  # 歌曲API
│   │   ├── playlist_provider.dart
│   │   ├── user_provider.dart
│   │   └── ...
│   └── repositories/           # 仓库(组合Provider + 缓存)
│       ├── song_repository.dart
│       └── ...
│
├── modules/                    # 业务模块(按功能划分)
│   ├── splash/                 # 启动页
│   │   ├── splash_page.dart
│   │   └── splash_controller.dart
│   │
│   ├── main/                   # 主框架(TabBar)
│   │   ├── main_page.dart      # Scaffold + BottomNavBar
│   │   ├── main_controller.dart
│   │   └── bindings.dart
│   │
│   ├── home/                   # 发现页
│   │   ├── home_page.dart
│   │   ├── home_controller.dart
│   │   └── widgets/
│   │       ├── banner_widget.dart
│   │       ├── quick_entries.dart
│   │       ├── playlist_section.dart
│   │       └── new_songs_section.dart
│   │
│   ├── player/                 # 播放器(全局浮层)
│   │   ├── player_page.dart    # 全屏播放器
│   │   ├── player_controller.dart
│   │   ├── mini_player.dart    # 迷你播放器组件
│   │   └── widgets/
│   │       ├── vinyl_disc.dart # 黑胶唱片
│   │       ├── needle.dart     # 唱针
│   │       ├── lyrics_view.dart # 歌词
│   │       └── progress_bar.dart
│   │
│   ├── search/                 # 搜索
│   ├── playlist/               # 歌单(广场+详情)
│   ├── artist/                 # 歌手(列表+详情)
│   ├── album/                  # 专辑详情
│   ├── podcast/                # 播客/电台
│   ├── mine/                   # 我的
│   ├── follow/                 # 关注
│   ├── account/                # 账号
│   ├── login/                  # 登录
│   ├── comments/               # 评论
│   ├── messages/               # 消息
│   ├── fm/                     # 私人FM
│   ├── charts/                 # 排行榜
│   ├── style/                  # 风格
│   ├── live/                   # 直播
│   ├── yunbei/                 # 云贝
│   ├── musician/               # 音乐人
│   └── listentogether/         # 一起听
│
├── shared/                     # 共享组件
│   ├── widgets/                # 通用Widget
│   │   ├── glass_card.dart     # 液态玻璃卡片
│   │   ├── glass_app_bar.dart  # 液态玻璃导航栏
│   │   ├── glass_tab_bar.dart  # 液态玻璃TabBar
│   │   ├── song_tile.dart      # 歌曲列表项
│   │   ├── playlist_card.dart  # 歌单卡片
│   │   ├── artist_tile.dart    # 歌手列表项
│   │   ├── avatar.dart         # 头像组件
│   │   ├── badge.dart          # 角标
│   │   ├── skeleton.dart       # 骨架屏
│   │   ├── empty_state.dart    # 空状态
│   │   └── error_state.dart    # 错误状态
│   └── services/               # 共享服务
│       ├── auth_service.dart   # 登录状态管理
│       └── player_service.dart # 全局播放器服务
│
└── main.dart                   # 入口
```

## 3. 状态管理策略

```
┌─────────────────────────────────────────────┐
│                 GetX Architecture           │
├─────────────────────────────────────────────┤
│  Page ←→ Controller ←→ Repository ←→ API   │
│    │         │              │               │
│    │     Rx<T>         Cache + Remote       │
│    │    响应式状态       数据仓库            │
│    │                                       │
│  Widget     Service(全局单例)               │
│  局部组件    AuthService / PlayerService    │
└─────────────────────────────────────────────┘
```

- **Controller**: 页面级状态，GetxController生命周期绑定Page
- **Service**: 全级单例(Get.put + permanent:true)，跨页面共享
- **Rx<T>**: 响应式变量，UI自动更新
- **Repository**: 数据仓库，封装Provider + 本地缓存策略

## 4. 网络层设计

```dart
// API响应统一格式
{
  "code": 200,
  "data": { ... },
  "message": "ok"
}

// Dio配置
- BaseURL: http://124.156.194.16:3000
- 拦截器: 日志 / Token注入 / 错误处理 / 重试
- 超时: 连接10s / 读取15s
- 取消: 页面销毁时自动取消pending请求
```

## 5. 路由设计

```dart
// 命名路由 + GetX中间件
GetPage(
  name: '/player',
  page: () => PlayerPage(),
  binding: PlayerBinding(),
  middlewares: [AuthMiddleware()],  // 需要登录
  transition: Transition.downToUp, // 底部弹出
)
```

## 6. 主题设计

- 暗色主题: #0a0a0a 背景
- 液态玻璃: `BackdropFilter` + `ImageFilter.blur`
- 强调色: #EC4141
- 字体: SF Pro Display / PingFang SC (系统字体)
- 圆角: 16~24px
- 间距: 4px网格系统

## 7. 开发规范

1. **命名**: snake_case文件名，PascalCase类名
2. **导出**: 每个模块目录下 barrel file (xxx_exports.dart)
3. **依赖**: Binding中注册Controller，禁止手动put
4. **测试**: 每个Repository写单元测试，每个Page写Widget测试
5. **Git**: main保护 + develop主线 + feat/xxx功能分支
