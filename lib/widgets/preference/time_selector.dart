import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class TimeSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const TimeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final times = [15, 30, 45, 60, 90, 120];
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
                  Icons.timer,
                  color: AppColors.primary,
                  size: Responsive.width(context, 0.06),
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                child: Text(
                  'Mevcut Süreniz',
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
          _buildTimeOptions(context, times, screenWidth),
        ],
      ),
    );
  }

  Widget _buildTimeOptions(
      BuildContext context, List<int> times, double screenWidth) {
    if (screenWidth > 1024) {
      // Desktop: Single row
      return Wrap(
        spacing: Responsive.width(context, 0.015),
        runSpacing: Responsive.height(context, 0.01),
        children: times
            .map((time) => _buildTimeChip(context, time, screenWidth))
            .toList(),
      );
    } else if (screenWidth > 768) {
      // Tablet: Two rows
      return Column(
        children: [
          Wrap(
            spacing: Responsive.width(context, 0.02),
            runSpacing: Responsive.height(context, 0.01),
            alignment: WrapAlignment.center,
            children: times
                .take(3)
                .map((time) => _buildTimeChip(context, time, screenWidth))
                .toList(),
          ),
          SizedBox(height: Responsive.height(context, 0.015)),
          Wrap(
            spacing: Responsive.width(context, 0.02),
            runSpacing: Responsive.height(context, 0.01),
            alignment: WrapAlignment.center,
            children: times
                .skip(3)
                .map((time) => _buildTimeChip(context, time, screenWidth))
                .toList(),
          ),
        ],
      );
    } else {
      // Mobile: Adaptive wrap
      return Wrap(
        spacing: Responsive.width(context, 0.02),
        runSpacing: Responsive.height(context, 0.01),
        alignment: WrapAlignment.center,
        children: times
            .map((time) => _buildTimeChip(context, time, screenWidth))
            .toList(),
      );
    }
  }

  Widget _buildTimeChip(BuildContext context, int time, double screenWidth) {
    final isSelected = selected == time;

    // Responsive chip sizing
    double horizontalPadding;
    double verticalPadding;
    double fontSize;

    if (screenWidth > 1024) {
      horizontalPadding = Responsive.width(context, 0.04);
      verticalPadding = Responsive.height(context, 0.015);
      fontSize = Responsive.font(context, 0.035);
    } else if (screenWidth > 768) {
      horizontalPadding = Responsive.width(context, 0.05);
      verticalPadding = Responsive.height(context, 0.015);
      fontSize = Responsive.font(context, 0.04);
    } else if (screenWidth > 400) {
      horizontalPadding = Responsive.width(context, 0.06);
      verticalPadding = Responsive.height(context, 0.015);
      fontSize = Responsive.font(context, 0.04);
    } else {
      // Very small screens
      horizontalPadding = Responsive.width(context, 0.04);
      verticalPadding = Responsive.height(context, 0.012);
      fontSize = Responsive.font(context, 0.035);
    }

    return GestureDetector(
      onTap: () => onChanged(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$time dk',
          style: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
