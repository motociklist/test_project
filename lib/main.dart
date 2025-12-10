import 'package:flutter/material.dart';
import 'package:test_project/screens/home_screen.dart';
import 'package:test_project/screens/onboarding_screen.dart';
import 'package:test_project/screens/paywall_screen.dart';
import 'package:test_project/screens/auth_screen.dart';
import 'package:test_project/services/subscription_service.dart';
import 'package:test_project/widgets/app_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final subscriptionService = SubscriptionService();
  await subscriptionService.initialize();
  runApp(MyApp(subscriptionService: subscriptionService));
}

class MyApp extends StatelessWidget {
  final SubscriptionService subscriptionService;

  const MyApp({super.key, required this.subscriptionService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Подписка Премиум',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _HomeNavigator(subscriptionService: subscriptionService),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _HomeNavigator extends StatefulWidget {
  final SubscriptionService subscriptionService;

  const _HomeNavigator({required this.subscriptionService});

  @override
  State<_HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<_HomeNavigator> {
  late Future<bool> _checkAuthAndSubscriptionFuture;

  @override
  void initState() {
    super.initState();
    _checkAuthAndSubscriptionFuture = _checkAuthAndSubscription();
  }

  Future<bool> _checkAuthAndSubscription() async {
    final isLoggedIn = widget.subscriptionService.isLoggedIn;
    if (!isLoggedIn) {
      return false;
    }
    return await widget.subscriptionService.hasValidSubscription();
  }

  void _refreshState() {
    setState(() {
      _checkAuthAndSubscriptionFuture = _checkAuthAndSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthAndSubscriptionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScaffold();
        }

        if (snapshot.hasError) {
          return ErrorScaffold(error: snapshot.error.toString());
        }

        final isLoggedIn = widget.subscriptionService.isLoggedIn;

        // Если не залогинен, показываем экран авторизации
        if (!isLoggedIn) {
          return AuthScreen(
            subscriptionService: widget.subscriptionService,
            onAuthSuccess: _refreshState,
          );
        }

        final hasSubscription = snapshot.data ?? false;

        // Если залогинен и есть подписка, показываем главный экран
        if (hasSubscription) {
          return HomeScreen(subscriptionService: widget.subscriptionService);
        }

        // Если залогинен, но нет подписки, показываем поток онбординга и paywall
        return _SubscriptionFlow(
          subscriptionService: widget.subscriptionService,
          onStateChanged: _refreshState,
        );
      },
    );
  }
}

class _SubscriptionFlow extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final VoidCallback onStateChanged;

  const _SubscriptionFlow({
    required this.subscriptionService,
    required this.onStateChanged,
  });

  @override
  State<_SubscriptionFlow> createState() => _SubscriptionFlowState();
}

class _SubscriptionFlowState extends State<_SubscriptionFlow> {
  int _currentScreen = 0; // 0: Onboarding, 1: Paywall

  void _goToPaywall() {
    setState(() {
      _currentScreen = 1;
    });
  }

  void _handlePurchaseComplete() {
    widget.onStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 0:
        return OnboardingScreen(onContinue: _goToPaywall);
      case 1:
        return PaywallScreen(
          subscriptionService: widget.subscriptionService,
          onPurchaseComplete: _handlePurchaseComplete,
        );
      default:
        return OnboardingScreen(onContinue: _goToPaywall);
    }
  }
}
