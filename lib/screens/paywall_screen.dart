import 'package:flutter/material.dart';
import 'package:test_project/models/subscription.dart';
import 'package:test_project/services/subscription_service.dart';
import 'package:test_project/constants/app_constants.dart';
import 'package:test_project/widgets/app_widgets.dart';

class PaywallScreen extends StatefulWidget {
  final SubscriptionService subscriptionService;
  final VoidCallback onPurchaseComplete;

  const PaywallScreen({
    Key? key,
    required this.subscriptionService,
    required this.onPurchaseComplete,
  }) : super(key: key);

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  late List<SubscriptionPlan> plans;
  SubscriptionPlan? selectedPlan;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    plans = [
      SubscriptionPlan(
        id: 'monthly',
        name: AppText.monthlyPlan,
        period: 'month',
        price: 4.99,
        description: AppText.accessMonth,
      ),
      SubscriptionPlan(
        id: 'yearly',
        name: AppText.yearlyPlan,
        period: 'year',
        price: 49.99,
        originalPrice: 59.99,
        description: AppText.accessYear,
      ),
    ];
    selectedPlan = plans[1];
  }

  Future<void> _purchaseSubscription() async {
    if (selectedPlan == null) return;

    setState(() {
      isLoading = true;
    });

    // Имитируем процесс покупки
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      await widget.subscriptionService.purchaseSubscription(selectedPlan!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppText.monthlyPlan} "${selectedPlan!.name}" ${AppText.purchaseSuccess}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        widget.onPurchaseComplete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppText.purchaseError),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingMedium,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppDimens.paddingXLarge),
              const Text(
                AppText.openPremium,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                AppText.premiumAccess,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeMedium,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.paddingXLarge),
              for (var plan in plans)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlan = plan;
                    });
                  },
                  child: _buildPlanCard(plan),
                ),
              const SizedBox(height: AppDimens.paddingXLarge),
              AppButton(
                label: AppText.buttonContinue,
                onPressed: _purchaseSubscription,
                isLoading: isLoading,
              ),
              const SizedBox(height: AppDimens.paddingMedium),
              const Text(
                AppText.autoRenewal,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeSmall,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = selectedPlan?.id == plan.id;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: AppDimens.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.paddingSmall),
                  Text(
                    plan.description,
                    style: const TextStyle(
                      fontSize: AppDimens.fontSizeSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (plan.hasDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingMedium,
                    vertical: AppDimens.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                  ),
                  child: Text(
                    '-${plan.discountPercent}%',
                    style: const TextStyle(
                      fontSize: AppDimens.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Row(
            children: [
              Text(
                '\$${plan.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: AppDimens.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              if (plan.originalPrice != null) ...[
                const SizedBox(width: AppDimens.paddingSmall),
                Text(
                  '\$${plan.originalPrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: AppDimens.fontSizeMedium,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimens.paddingMedium),
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
