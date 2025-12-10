import 'package:flutter/material.dart';
import 'package:test_project/constants/app_constants.dart';
import 'package:test_project/widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const OnboardingScreen({Key? key, required this.onContinue})
    : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: AppDurations.pageTransition,
        curve: Curves.easeInOut,
      );
    } else {
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildPage(
            title: AppText.welcomeTitle,
            description: AppText.welcomeDesc,
            icon: '🌟',
          ),
          _buildPage(
            title: AppText.premiumTitle,
            description: AppText.premiumDesc,
            icon: '✨',
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageIndicator(totalPages: 2, currentPage: _currentPage),
            const SizedBox(height: AppDimens.paddingXLarge),
            AppButton(
              label: _currentPage == 0
                  ? AppText.buttonNext
                  : AppText.buttonContinue,
              onPressed: _nextPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String icon,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: AppDimens.paddingXLarge),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDimens.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingLarge,
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: AppDimens.fontSizeMedium,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
