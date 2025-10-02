import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class SpeechStatusIndicator extends StatelessWidget {
  const SpeechStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, child) {
        if (!vm.isListening) return const SizedBox.shrink();
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 0.04),
            vertical: Responsive.height(context, 0.01),
          ),
          padding: EdgeInsets.all(Responsive.width(context, 0.04)),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 600),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Icon(
                      Icons.mic,
                      color: AppColors.error,
                      size: Responsive.width(context, 0.06),
                    ),
                  );
                },
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎤 Dinleniyor...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                        fontSize: Responsive.font(context, 0.04),
                      ),
                    ),
                    SizedBox(height: Responsive.height(context, 0.005)),
                    Text(
                      'Malzeme adını söyleyin (örn: "domates ekle")',
                      style: TextStyle(
                        color: AppColors.error.withOpacity(0.8),
                        fontSize: Responsive.font(context, 0.035),
                      ),
                    ),
                    if (vm.currentSpeechText.isNotEmpty) ...[
                      SizedBox(height: Responsive.height(context, 0.01)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.width(context, 0.02),
                          vertical: Responsive.height(context, 0.005),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"${vm.currentSpeechText}"',
                          style: TextStyle(
                            color: AppColors.error,
                            fontStyle: FontStyle.italic,
                            fontSize: Responsive.font(context, 0.035),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: vm.stopListening,
                icon: Icon(
                  Icons.stop,
                  color: AppColors.error,
                  size: Responsive.width(context, 0.06),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
