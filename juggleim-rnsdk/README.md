# JuggleIM React Native SDK

[English documentation](https://github.com/juggleim/imsdk-rn#readme) | [简体中文文档](https://github.com/juggleim/imsdk-rn/blob/main/README.zh-CN.md)

[![npm version](https://img.shields.io/npm/v/juggleim-rnsdk?logo=npm)](https://www.npmjs.com/package/juggleim-rnsdk)
[![license](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/juggleim/imsdk-rn/blob/main/LICENSE)
[![React Native](https://img.shields.io/badge/React%20Native-%3E%3D0.60-61DAFB?logo=react)](https://reactnative.dev/)

JuggleIM is a React Native chat and instant messaging SDK for iOS and Android. It provides TypeScript definitions and native support for private chat, group chat, chat rooms, rich media messages, read receipts, reactions, conversation management, voice/video calls, social moments, and AI streaming messages.

## Features

- Private chat, group chat, chat rooms, and system conversations
- Text, image, file, voice, video, custom, merged, and streaming messages
- Message history, search, recall, deletion, reactions, and read receipts
- Unread counts, drafts, mute, pin, mentions, and conversation tags
- One-to-one and multi-party voice/video calls
- User/group profiles and social moments
- React Native 0.60+, Android 21+, iOS 12+, and TypeScript declarations

## Installation

This directory is used as a local package by `DEMO/package.json` (`file:../juggleim-rnsdk`). For another app, install the repository's `main` directly from Git and use the native paths in the [root installation guide](../README.md#installation). The paths below apply to the local `file:` package.

This package fetches the latest `master` source from [bitcomputing/imsdk-ios](https://github.com/bitcomputing/imsdk-ios) and [bitcomputing/imsdk-android](https://github.com/bitcomputing/imsdk-android) during native builds. A fetch failure or local SDK edit fails the build. Add this update step and the source modules to `android/settings.gradle`:

```groovy
def juggleSdk = file('../node_modules/juggleim-rnsdk/android/native')
def refresh = new ProcessBuilder('bash', new File(juggleSdk, '../scripts/refresh-native-sdk.sh').absolutePath, 'android')
    .directory(settingsDir).redirectErrorStream(true).start()
refresh.inputStream.eachLine { println it }
if (refresh.waitFor() != 0) throw new GradleException('Could not update Android IM SDK')
['core', 'zego', 'jpush'].each { component ->
    def moduleName = "juggle-im-${component}"
    include ":${moduleName}"
    project(":${moduleName}").projectDir = new File(juggleSdk, component)
}
```

For Android voice/video calls, also add:

```groovy
maven { url "https://storage.zego.im/maven" }
```

For iOS, add this to the Podfile before `use_native_modules!`:

```ruby
sdk_refresh = File.expand_path('../node_modules/juggleim-rnsdk/scripts/refresh-native-sdk.sh', __dir__)
raise 'Could not update iOS IM SDK' unless system('bash', sdk_refresh, 'ios')

target 'YourApp' do
  pod 'JuggleIM', :path => '../node_modules/juggleim-rnsdk', :modular_headers => true
  pod 'JZegoCall', :path => '../node_modules/juggleim-rnsdk'
end
```

Run `pod install` before each app build; in Xcode, this can be a scheme pre-action. The podspecs read the current upstream version, Git commit, and public headers at install time. The npm package omits native source snapshots; the first native build clones the Git source.

## Quick start

```javascript
import JuggleIM, { TextMessageContent } from 'juggleim-rnsdk';

JuggleIM.setServerUrls(['your_server_url']);
JuggleIM.init('your_app_key');
JuggleIM.connect('your_user_token');

JuggleIM.sendMessage(
  {
    conversationType: 1,
    conversationId: 'recipient_user_id',
    content: new TextMessageContent('Hello from React Native!')
  },
  {
    onSuccess: message => console.log('Sent:', message),
    onError: (message, errorCode) => console.error('Send failed:', errorCode)
  }
);
```

## Documentation and support

- [English documentation](https://github.com/juggleim/imsdk-rn#readme)
- [简体中文文档](https://github.com/juggleim/imsdk-rn/blob/main/README.zh-CN.md)
- [Complete API examples](https://github.com/juggleim/imsdk-rn/blob/main/docs/API.zh-CN.md)
- [Demo application](https://github.com/juggleim/imsdk-rn/tree/main/DEMO)
- [GitHub Issues](https://github.com/juggleim/imsdk-rn/issues)

## License

[Apache License 2.0](https://github.com/juggleim/imsdk-rn/blob/main/LICENSE)
