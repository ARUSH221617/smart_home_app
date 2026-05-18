import 'package:flutter/material.dart';
import 'package:smart_home_app/generated/locale_keys.g.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

enum MainTab {
  dashboard(MingCuteIcons.mgc_home_4_fill, LocaleKeys.menuHero),
  setting(MingCuteIcons.mgc_user_3_fill, LocaleKeys.menuSetting);

  const MainTab(this.iconData, this.labelKey);

  final IconData iconData;
  final String labelKey;
}
