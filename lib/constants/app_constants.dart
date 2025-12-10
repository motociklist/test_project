import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.deepPurple;
  static const Color accent = Colors.amber;
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
}

class AppDimens {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 40.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  static const double buttonHeight = 50.0;
  static const double dotSize = 8.0;
  static const double dotSpacing = 4.0;

  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 28.0;
}

class AppDurations {
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(milliseconds: 1500);
}

class AppText {
  static const String appTitle = 'Подписка Премиум';
  static const String loading = 'Загрузка...';
  static const String welcomeTitle = 'Добро пожаловать!';
  static const String welcomeDesc =
      'Откройте мир новых возможностей вместе с нашим приложением';
  static const String premiumTitle = 'Премиум контент';
  static const String premiumDesc =
      'Получите доступ к эксклюзивному контенту и функциям';
  static const String openPremium = '✨ Откройте Премиум';
  static const String premiumAccess =
      'Получите полный доступ ко всем функциям приложения';
  static const String monthlyPlan = 'Месячная подписка';
  static const String yearlyPlan = 'Годовая подписка';
  static const String accessMonth = 'Доступ на 1 месяц';
  static const String accessYear = 'Доступ на 1 год (сэкономьте 17%)';
  static const String buttonNext = 'Далее';
  static const String buttonContinue = 'Продолжить';
  static const String autoRenewal = 'Подписка автоматически возобновится';
  static const String purchaseSuccess = 'активирована!';
  static const String purchaseError = 'Ошибка при покупке';
  static const String homeTitle = 'Главный экран';
  static const String thankYou = 'Спасибо за подписку';
  static const String contentLabel = '📚 Контент';
  static const String subscriptionLabel = 'Подписка: ';
}
