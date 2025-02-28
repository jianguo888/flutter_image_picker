# Flutter 中使用imagepicker

这是一个示例 Flutter 应用程序，用于演示如何使用`imagepicker`包执行图像选择。适用于 iOS 和 Android 的 Flutter 插件，用于从相册中选取图像，并使用相机拍摄新照片。

https://pub.flutter-io.cn/packages/image_picker

此应用程序中展示的 imagepicker 功能如下：

- 从相册中选取图像

- 使用相机拍摄新照片

  

## 软件包

此应用程序中使用的软件包如下：

- [image_picker](https://pub.flutter-io.cn/packages/image_picker/install)

使用`pubspec.yaml`文件将它们添加到您的项目中

```yaml
dependencies:
  image_picker: ^0.8.4+4
```

如果没有使用 FVM，则直接编辑 pubspec_overrides.yaml 文件，没有则手动创建，添加以下内容：
# 鸿蒙适配
dependency_overrides:
  image_picker:
    git:
      url: https://gitcode.com/openharmony-sig/flutter_packages.git
      path: "packages/ image_picker/image_picker"



flutter create . --platforms=macos

flutter run -d macos


https://gitcode.com/openharmony-sig/flutter_packages/blob/master/packages/image_picker/image_picker_ohos/example/lib/main.dart

## 致谢

特别感谢俊伟在本项目开发过程中提供的宝贵支持和技术指导。他的专业知识和热心帮助对项目的顺利完成起到了重要作用。