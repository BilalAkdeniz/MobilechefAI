import 'package:flutter/material.dart';
import '../../theme/responsive.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Responsive.width(context, 0.04)),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: Responsive.width(context, 0.9),
          ),
          margin: EdgeInsets.symmetric(
            vertical: Responsive.height(context, 0.02),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange.shade300,
                Colors.deepOrange.shade500,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.shade200.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: Responsive.width(context, 0.18),
                color: Colors.white,
              ),
              SizedBox(height: Responsive.height(context, 0.01)),
              Text(
                '🍳 MobileChef\'e Hoş Geldiniz!',
                style: TextStyle(
                  fontSize: Responsive.font(context, 0.05),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.height(context, 0.005)),
              Text(
                'Malzemelerinizi ekleyin, size özel tarifler oluşturalım!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.font(context, 0.04),
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
