import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/providers/app_theme_mode_provider.dart';
import 'providers/smart_home_power_provider.dart';

class SmartDashboardScreen extends ConsumerWidget {
  const SmartDashboardScreen({super.key});

  String _getGreeting() {
    final currentHour = DateTime.now().hour;
    if (currentHour >= 5 && currentHour < 12) return LocaleKeys.goodMorning;
    if (currentHour >= 12 && currentHour < 18) return LocaleKeys.goodAfternoon;
    return LocaleKeys.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider).value;
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDarkMode);
    final isSmartHomeOn = ref.watch(smartHomePowerProvider);

    return Scaffold(
      backgroundColor: context.secondaryBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 55,
        leading: Container(
          margin: EdgeInsets.only(left: 16, right: 8),
          child: Image.asset('assets/images/logo.png', width: 32, height: 32),
        ),
        title: Text(
          context.tr(LocaleKeys.smartDashboardTitle),
          style: AppTheme.title32,
        ),
        actions: [
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: context.secondaryWidgetColor,
              foregroundColor: context.primaryTextColor,
            ),
            onPressed: () {
              final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              ref.read(appThemeModeProvider.notifier).updateMode(nextMode);
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 16),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: context.secondaryBackgroundColor,
        foregroundColor: context.primaryTextColor,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
        children: [
          Text(
            context.tr(_getGreeting()),
            style: AppTheme.title24.copyWith(color: context.primaryTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(LocaleKeys.smartDashboardDescription),
            style: AppTheme.body16.copyWith(color: context.secondaryTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(
              isSmartHomeOn ? LocaleKeys.smartHomeOn : LocaleKeys.smartHomeOff,
            ),
            style: AppTheme.subtitle16.copyWith(
              color: isSmartHomeOn
                  ? AppColors.watermelon100
                  : context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.92,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _DashboardCard(
                title: context.tr(LocaleKeys.lights),
                icon: Icons.lightbulb_outline,
                accentColor: AppColors.cempedak100,
                isAvailable: true,
              ),
              _DashboardCard(
                title: context.tr(LocaleKeys.tv),
                icon: Icons.tv_outlined,
                accentColor: AppColors.blueberry100,
              ),
              _DashboardCard(
                title: context.tr(LocaleKeys.cooler),
                icon: Icons.ac_unit,
                accentColor: AppColors.watermelon100,
              ),
              _DashboardCard(
                title: context.tr(LocaleKeys.airConditioning),
                icon: Icons.air,
                accentColor: AppColors.rambutan100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    this.isAvailable = false,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: isAvailable
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LightsScreen(),
                ),
              );
            }
          : null,
      child: Ink(
        decoration: BoxDecoration(
          color: context.secondaryWidgetColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isAvailable
                ? accentColor.withValues(alpha: 0.35)
                : context.dividerColor,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gradient10,
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: accentColor, size: 34),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: AppTheme.title18.copyWith(
                        color: context.primaryTextColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(
                      isAvailable
                          ? LocaleKeys.availableNow
                          : LocaleKeys.comingSoon,
                    ),
                    style: AppTheme.body12.copyWith(
                        color: context.secondaryTextColor,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            if (!isAvailable)
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mono100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.tr(LocaleKeys.soon),
                    style: AppTheme.title10.copyWith(color: AppColors.mono0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LightsScreen extends ConsumerWidget {
  const LightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightOn = ref.watch(smartHomePowerProvider);
    return Scaffold(
      backgroundColor: context.secondaryBackgroundColor,
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.lights)),
        backgroundColor: context.secondaryBackgroundColor,
        foregroundColor: context.primaryTextColor,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: isLightOn
                    ? AppColors.cempedak100.withValues(alpha: 0.22)
                    : context.secondaryWidgetColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                color: isLightOn ? AppColors.cempedak100 : AppColors.mono60,
                size: 84,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.tr(
                isLightOn ? LocaleKeys.lightsOn : LocaleKeys.lightsOff,
              ),
              style: AppTheme.title24.copyWith(color: context.primaryTextColor),
            ),
            const SizedBox(height: 16),
            Switch.adaptive(
              value: isLightOn,
              activeThumbColor: AppColors.cempedak100,
              onChanged: (value) {
                ref.read(smartHomePowerProvider.notifier).state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
