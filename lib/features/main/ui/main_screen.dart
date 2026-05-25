import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../common/ui/widgets/material_ink_well.dart';
import '../../smart_dashboard/ui/providers/smart_home_power_provider.dart';
import '../../smart_dashboard/ui/smart_dashboard_screen.dart';
import '../../profile/ui/profile_screen.dart';
import '../model/main_tab.dart';

const List<Widget> _screens = [
  SmartDashboardScreen(),
  ProfileScreen(),
];

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isSmartHomeOn = ref.watch(smartHomePowerProvider);

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTabIndex,
            children: _screens,
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: context.secondaryWidgetColor,
                      borderRadius: const BorderRadius.all(Radius.circular(48)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        spacing: 8,
                        children: MainTab.values
                            .map((tab) => _buildNavItem(tab))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: isSmartHomeOn
                        ? AppColors.watermelon100
                        : context.secondaryWidgetColor,
                    borderRadius: const BorderRadius.all(Radius.circular(48)),
                  ),
                  child: MaterialInkWell(
                    radius: 48,
                    onTap: () {
                      ref.read(smartHomePowerProvider.notifier).state =
                          !isSmartHomeOn;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Icon(
                        Icons.power_settings_new,
                        color:
                            isSmartHomeOn ? AppColors.mono0 : AppColors.mono100,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(MainTab tab) {
    final isSelected = _currentTabIndex == tab.index;
    return Expanded(
      child: MaterialInkWell(
        radius: 24,
        onTap: () {
          setState(() {
            _currentTabIndex = tab.index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? context.secondaryBackgroundColor : null,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            children: [
              Icon(
                tab.iconData,
                color: isSelected ? AppColors.blueberry100 : null,
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(tab.labelKey),
                style: AppTheme.body12.copyWith(
                  color: isSelected ? AppColors.blueberry100 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
