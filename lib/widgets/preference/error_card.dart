import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const ErrorCard({super.key, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.width(context, 0.04)),
      margin: EdgeInsets.only(bottom: Responsive.height(context, 0.025)),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: Responsive.width(context, isTabletOrDesktop ? 0.05 : 0.06),
          ),
          SizedBox(width: Responsive.width(context, 0.03)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: Responsive.height(context, 0.002),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                  fontSize: Responsive.font(
                      context, isTabletOrDesktop ? 0.035 : 0.04),
                  height: 1.4,
                ),
              ),
            ),
          ),
          SizedBox(width: Responsive.width(context, 0.02)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(Responsive.width(context, 0.02)),
                child: Icon(
                  Icons.close,
                  color: AppColors.error,
                  size: Responsive.width(
                      context, isTabletOrDesktop ? 0.04 : 0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
