import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/chat_viewmodel.dart';
import '../../theme/responsive.dart';

class IngredientChipList extends StatelessWidget {
  const IngredientChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, vm, child) {
        if (vm.ingredients.isEmpty) return const SizedBox.shrink();
        return Wrap(
          spacing: Responsive.width(context, 0.02),
          runSpacing: Responsive.height(context, 0.01),
          children: vm.ingredients.map((ingredient) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: Responsive.width(context, 0.005),
                vertical: Responsive.height(context, 0.003),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade200,
                    Colors.orange.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade300.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.width(context, 0.03),
                      vertical: Responsive.height(context, 0.008),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ingredient,
                          style: TextStyle(
                            fontSize: Responsive.font(context, 0.032),
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        SizedBox(width: Responsive.width(context, 0.015)),
                        GestureDetector(
                          onTap: () => vm.removeIngredient(ingredient),
                          child: Container(
                            padding:
                                EdgeInsets.all(Responsive.width(context, 0.01)),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: Responsive.width(context, 0.03),
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
