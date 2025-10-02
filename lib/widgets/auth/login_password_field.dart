import 'package:flutter/material.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../theme/app_colors.dart';

class LoginPasswordField extends StatelessWidget {
  final LoginViewModel viewModel;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSubmit;

  const LoginPasswordField({
    super.key,
    required this.viewModel,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: viewModel.passwordController,
        enabled: !viewModel.isLoading,
        obscureText: !isPasswordVisible,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => onSubmit(),
        decoration: InputDecoration(
          labelText: 'Şifre',
          hintText: 'En az 6 karakter',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock_outline,
                color: AppColors.secondary, size: 20),
          ),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Şifre gerekli';
          }
          if (value.length < 6) {
            return 'Şifre en az 6 karakter olmalı';
          }
          return null;
        },
      ),
    );
  }
}
