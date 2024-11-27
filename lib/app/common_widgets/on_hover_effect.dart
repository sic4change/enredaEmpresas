import 'package:flutter/material.dart';

class OnHoverEffect extends StatefulWidget {
  const OnHoverEffect({Key? key, required this.builder}) : super(key: key);
  final Widget Function(bool isHovered) builder;

  @override
  _OnHoverEffectState createState() => _OnHoverEffectState();
}

class _OnHoverEffectState extends State<OnHoverEffect> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => onEntered(true),
        onExit: (event) => onEntered(false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 10000),
          child: widget.builder(isHovered),
        )
    );
  }

  void onEntered(bool isHovered) => setState(() {
    this.isHovered = isHovered;
  });
}
