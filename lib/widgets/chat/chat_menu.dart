import 'package:flutter/material.dart';
import '../../theme/responsive.dart';

class ChatMenu extends StatelessWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onClearMessages;
  final VoidCallback? onClearAll;

  const ChatMenu({
    super.key,
    this.onLogout,
    this.onClearMessages,
    this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(Responsive.width(context, 0.02)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.tune,
          color: Colors.white,
          size: Responsive.width(context, 0.055),
        ),
      ),
      offset: Offset(
          -Responsive.width(context, 0.1), Responsive.height(context, 0.06)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.2),
      color: Colors.white,
      onSelected: (value) {
        if (value == 'clear_messages') onClearMessages?.call();
        if (value == 'clear_all') onClearAll?.call();
        if (value == 'logout') onLogout?.call();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'clear_messages',
          height: Responsive.height(context, 0.06),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 0.02),
              vertical: Responsive.height(context, 0.005),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.width(context, 0.02)),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.blue.shade600,
                    size: Responsive.width(context, 0.04),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mesajları Temizle',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.035),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        'Sadece sohbet geçmişi',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.028),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'clear_all',
          height: Responsive.height(context, 0.06),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 0.02),
              vertical: Responsive.height(context, 0.005),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.width(context, 0.02)),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.clear_all,
                    color: Colors.orange.shade600,
                    size: Responsive.width(context, 0.04),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Her Şeyi Temizle',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.035),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        'Mesajlar ve malzemeler',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.028),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          height: Responsive.height(context, 0.06),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.width(context, 0.02),
              vertical: Responsive.height(context, 0.005),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(Responsive.width(context, 0.02)),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red.shade600,
                    size: Responsive.width(context, 0.04),
                  ),
                ),
                SizedBox(width: Responsive.width(context, 0.03)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.035),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        'Hesabınızdan çıkın',
                        style: TextStyle(
                          fontSize: Responsive.font(context, 0.028),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
