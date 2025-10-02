import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class PeopleSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const PeopleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
                  Icons.people,
                  color: AppColors.primary,
                  size: Responsive.width(context, 0.06),
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                child: Text(
                  'Kaç Kişiye Yemek Yapacaksınız?',
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
          _buildPeopleOptions(context, isTabletOrDesktop),
        ],
      ),
    );
  }

  Widget _buildPeopleOptions(BuildContext context, bool isTabletOrDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1024) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            List.generate(6, (index) => _buildPersonButton(context, index + 1)),
      );
    } else if (screenWidth > 768) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                3, (index) => _buildPersonButton(context, index + 1)),
          ),
          SizedBox(height: Responsive.height(context, 0.015)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                3, (index) => _buildPersonButton(context, index + 4)),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                3, (index) => _buildPersonButton(context, index + 1)),
          ),
          SizedBox(height: Responsive.height(context, 0.015)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                3, (index) => _buildPersonButton(context, index + 4)),
          ),
        ],
      );
    }
  }

  Widget _buildPersonButton(BuildContext context, int count) {
    final isSelected = selected == count;
    final screenWidth = MediaQuery.of(context).size.width;
    double buttonSize;
    double fontSize;

    if (screenWidth > 1024) {
      buttonSize = Responsive.width(context, 0.08);
      fontSize = Responsive.font(context, 0.04);
    } else if (screenWidth > 768) {
      buttonSize = Responsive.width(context, 0.12);
      fontSize = Responsive.font(context, 0.045);
    } else {
      buttonSize = Responsive.width(context, 0.15);
      fontSize = Responsive.font(context, 0.05);
    }

    return GestureDetector(
      onTap: () => onChanged(count),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(buttonSize / 2),
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
        child: Center(
          child: Text(
            count.toString(),
            style: TextStyle(
              color:
                  isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
