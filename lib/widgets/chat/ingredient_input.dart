import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class IngredientInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddIngredient;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onCameraTap;

  const IngredientInput({
    super.key,
    required this.controller,
    required this.onAddIngredient,
    this.onVoiceTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Malzeme girin...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              contentPadding: EdgeInsets.symmetric(
                vertical: Responsive.height(context, 0.02),
                horizontal: Responsive.width(context, 0.04),
              ),
            ),
            style: TextStyle(
              fontSize: Responsive.font(context, 0.04),
            ),
          ),
        ),
        SizedBox(width: Responsive.width(context, 0.025)),
        if (onCameraTap != null)
          GestureDetector(
            onTap: onCameraTap,
            child: Container(
              padding: EdgeInsets.all(Responsive.width(context, 0.03)),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.camera_alt,
                color: AppColors.textOnPrimary,
                size: Responsive.width(context, 0.055),
              ),
            ),
          ),
        if (onCameraTap != null)
          SizedBox(width: Responsive.width(context, 0.015)),
        if (onVoiceTap != null)
          GestureDetector(
            onTap: onVoiceTap,
            child: Container(
              padding: EdgeInsets.all(Responsive.width(context, 0.03)),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.mic,
                color: AppColors.textOnPrimary,
                size: Responsive.width(context, 0.055),
              ),
            ),
          ),
        SizedBox(width: Responsive.width(context, 0.015)),
        GestureDetector(
          onTap: onAddIngredient,
          child: Container(
            padding: EdgeInsets.all(Responsive.width(context, 0.03)),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.add,
              color: AppColors.textOnPrimary,
              size: Responsive.width(context, 0.055),
            ),
          ),
        ),
      ],
    );
  }
}
