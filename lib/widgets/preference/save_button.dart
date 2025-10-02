import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final bool showSuccess;

  const SaveButton({
    super.key,
    required this.isLoading,
    required this.onSave,
    this.showSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 768;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSaveButton(context, isTabletOrDesktop),
          if (showSuccess) ...[
            SizedBox(height: Responsive.height(context, 0.02)),
            _buildSuccessMessage(context, isTabletOrDesktop),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isTabletOrDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive button sizing
    double buttonWidth;
    double buttonHeight;
    double fontSize;

    if (screenWidth > 1024) {
      buttonWidth = Responsive.width(context, 0.25);
      buttonHeight = Responsive.height(context, 0.06);
      fontSize = Responsive.font(context, 0.04);
    } else if (screenWidth > 768) {
      buttonWidth = Responsive.width(context, 0.4);
      buttonHeight = Responsive.height(context, 0.065);
      fontSize = Responsive.font(context, 0.04);
    } else {
      buttonWidth = Responsive.width(context, 0.8);
      buttonHeight = Responsive.height(context, 0.07);
      fontSize = Responsive.font(context, 0.045);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          disabledForegroundColor: AppColors.textOnPrimary.withOpacity(0.8),
          elevation: isLoading ? 0 : 8,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.width(context, 0.06),
            vertical: Responsive.height(context, 0.015),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? Row(
                  key: const ValueKey('loading'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: fontSize * 0.8,
                      height: fontSize * 0.8,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.width(context, 0.02)),
                    Text(
                      "Kaydediliyor...",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                )
              : Row(
                  key: const ValueKey('save'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.save,
                      size: fontSize,
                    ),
                    SizedBox(width: Responsive.width(context, 0.02)),
                    Text(
                      "Kaydet ve Devam Et",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context, bool isTabletOrDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 0.04),
        vertical: Responsive.height(context, 0.01),
      ),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: Responsive.width(context, isTabletOrDesktop ? 0.04 : 0.05),
          ),
          SizedBox(width: Responsive.width(context, 0.02)),
          Flexible(
            child: Text(
              'Tercihler başarıyla kaydedildi!',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize:
                    Responsive.font(context, isTabletOrDesktop ? 0.032 : 0.04),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
