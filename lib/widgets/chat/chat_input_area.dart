import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../viewmodels/chat_viewmodel.dart';
import './ingredient_input.dart';
import '../../widgets/common/custom_button.dart';
import '../../theme/responsive.dart';

class ChatInputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback scrollToBottom;

  const ChatInputArea({
    super.key,
    required this.controller,
    required this.scrollToBottom,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleAddIngredient(BuildContext context) async {
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;

    final vm = context.read<ChatViewModel>();
    await vm.addIngredient(text);
    widget.controller.clear();
  }

  Future<void> _handleVoiceRecognition(BuildContext context) async {
    final vm = context.read<ChatViewModel>();
    if (vm.isListening) {
      await vm.stopListening();
    } else {
      await vm.startListening();
    }
  }

  Future<void> _handleImagePicker(BuildContext context) async {
    try {
      final source = await _showImageSourceDialog(context);
      if (source == null) return;

      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final vm = context.read<ChatViewModel>();

      _showLoadingSnackBar(context);

      await vm.addIngredientsFromImage(file);
      widget.scrollToBottom();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fotoğraf başarıyla işlendi!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf işlenirken hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğraf Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLoadingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Text('Fotoğraf işleniyor...'),
          ],
        ),
        duration: Duration(seconds: 10),
      ),
    );
  }

  Future<void> _handleGenerateRecipe(BuildContext context) async {
    final vm = context.read<ChatViewModel>();
    await vm.generateRecipe();
    widget.scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.width(context, 0.04),
          vertical: Responsive.height(context, 0.01),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IngredientInput(
              controller: widget.controller,
              onAddIngredient: () => _handleAddIngredient(context),
              onVoiceTap: () => _handleVoiceRecognition(context),
              onCameraTap: () => _handleImagePicker(context),
            ),
            SizedBox(height: Responsive.height(context, 0.01)),
            Consumer<ChatViewModel>(
              builder: (context, vm, child) {
                return CustomButton(
                  text: vm.ingredients.isEmpty
                      ? 'Önce malzeme ekleyin'
                      : 'Tarif Oluştur (${vm.ingredients.length} malzeme)',
                  onPressed: vm.ingredients.isEmpty || vm.isLoading
                      ? null
                      : () => _handleGenerateRecipe(context),
                  isLoading: vm.isLoading,
                  icon: vm.ingredients.isEmpty
                      ? Icons.info_outline
                      : Icons.auto_awesome,
                  height: Responsive.height(context, 0.06),
                  borderRadius: BorderRadius.circular(12),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
