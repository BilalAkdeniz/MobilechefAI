import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isError;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.isError = false,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleStyle = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          );

    final avatar = CircleAvatar(
      radius: Responsive.width(context, 0.04),
      backgroundColor: isError
          ? AppColors.errorLight
          : isUser
              ? AppColors.successLight
              : AppColors.infoLight,
      child: Icon(
        isError
            ? Icons.error
            : isUser
                ? Icons.person
                : Icons.smart_toy,
        size: Responsive.width(context, 0.035),
        color: isError
            ? AppColors.error
            : isUser
                ? AppColors.success
                : AppColors.info,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: Responsive.height(context, 0.005)),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            avatar,
            SizedBox(width: Responsive.width(context, 0.02)),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 0.04),
                vertical: Responsive.height(context, 0.015),
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary
                    : isError
                        ? AppColors.errorLight
                        : AppColors.surface,
                borderRadius: bubbleStyle,
                border: !isUser
                    ? Border.all(
                        color: isError ? AppColors.error : Colors.grey.shade200,
                      )
                    : null,
                boxShadow: [
                  if (!isError)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isUser
                          ? AppColors.textOnPrimary
                          : isError
                              ? AppColors.error
                              : AppColors.textPrimary,
                      fontSize: Responsive.font(context, 0.04),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: Responsive.height(context, 0.003)),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      color: isUser
                          ? AppColors.textOnPrimary.withOpacity(0.7)
                          : AppColors.textSecondary,
                      fontSize: Responsive.font(context, 0.03),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: Responsive.width(context, 0.02)),
            avatar,
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
