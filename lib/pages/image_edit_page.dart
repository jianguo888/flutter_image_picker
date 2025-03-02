import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class ImageEditPage extends StatefulWidget {
  final dynamic image;
  final Function(dynamic) onImageEdited;

  const ImageEditPage({
    Key? key,
    required this.image,
    required this.onImageEdited,
  }) : super(key: key);

  @override
  _ImageEditPageState createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  double _brightness = 0.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _warmth = 0.0;
  double _sharpness = 0.0;

  Widget _buildImagePreview() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix([
          _contrast * (1 + _sharpness * 0.5),
          _warmth * 0.1,
          0,
          0,
          _brightness * 255,
          _warmth * 0.1,
          _contrast * (1 + _sharpness * 0.5),
          0,
          0,
          _brightness * 255,
          0,
          0,
          _contrast * (1 + _sharpness * 0.5) * (1 - _warmth * 0.1),
          0,
          _brightness * 255,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: Hero(
          tag: 'edit_image',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: kIsWeb
                ? Image.network(
                    widget.image,
                    fit: BoxFit.contain,
                  )
                : Image.file(
                    widget.image as File,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentControls() {
    return Column(
      children: [
        _buildAdjustmentSlider(
          '亮度',
          _brightness,
          -1.0,
          1.0,
          (value) => setState(() => _brightness = value),
          Icons.brightness_6,
        ),
        _buildAdjustmentSlider(
          '对比度',
          _contrast,
          0.0,
          2.0,
          (value) => setState(() => _contrast = value),
          Icons.contrast,
        ),
        _buildAdjustmentSlider(
          '饱和度',
          _saturation,
          0.0,
          2.0,
          (value) => setState(() => _saturation = value),
          Icons.color_lens,
        ),
        _buildAdjustmentSlider(
          '色温',
          _warmth,
          -1.0,
          1.0,
          (value) => setState(() => _warmth = value),
          Icons.wb_sunny,
        ),
        _buildAdjustmentSlider(
          '锐化',
          _sharpness,
          0.0,
          2.0,
          (value) => setState(() => _sharpness = value),
          Icons.blur_on,
        ),
      ],
    );
  }

  Widget _buildAdjustmentSlider(String title, double value, double min,
      double max, ValueChanged<double> onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                value.toStringAsFixed(2),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.blue.withOpacity(0.2),
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withOpacity(0.1),
              trackHeight: 4.0,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑图片'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 实现图片保存功能
              widget.onImageEdited(widget.image);
              Navigator.pop(context);
            },
            child: Text('完成', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImagePreview(),
            SizedBox(height: 16),
            _buildAdjustmentControls(),
          ],
        ),
      ),
    );
  }
}
