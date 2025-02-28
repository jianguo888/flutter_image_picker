import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 这是应用程序的根Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

enum ImageSourceType { gallery, camera }

class HomePage extends StatelessWidget {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker 示例"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.blue,
                child: Text(
                  "Pick Image from 相册",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: Text(
                  "Pick Image from 相机",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.camera);
                },
              ),
            ],
          ),
        ));
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    // 忽略: todo
    // TODO: 实现initState
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from 相机"
              : "Image from 相册")),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.front);
                setState(() {
                  if (kIsWeb) {
                    _image = image.path;
                  } else {
                    _image = File(image.path);
                  }
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                    ? kIsWeb
                        ? Image.network(
                            _image,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.fitHeight,
                          )
                        : Image.file(
                            _image,
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.fitHeight,
                          )
                    : Container(
                        decoration: BoxDecoration(color: Colors.red[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // 这个setState调用告诉Flutter框架状态发生了变化
      // 这将导致重新运行下面的build方法，以便显示更新后的值
      // 如果我们在不调用setState()的情况下更改_counter
      // 那么build方法将不会被再次调用，界面也不会有任何变化
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 每次调用setState时都会重新运行此方法，例如上面的_incrementCounter方法
    //
    // Flutter框架已经过优化，使重新运行build方法变得很快
    // 这样你就可以只重建需要更新的内容，而不必单独更改widget实例
    return Scaffold(
      appBar: AppBar(
        // 这里我们从由App.build方法创建的MyHomePage对象中获取值
        // 并用它来设置我们的appbar标题
        title: Text(widget.title),
      ),
      body: Center(
        // Center是一个布局widget，它接收一个子widget并将其定位在父widget的中心
        child: Column(
          // Column也是一个布局widget，它接收一个子widget列表并垂直排列它们
          // 默认情况下，它会调整自身大小以适应其子widget的水平方向
          // 并尝试在垂直方向上占据父widget的所有空间
          //
          // 要查看每个widget的线框，可以使用"调试绘制"
          // (在控制台按"p"，在Android Studio的Flutter检查器中选择
          // "Toggle Debug Paint"操作，或在Visual Studio Code中使用
          // "Toggle Debug Paint"命令)
          //
          // Column有各种属性来控制其大小和子widget的位置
          // 这里我们使用mainAxisAlignment来垂直居中子widget
          // 主轴在这里是垂直轴，因为Column是垂直的（横轴是水平的）
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // 这个尾随逗号可以让build方法的自动格式化更整洁
    );
  }
}
