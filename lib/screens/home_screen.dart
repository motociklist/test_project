import 'package:flutter/material.dart';
import 'package:test_project/services/subscription_service.dart';
import 'package:test_project/constants/app_constants.dart';
import 'package:test_project/widgets/app_widgets.dart';

class HomeScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;

  const HomeScreen({Key? key, required this.subscriptionService})
    : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String subscriptionInfo = '';
  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserAndSubscriptionInfo();
  }

  void _loadUserAndSubscriptionInfo() {
    final user = widget.subscriptionService.getCurrentUser();
    if (user != null) {
      userEmail = user.email;
    }

    final subscription = widget.subscriptionService.getCurrentSubscription();
    if (subscription != null) {
      setState(() {
        subscriptionInfo = '${subscription.planName} (${subscription.period})';
      });
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выход'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await widget.subscriptionService.logoutUser();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  List<Map<String, String>> _getContentItems() {
    return [
      {
        'icon': '✨',
        'title': 'Премиум контент',
        'description': 'Откройте эксклюзивные материалы',
      },
      {
        'icon': '🎯',
        'title': 'Цели и достижения',
        'description': 'Отслеживайте ваш прогресс',
      },
      {
        'icon': '📊',
        'title': 'Статистика',
        'description': 'Просмотрите подробные отчеты',
      },
      {
        'icon': '🌟',
        'title': 'Избранные',
        'description': 'Сохраните любимые элементы',
      },
      {
        'icon': '💡',
        'title': 'Подсказки',
        'description': 'Получайте полезные советы',
      },
      {
        'icon': '🔔',
        'title': 'Уведомления',
        'description': 'Будьте в курсе обновлений',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.homeTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'logout', child: Text('Выход')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimens.radiusXLarge),
                  bottomRight: Radius.circular(AppDimens.radiusXLarge),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '👋 Добро пожаловать!',
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (userEmail.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.paddingSmall),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: AppDimens.fontSizeMedium,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimens.paddingSmall),
                  const Text(
                    AppText.thankYou,
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.paddingMedium),
                  if (subscriptionInfo.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingMedium,
                        vertical: AppDimens.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      child: Text(
                        '${AppText.subscriptionLabel}$subscriptionInfo',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.paddingLarge),
                  const Text(
                    AppText.contentLabel,
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.paddingMedium),
                  for (var item in _getContentItems())
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimens.paddingSmall,
                      ),
                      child: ContentCard(
                        icon: item['icon']!,
                        title: item['title']!,
                        description: item['description']!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
