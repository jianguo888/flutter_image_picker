import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class SocialSharePage extends StatefulWidget {
  final List<dynamic> images;

  const SocialSharePage({Key? key, required this.images}) : super(key: key);

  @override
  _SocialSharePageState createState() => _SocialSharePageState();
}

class _SocialSharePageState extends State<SocialSharePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: kIsWeb
              ? Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                )
              : Image.file(
                  widget.images[index] as File,
                  fit: BoxFit.cover,
                ),
        );
      },
    );
  }

  final List<String> _platformTags = ['Android', 'iOS', '鸿蒙', 'Web', '摄影', '风景', '美食', '人像', '旅行', '生活'];

  final Map<String, Color> _tagColors = {
    'Android': Colors.green,
    'iOS': Colors.blue,
    '鸿蒙': Colors.orange,
    'Web': Colors.purple,
    '摄影': Colors.teal,
    '风景': Colors.lightBlue,
    '美食': Colors.red,
    '人像': Colors.pink,
    '旅行': Colors.amber,
    '生活': Colors.indigo,
  };

  Widget _buildTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            hintText: '添加标签',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addTag,
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '热门标签推荐',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _platformTags.map((tag) => ActionChip(
                  avatar: Icon(
                    Icons.local_offer,
                    size: 16,
                    color: _tagColors[tag]?.withOpacity(0.8),
                  ),
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: _tagColors[tag]?.withOpacity(0.8),
                    ),
                  ),
                  backgroundColor: _tagColors[tag]?.withOpacity(0.1),
                  onPressed: () {
                    if (!_tags.contains(tag)) {
                      setState(() {
                        _tags.add(tag);
                      });
                    }
                  },
                )).toList(),
              ),
            ],
          ),
        ),
        if (_tags.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              children: _tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建动态'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 实现分享功能
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('分享成功！')),
              );
            },
            child: Text(
              '分享',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageGrid(),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: '这一刻的想法...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            _buildTagInput(),
          ],
        ),
      ),
    );
  }
}