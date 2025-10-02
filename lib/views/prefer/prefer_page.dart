import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/prefer_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../widgets/common/page_header.dart';
import '../../widgets/preference/preference_card.dart';
import '../../widgets/preference/people_selector.dart';
import '../../widgets/preference/difficulty_selector.dart';
import '../../widgets/preference/time_selector.dart';
import '../../widgets/preference/error_card.dart';
import '../../widgets/preference/summary_card.dart';
import '../../widgets/preference/save_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive.dart';

class PreferPage extends StatefulWidget {
  const PreferPage({super.key});

  @override
  State<PreferPage> createState() => _PreferPageState();
}

class _PreferPageState extends State<PreferPage> {
  bool _preferencesLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserPreferences());
  }

  void _loadUserPreferences() async {
    final loginVm = context.read<LoginViewModel>();
    final preferVm = context.read<PreferViewModel>();
    if (loginVm.currentUser != null) {
      await preferVm.loadPreferences(loginVm.currentUser!.uid);
    }
    if (mounted) setState(() => _preferencesLoaded = true);
  }

  Future<void> _handleSavePreferences(
      PreferViewModel preferVm, LoginViewModel loginVm) async {
    if (loginVm.currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen önce giriş yapın.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }
    final success = await preferVm.savePreferences(loginVm.currentUser!.uid);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.textOnPrimary),
              SizedBox(width: 12),
              Text("Tercihler başarıyla kaydedildi!",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              title: 'MobileChef',
              subtitle: 'Size özel tarifler için tercihlerinizi seçin',
              icon: Icons.restaurant_menu,
            ),
            Expanded(
              child: Consumer2<PreferViewModel, LoginViewModel>(
                builder: (context, preferVm, loginVm, child) {
                  if (!_preferencesLoaded || preferVm.isLoading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(Responsive.width(context, 0.04)),
                    child: isDesktop
                        ? _buildDesktopLayout(preferVm, loginVm)
                        : isTablet
                            ? _buildTabletLayout(preferVm, loginVm)
                            : _buildMobileLayout(preferVm, loginVm),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(PreferViewModel preferVm, LoginViewModel loginVm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preferVm.state == PreferenceState.error)
          ErrorCard(
            message: preferVm.errorMessage,
            onClose: preferVm.clearError,
          ),
        _buildDietSection(preferVm),
        SizedBox(height: Responsive.height(context, 0.025)),
        PeopleSelector(
          selected: preferVm.peopleCount,
          onChanged: preferVm.setPeopleCount,
        ),
        SizedBox(height: Responsive.height(context, 0.025)),
        DifficultySelector(
          selected: preferVm.difficulty,
          onChanged: preferVm.setDifficulty,
        ),
        SizedBox(height: Responsive.height(context, 0.025)),
        TimeSelector(
          selected: preferVm.cookingTime,
          onChanged: preferVm.setCookingTime,
        ),
        SizedBox(height: Responsive.height(context, 0.04)),
        SummaryCard(
          diet: preferVm.diet,
          peopleCount: preferVm.peopleCount,
          difficulty: preferVm.difficulty,
          cookingTime: preferVm.cookingTime,
        ),
        SizedBox(height: Responsive.height(context, 0.04)),
        SaveButton(
          isLoading: preferVm.isLoading,
          onSave: () => _handleSavePreferences(preferVm, loginVm),
          showSuccess: preferVm.state == PreferenceState.success,
        ),
        SizedBox(height: Responsive.height(context, 0.025)),
      ],
    );
  }

  Widget _buildTabletLayout(PreferViewModel preferVm, LoginViewModel loginVm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (preferVm.state == PreferenceState.error)
          ErrorCard(
            message: preferVm.errorMessage,
            onClose: preferVm.clearError,
          ),
        _buildDietSection(preferVm),
        SizedBox(height: Responsive.height(context, 0.03)),
        Row(
          children: [
            Expanded(
              child: PeopleSelector(
                selected: preferVm.peopleCount,
                onChanged: preferVm.setPeopleCount,
              ),
            ),
            SizedBox(width: Responsive.width(context, 0.03)),
            Expanded(
              child: DifficultySelector(
                selected: preferVm.difficulty,
                onChanged: preferVm.setDifficulty,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.height(context, 0.03)),
        TimeSelector(
          selected: preferVm.cookingTime,
          onChanged: preferVm.setCookingTime,
        ),
        SizedBox(height: Responsive.height(context, 0.04)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SummaryCard(
                diet: preferVm.diet,
                peopleCount: preferVm.peopleCount,
                difficulty: preferVm.difficulty,
                cookingTime: preferVm.cookingTime,
              ),
            ),
            SizedBox(width: Responsive.width(context, 0.03)),
            Expanded(
              child: SaveButton(
                isLoading: preferVm.isLoading,
                onSave: () => _handleSavePreferences(preferVm, loginVm),
                showSuccess: preferVm.state == PreferenceState.success,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.height(context, 0.025)),
      ],
    );
  }

  Widget _buildDesktopLayout(PreferViewModel preferVm, LoginViewModel loginVm) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (preferVm.state == PreferenceState.error)
            ErrorCard(
              message: preferVm.errorMessage,
              onClose: preferVm.clearError,
            ),
          _buildDietSection(preferVm),
          SizedBox(height: Responsive.height(context, 0.04)),
          Row(
            children: [
              Expanded(
                child: PeopleSelector(
                  selected: preferVm.peopleCount,
                  onChanged: preferVm.setPeopleCount,
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.02)),
              Expanded(
                child: DifficultySelector(
                  selected: preferVm.difficulty,
                  onChanged: preferVm.setDifficulty,
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.02)),
              Expanded(
                child: TimeSelector(
                  selected: preferVm.cookingTime,
                  onChanged: preferVm.setCookingTime,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 0.04)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SummaryCard(
                  diet: preferVm.diet,
                  peopleCount: preferVm.peopleCount,
                  difficulty: preferVm.difficulty,
                  cookingTime: preferVm.cookingTime,
                ),
              ),
              SizedBox(width: Responsive.width(context, 0.03)),
              Expanded(
                flex: 2,
                child: SaveButton(
                  isLoading: preferVm.isLoading,
                  onSave: () => _handleSavePreferences(preferVm, loginVm),
                  showSuccess: preferVm.state == PreferenceState.success,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.height(context, 0.025)),
        ],
      ),
    );
  }

  Widget _buildDietSection(PreferViewModel preferVm) {
    return PreferenceCard(
      title: "Diyet Seçimi",
      icon: "🍴",
      iconColor: AppColors.primary,
      options: [
        {'name': 'Vegan', 'icon': '🌱', 'color': AppColors.success},
        {'name': 'Vejetaryen', 'icon': '🥗', 'color': AppColors.success},
        {'name': 'Pesketaryen', 'icon': '🐟', 'color': AppColors.info},
        {'name': 'Ketojenik', 'icon': '🥑', 'color': AppColors.primary},
        {'name': 'Glutensiz', 'icon': '🌾', 'color': AppColors.warning},
        {'name': 'Farketmez', 'icon': '🍽️', 'color': AppColors.textSecondary},
      ],
      selectedValue: preferVm.diet,
      onSelectionChanged: (value) => preferVm.setDiet(value ?? 'Farketmez'),
    );
  }
}
