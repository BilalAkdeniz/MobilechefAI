import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class DifficultySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const DifficultySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final difficulties = [
      {'name': 'Kolay', 'icon': '😊', 'color': AppColors.success},
      {'name': 'Orta', 'icon': '😐', 'color': AppColors.warning},
      {'name': 'Zor', 'icon': '😤', 'color': AppColors.error},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 768;

    return Container(
      padding: EdgeInsets.all(Responsive.width(context, 0.04)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.width(context, 0.03)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: Responsive.width(context, 0.06),
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                child: Text(
                  'Zorluk Seviyesi',
                  style: TextStyle(
                    fontSize: Responsive.font(
                        context, isTabletOrDesktop ? 0.035 : 0.045),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 0.025)),
          _buildDifficultyOptions(context, difficulties, isTabletOrDesktop),
        ],
      ),
    );
  }

  Widget _buildDifficultyOptions(BuildContext context,
      List<Map<String, dynamic>> difficulties, bool isTabletOrDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1024) {
      return Row(
        children: difficulties
            .map(
              (diff) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.width(context, 0.01)),
                  child: _buildDifficultyCard(context, diff, isTabletOrDesktop),
                ),
              ),
            )
            .toList(),
      );
    } else if (screenWidth > 600) {
      return Row(
        children: difficulties
            .map(
              (diff) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Responsive.width(context, 0.01)),
                  child: _buildDifficultyCard(context, diff, isTabletOrDesktop),
                ),
              ),
            )
            .toList(),
      );
    } else {
      return screenWidth < 400
          ? Column(
              children: difficulties
                  .map(
                    (diff) => Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Responsive.height(context, 0.005)),
                      child: _buildDifficultyCard(
                          context, diff, isTabletOrDesktop),
                    ),
                  )
                  .toList(),
            )
          : Row(
              children: difficulties
                  .map(
                    (diff) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.width(context, 0.01)),
                        child: _buildDifficultyCard(
                            context, diff, isTabletOrDesktop),
                      ),
                    ),
                  )
                  .toList(),
            );
    }
  }

  Widget _buildDifficultyCard(
      BuildContext context, Map<String, dynamic> diff, bool isTabletOrDesktop) {
    final isSelected = selected == diff['name'];
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onChanged(diff['name'] as String),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: Responsive.height(context, 0.02),
          horizontal: Responsive.width(context, 0.02),
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? (diff['color'] as Color) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? (diff['color'] as Color) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (diff['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              diff['icon'] as String,
              style: TextStyle(
                fontSize:
                    Responsive.font(context, isTabletOrDesktop ? 0.06 : 0.07),
              ),
            ),
            SizedBox(height: Responsive.height(context, 0.01)),
            Text(
              diff['name'] as String,
              style: TextStyle(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize:
                    Responsive.font(context, isTabletOrDesktop ? 0.03 : 0.035),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
