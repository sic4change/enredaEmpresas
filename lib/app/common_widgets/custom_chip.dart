import 'dart:ui';

import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool selected) onSelect;
  final double borderRadius;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color textColor;

  const CustomChip({
    Key? key,
    required this.label,
    this.selected = false,
    required this.onSelect,
    this.borderRadius = 20,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.selectedBackgroundColor = const Color(0xFF486581),
    this.textColor = const Color(0xFF486581),

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: selected ? (selectedBackgroundColor) : backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(
            color: textColor,
            width: selected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                label,
                softWrap: true,
                style: TextStyle(
                  color: selected ? AppColors.greyChip : textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => onSelect(!selected),
    );
  }
}
