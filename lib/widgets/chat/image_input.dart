import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Future<void> Function(File file) onImageSelected;

  const ImageInput({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  bool _isExpanded = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
        source: source, imageQuality: 80, maxWidth: 800);
    if (picked == null) return;

    final file = File(picked.path);
    setState(() {
      _selectedImage = file;
      _isExpanded = false;
    });

    await widget.onImageSelected(file);
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isExpanded = false);
    });
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamerayı Kullan'),
              onTap: () {
                Navigator.of(ctx).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Seçimi Kaldır'),
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isExpanded ? _showPickerOptions : _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 120 : 50,
        width: _isExpanded ? double.infinity : 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(_isExpanded ? 12 : 50),
          color: Colors.grey.shade100,
        ),
        child: Stack(
          children: [
            if (_isExpanded)
              _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child:
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                    )
            else
              const Center(
                child: Icon(Icons.camera_alt, size: 28, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
