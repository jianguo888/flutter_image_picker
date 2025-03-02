import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'pages/social_share_page.dart';
import 'pages/image_edit_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 这是应用程序的根Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicStudio',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

enum ImageSourceType { gallery, camera }

class HomePage extends StatelessWidget {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ImageFromGalleryEx(type),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "图片选择器",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              "选择图片来源",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "从相册或相机中选择图片，最多可选择9张",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 280,
              height: 56,
              child: ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text("从相册选择"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 280,
              height: 56,
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("拍摄照片"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(color: Colors.blue),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.camera);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  List<dynamic> _images = [];
  late ImagePicker imagePicker;
  ImageSourceType type;
  static const int maxImages = 9;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  void _navigateToSocialShare() {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请至少选择一张图片')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocialSharePage(images: _images),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (_images.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('最多只能选择9张图片')),
      );
      return;
    }

    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);

    if (image != null) {
      setState(() {
        if (kIsWeb) {
          _images.add(image.path);
        } else {
          _images.add(File(image.path));
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('图片顺序已更新'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildImageGrid() {
    List<Widget> gridItems = List.generate(_images.length, (index) {
      return Card(
        key: ValueKey(_images[index]),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditPage(
                    image: _images[index],
                    onImageEdited: (editedImage) {
                      setState(() {
                        _images[index] = editedImage;
                      });
                    },
                  ),
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'image_$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: kIsWeb
                        ? Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _removeImage(index),
                      customBorder: CircleBorder(),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    if (_images.length < maxImages) {
      gridItems.add(
        Card(
          key: ValueKey('add_button'),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add_photo_alternate,
                color: Colors.grey[800],
                size: 40,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PicStudio",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_images.isNotEmpty)
            TextButton(
              onPressed: _navigateToSocialShare,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('下一步', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImageGrid(),
          ],
        ),
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
