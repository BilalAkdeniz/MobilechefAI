import 'package:flutter/material.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../theme/app_colors.dart';

class LoginEmailField extends StatelessWidget {
  final LoginViewModel viewModel;
  const LoginEmailField({super.key, required this.viewModel});

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
        controller: viewModel.emailController,
        enabled: !viewModel.isLoading,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'E-posta',
          hintText: 'ornek@email.com',
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.email_outlined,
                color: AppColors.secondary, size: 20),
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
            return 'E-posta adresi gerekli';
          }
          if (!value.contains('@')) {
            return 'Geçerli bir e-posta adresi girin';
          }
          return null;
        },
      ),
    );
  }
}
