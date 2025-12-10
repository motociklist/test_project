import 'package:flutter/material.dart';
import 'package:test_project/services/subscription_service.dart';
import 'package:test_project/constants/app_constants.dart';
import 'package:test_project/widgets/app_widgets.dart';

class AuthScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final VoidCallback onAuthSuccess;

  const AuthScreen({
    Key? key,
    required this.subscriptionService,
    required this.onAuthSuccess,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;
  bool _isLoading = false;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Заполните все поля');
      }

      if (!email.contains('@')) {
        throw Exception('Введите корректный email');
      }

      bool success;
      if (_isLogin) {
        success = await widget.subscriptionService.loginUser(email, password);
        if (!success) {
          throw Exception('Неверный email или пароль');
        }
      } else {
        final confirmPassword = _confirmPasswordController.text;
        if (password != confirmPassword) {
          throw Exception('Пароли не совпадают');
        }
        if (password.length < 6) {
          throw Exception('Пароль должен быть не менее 6 символов');
        }
        success = await widget.subscriptionService.registerUser(
          email,
          password,
        );
        if (!success) {
          throw Exception('Пользователь с таким email уже существует');
        }
      }

      if (mounted) {
        widget.onAuthSuccess();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimens.paddingXLarge),
              Text(
                _isLogin ? 'Вход' : 'Регистрация',
                style: const TextStyle(
                  fontSize: AppDimens.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              Text(
                _isLogin ? 'Войдите в свой аккаунт' : 'Создайте новый аккаунт',
                style: const TextStyle(
                  fontSize: AppDimens.fontSizeMedium,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.paddingXLarge),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingMedium),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: AppDimens.fontSizeMedium,
                    ),
                  ),
                ),
              if (_errorMessage != null)
                const SizedBox(height: AppDimens.paddingMedium),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
              ),
              if (!_isLogin) ...[
                const SizedBox(height: AppDimens.paddingMedium),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Подтверждение пароля',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusMedium,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.paddingXLarge),
              AppButton(
                label: _isLogin ? 'Войти' : 'Зарегистрироваться',
                onPressed: _handleAuth,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin ? 'Нет аккаунта? ' : 'Уже есть аккаунт? ',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _errorMessage = null;
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      });
                    },
                    child: Text(
                      _isLogin ? 'Зарегистрируйтесь' : 'Войдите',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.paddingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
