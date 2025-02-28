# Flutter Image Picker 示例项目

这是一个示例 Flutter 应用程序，用于演示如何使用 `image_picker` 包实现图片选择功能。该项目支持 iOS、Android、Web、macOS 和鸿蒙等多个平台，可以从相册中选取图像或使用相机拍摄新照片。

## 功能特点

- 从相册中选取图像
- 使用相机拍摄新照片
- 支持多平台（iOS、Android、Web、macOS、鸿蒙）
- 简单易用的API接口

## 环境要求

- Flutter SDK: >=3.0.0 <4.0.0
- Dart SDK: >=3.0.0

## 安装配置

1. 将以下依赖添加到项目的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.4
  cupertino_icons: ^1.0.6
```

2. 运行以下命令安装依赖：

```bash
flutter pub get
```

### 平台特定配置

#### iOS 配置

在 `ios/Runner/Info.plist` 文件中添加以下权限：

```xml
<key>NSCameraUsageDescription</key>
<string>需要访问相机以拍摄照片</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册以选择照片</string>
```

#### Android 配置

确保在 `android/app/src/main/AndroidManifest.xml` 文件中添加以下权限：

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### macOS 配置

1. 启用 macOS 平台支持：

```bash
flutter create . --platforms=macos
```

2. 在 `macos/Runner/Info.plist` 文件中添加相关权限。

#### 鸿蒙系统适配

如果需要支持鸿蒙系统，在 `pubspec.yaml` 文件中添加以下配置：

```yaml
dependency_overrides:
  image_picker:
    git:
      url: https://gitcode.com/openharmony-sig/flutter_packages.git
      path: "packages/image_picker/image_picker"
```

## 使用示例

```dart
import 'package:image_picker/image_picker.dart';

// 创建 ImagePicker 实例
final ImagePicker picker = ImagePicker();

// 从相册选择图片
final XFile? image = await picker.pickImage(source: ImageSource.gallery);

// 使用相机拍照
final XFile? photo = await picker.pickImage(source: ImageSource.camera);
```

更多示例代码可以参考：[鸿蒙示例代码](https://gitcode.com/openharmony-sig/flutter_packages/blob/master/packages/image_picker/image_picker_ohos/example/lib/main.dart)

## 运行项目

1. iOS/Android:
```bash
flutter run
```

2. macOS:
```bash
flutter run -d macos
```

3. Web:
```bash
flutter run -d chrome
```

## 相关链接

- [image_picker 插件文档](https://pub.flutter-io.cn/packages/image_picker)
- [Flutter 官方文档](https://flutter.dev/docs)

## 致谢

特别感谢俊伟在本项目开发过程中提供的宝贵支持和技术指导。他的专业知识和热心帮助对项目的顺利完成起到了重要作用。