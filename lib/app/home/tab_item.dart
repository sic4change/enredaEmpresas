import 'package:enreda_empresas/app/common_widgets/custom_icons.dart';
import 'package:enreda_empresas/app/values/strings.dart';
import 'package:flutter/material.dart';

enum TabItem {resources, competencies, chat, account}

class TabItemData {
  const TabItemData({required this.title, required this.icon});

  final String title;
  final IconData icon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.resources: const TabItemData(title: StringConst.RESOURCES, icon: CustomIcons.recursos),
    TabItem.competencies: const TabItemData(title: StringConst.COMPETENCIES, icon: CustomIcons.comp),
    TabItem.chat: const TabItemData(title: 'Chat', icon: CustomIcons.chat),
    TabItem.account: const TabItemData(title: 'Cuenta', icon: CustomIcons.cuenta)
  };
}