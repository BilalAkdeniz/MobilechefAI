import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class PreferenceCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color iconColor;
  final List<Map<String, dynamic>> options;
  final String? selectedValue;
  final Function(String?) onSelectionChanged;

  const PreferenceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.options,
    required this.selectedValue,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);
    final childAspectRatio = _getChildAspectRatio(screenWidth);

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
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: Responsive.font(context, 0.06),
                  ),
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.font(context, 0.045),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 0.02)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: Responsive.width(context, 0.02),
              mainAxisSpacing: Responsive.width(context, 0.02),
            ),
            itemCount: options.length,
            itemBuilder: (context, index) =>
                _buildOptionCard(context, options[index]),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1024) return 3;
    if (screenWidth > 768) return 3;
    return 2;
  }

  double _getChildAspectRatio(double screenWidth) {
    if (screenWidth > 1024) return 1.2;
    if (screenWidth > 768) return 1.3;
    return 1.4;
  }

  Widget _buildOptionCard(BuildContext context, Map<String, dynamic> option) {
    final isSelected = selectedValue == option['name'];
    final optionColor = option['color'] as Color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.width(context, 0.01),
        vertical: Responsive.width(context, 0.01),
      ),
      child: GestureDetector(
        onTap: () {
          onSelectionChanged(isSelected ? null : option['name']);
        },
        child: Container(
          padding: EdgeInsets.all(Responsive.width(context, 0.03)),
          decoration: BoxDecoration(
            color: isSelected ? optionColor : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? optionColor : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: optionColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option['icon'],
                style: TextStyle(
                  fontSize: Responsive.font(context, 0.08),
                ),
              ),
              SizedBox(height: Responsive.height(context, 0.01)),
              Flexible(
                child: Text(
                  option['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: Responsive.font(context, 0.03),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
