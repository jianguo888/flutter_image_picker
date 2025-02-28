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

## License



flutter create . --platforms=macos

flutter run -d macos