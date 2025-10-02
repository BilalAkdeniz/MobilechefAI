import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class SummaryCard extends StatelessWidget {
  final String diet;
  final int peopleCount;
  final String difficulty;
  final int cookingTime;

  const SummaryCard({
    super.key,
    required this.diet,
    required this.peopleCount,
    required this.difficulty,
    required this.cookingTime,
  });

  Widget _buildItem(
      BuildContext context, String label, String value, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 768;

    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: Responsive.height(context, 0.008)),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.info,
            size: Responsive.width(context, isTabletOrDesktop ? 0.04 : 0.05),
          ),
          SizedBox(width: Responsive.width(context, 0.02)),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    '$label: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontSize: Responsive.font(
                          context, isTabletOrDesktop ? 0.032 : 0.04),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                      fontSize: Responsive.font(
                          context, isTabletOrDesktop ? 0.032 : 0.04),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.width(context, 0.04)),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.width(context, 0.02)),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.summarize,
                  color: AppColors.info,
                  size: Responsive.width(context, 0.05),
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.02)),
              Expanded(
                child: Text(
                  'Tercih Özeti',
                  style: TextStyle(
                    fontSize: Responsive.font(
                        context, isTabletOrDesktop ? 0.04 : 0.045),
                    fontWeight: FontWeight.bold,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 0.02)),

          // Responsive layout for summary items
          if (screenWidth > 1024)
            // Desktop: 2x2 grid
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            context, 'Diyet', diet, Icons.restaurant)),
                    Expanded(
                        child: _buildItem(context, 'Kişi Sayısı',
                            '$peopleCount kişi', Icons.people)),
                  ],
                ),
                SizedBox(height: Responsive.height(context, 0.01)),
                Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            context, 'Zorluk', difficulty, Icons.trending_up)),
                    Expanded(
                        child: _buildItem(context, 'Süre',
                            '$cookingTime dakika', Icons.timer)),
                  ],
                ),
              ],
            )
          else if (screenWidth > 600)
            // Tablet: 2x2 grid
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            context, 'Diyet', diet, Icons.restaurant)),
                    Expanded(
                        child: _buildItem(context, 'Kişi', '$peopleCount kişi',
                            Icons.people)),
                  ],
                ),
                SizedBox(height: Responsive.height(context, 0.01)),
                Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            context, 'Zorluk', difficulty, Icons.trending_up)),
                    Expanded(
                        child: _buildItem(
                            context, 'Süre', '$cookingTime dk', Icons.timer)),
                  ],
                ),
              ],
            )
          else
            // Mobile: Vertical list
            Column(
              children: [
                _buildItem(context, 'Diyet', diet, Icons.restaurant),
                _buildItem(
                    context, 'Kişi Sayısı', '$peopleCount kişi', Icons.people),
                _buildItem(context, 'Zorluk', difficulty, Icons.trending_up),
                _buildItem(context, 'Süre', '$cookingTime dakika', Icons.timer),
              ],
            ),
        ],
      ),
    );
  }
}
