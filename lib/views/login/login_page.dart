import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../widgets/auth/login_email_field.dart';
import '../../widgets/auth/login_password_field.dart';
import '../../widgets/auth/login_submit_button.dart';
import '../../widgets/auth/login_google_button.dart';
import '../../theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Future<void> _submit(LoginViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    await vm.submit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Icon(Icons.restaurant_menu,
                          size: 80, color: AppColors.secondary),
                      const SizedBox(height: 24),
                      Text(
                        vm.isLoginMode ? "Giriş Yap" : "Kayıt Ol",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      LoginEmailField(viewModel: vm),
                      const SizedBox(height: 16),
                      LoginPasswordField(
                        viewModel: vm,
                        isPasswordVisible: _isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onSubmit: () => _submit(vm),
                      ),
                      const SizedBox(height: 24),
                      LoginSubmitButton(
                        viewModel: vm,
                        onSubmit: () => _submit(vm),
                      ),
                      const SizedBox(height: 16),
                      LoginGoogleButton(viewModel: vm),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: vm.toggleMode,
                        child: Text(
                          vm.isLoginMode
                              ? "Hesabınız yok mu? Kayıt Olun"
                              : "Zaten hesabınız var mı? Giriş Yapın",
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
