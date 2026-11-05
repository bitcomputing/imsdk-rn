# JuggleIM React Native 即时通讯 SDK

简体中文 | [English](README.md)

[![npm 版本](https://img.shields.io/npm/v/juggleim-rnsdk?logo=npm)](https://www.npmjs.com/package/juggleim-rnsdk)
[![npm 下载量](https://img.shields.io/npm/dm/juggleim-rnsdk?logo=npm)](https://www.npmjs.com/package/juggleim-rnsdk)
[![GitHub Stars](https://img.shields.io/github/stars/juggleim/imsdk-rn?style=flat&logo=github)](https://github.com/juggleim/imsdk-rn/stargazers)
[![开源协议](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![React Native](https://img.shields.io/badge/React%20Native-%3E%3D0.60-61DAFB?logo=react)](https://reactnative.dev/)

**JuggleIM React Native SDK** 是一个采用 Apache 2.0 许可证的 React Native 即时通讯 SDK，为 **iOS 和 Android** 应用提供统一的原生 IM 能力封装与 TypeScript 类型定义。它支持单聊、群聊、聊天室、富媒体消息、已读回执、消息回应、会话管理、音视频通话、朋友圈以及适用于 AI 助手的流式消息。

![JuggleIM React Native iOS 和 Android 即时通讯 SDK 示例](image.png)

## 为什么选择 JuggleIM？

- **一套 API 覆盖 iOS 和 Android**：通过统一的 React Native 接口调用 JuggleIM 原生能力。
- **完整的消息能力**：支持消息收发、撤回、删除、搜索、合并转发、回应和已读回执。
- **丰富的消息类型**：支持文本、图片、文件、语音、视频、自定义、合并和流式文本消息。
- **完善的会话管理**：支持历史消息、未读数、草稿、置顶、免打扰、@ 提及和会话标签。
- **不止于基础聊天**：内置单人/多人音视频通话、用户与群组资料、朋友圈等能力。
- **开发体验友好**：提供 TypeScript 声明、事件监听器、完整 Demo 和详细 API 示例。

## 功能概览

| 能力 | 支持范围 |
| --- | --- |
| 即时通讯 | 单聊、群聊、聊天室、系统会话、历史消息、消息搜索 |
| 消息类型 | 文本、图片、文件、语音、视频、自定义、合并、AI 流式文本 |
| 消息状态 | 已读回执、撤回、删除、回应、置顶、销毁事件 |
| 会话管理 | 未读数、草稿、免打扰、置顶、标签、提及、分页拉取 |
| 音视频 | 基于 ZEGO 的单人和多人音视频通话 |
| 社交能力 | 朋友圈、评论、点赞/回应、缓存时间线 |
| 资料能力 | 用户、群组和群成员信息 |
| 平台支持 | React Native 0.60+、Android 21+、iOS 12+、TypeScript 类型定义 |

## 安装

直接从本仓库的 Git 主分支安装 RN 包：

```bash
npm install 'git+https://github.com/bitcomputing/imsdk-rn.git#main' --legacy-peer-deps
```

仓库根目录是 Git 包入口，JS 与原生桥接代码来自 `juggleim-rnsdk/`。`DEMO/package.json` 仍使用 `file:../juggleim-rnsdk` 做本地开发。此仓库 `main` 更新后，消费方需刷新锁文件才能拿到新的 RN 包提交。

原生 SDK 来自 [bitcomputing/imsdk-ios](https://github.com/bitcomputing/imsdk-ios) 和 [bitcomputing/imsdk-android](https://github.com/bitcomputing/imsdk-android) 的 `master`。每次 Android 构建在 Gradle 配置时拉取最新 Android 源码；DEMO 每次 iOS 构建前运行 `pod install`，拉取最新 iOS 源码并更新 Pods。网络拉取失败或 SDK 目录有未提交的改动时，构建会报错。构建日志会输出实际提交号。

Android 项目在 `android/settings.gradle` 中加入三个源码模块（React Native 封装本身由自动链接处理）：

```groovy
def juggleSdk = new File(settingsDir, '../node_modules/juggleim-rnsdk/juggleim-rnsdk/android/native')
def refresh = new ProcessBuilder('bash', new File(settingsDir, '../node_modules/juggleim-rnsdk/juggleim-rnsdk/scripts/refresh-native-sdk.sh').absolutePath, 'android')
    .directory(settingsDir).redirectErrorStream(true).start()
refresh.inputStream.eachLine { println it }
if (refresh.waitFor() != 0) throw new GradleException('Could not update Android IM SDK')
['core', 'zego', 'jpush'].each { component ->
    def moduleName = "juggle-im-${component}"
    include ":${moduleName}"
    project(":${moduleName}").projectDir = new File(juggleSdk, component)
}
```

Zego 通话模块还需要引擎仓库：

```groovy
maven { url "https://storage.zego.im/maven" }
```

iOS 项目在 `ios/Podfile` 的 app target 中指定源码 podspec，再安装依赖：

```ruby
sdk_refresh = File.expand_path('../node_modules/juggleim-rnsdk/juggleim-rnsdk/scripts/refresh-native-sdk.sh', __dir__)
raise 'Could not update iOS IM SDK' unless system('bash', sdk_refresh, 'ios')

target 'YourApp' do
pod 'JuggleIM', :path => '../node_modules/juggleim-rnsdk/juggleim-rnsdk', :modular_headers => true
pod 'JZegoCall', :path => '../node_modules/juggleim-rnsdk/juggleim-rnsdk'
end
```

```bash
cd ios && pod install
```

直接使用 `xcodebuild` 或 Xcode 时，选用包含构建前动作的 Scheme；其他应用需在构建前运行 `pod install`，让 Pods 工程纳入新增的上游文件。每次构建可能使用不同提交；如需复现某次构建，请记录日志中的两个 SDK 提交号。

## 快速开始

初始化 SDK、监听连接状态并使用用户 Token 建立连接：

```javascript
import JuggleIM from 'juggleim-rnsdk';

const unsubscribe = JuggleIM.addConnectionStatusListener(
  'app_connection',
  (status, code, extra) => {
    console.log('JuggleIM 连接状态：', status, code, extra);
  }
);

JuggleIM.setServerUrls(['your_server_url']);
JuggleIM.init('your_app_key');
JuggleIM.connect('your_user_token');

// 不再需要监听时调用 unsubscribe()。
```

发送一条文本消息：

```javascript
import { TextMessageContent } from 'juggleim-rnsdk';

JuggleIM.sendMessage(
  {
    conversationType: 1,
    conversationId: 'recipient_user_id',
    content: new TextMessageContent('你好，React Native！')
  },
  {
    onSuccess: message => console.log('发送成功：', message),
    onError: (message, errorCode) => console.error('发送失败：', errorCode)
  }
);
```

认证凭证和服务器地址请使用 JuggleIM 部署环境为你的应用签发的配置。

## 文档导航

- [完整 API 指南与示例](docs/API.zh-CN.md)
- [英文 README](README.md)
- [React Native 完整示例应用](DEMO/)
- [TypeScript API 类型声明](juggleim-rnsdk/src/index.d.ts)
- [问题反馈与技术支持](https://github.com/juggleim/imsdk-rn/issues)

原 README 中的监听器、会话、消息、通话、朋友圈、自定义消息和类型定义等 1112 行详细内容，已完整保留在[完整 API 指南](docs/API.zh-CN.md)中。

## 仓库结构

```text
.
├── juggleim-rnsdk/   # React Native 包、原生桥接和 TypeScript 类型
├── DEMO/             # iOS 与 Android 示例应用
├── docs/             # 详细文档
├── README.md         # 英文说明
└── README.zh-CN.md   # 简体中文说明
```

## 适用场景

JuggleIM 可作为社交应用、兴趣社区、在线客服、电商聊天、团队协作、App 内消息、AI 流式助手以及内嵌音视频通话产品的即时通讯基础能力。

## 参与贡献

欢迎提交 Issue 和 Pull Request。

1. Fork 仓库并创建职责清晰的分支。
2. 保持改动精简，并复用现有 React Native、Android 和 iOS 实现模式。
3. 对外接口和方法需要补充中文接口文档；复杂或关键逻辑需要增加 `TIPS` 注释。
4. 提交 Pull Request 前，请运行与改动相关的最小构建或测试。

反馈 Bug 时，建议附上 React Native 版本、平台与系统版本、复现步骤、日志和可运行的最小示例。

## 获取支持

- Bug 与功能建议：[GitHub Issues](https://github.com/juggleim/imsdk-rn/issues)
- 邮箱：[support@juggleim.com](mailto:support@juggleim.com)

如果这个 React Native 即时通讯 SDK 对你的项目有帮助，欢迎为仓库点一个 Star，让更多开发者能够发现并评估它。

## 开源协议

本项目基于 [Apache License 2.0](LICENSE) 开源。
