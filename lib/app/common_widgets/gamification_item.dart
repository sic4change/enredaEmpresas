import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/spaces.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class GamificationItem extends StatelessWidget {
  const GamificationItem({
    super.key,
    this.size = 80,
    this.progress = 0,
    this.progressText,
    this.imageSize = 60,
    required this.imagePath,
    required this.title,
  });

  final double size, imageSize, progress;
  final String imagePath, title;
  final String? progressText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircularSeekBar(
          height: Responsive.isMobile(context) || Responsive.isDesktopS(context) ? size * 0.7 : size * 1.5,
          width: Responsive.isMobile(context) || Responsive.isDesktopS(context) ? size * 0.7 : size * 1.5,
          startAngle: 45,
          sweepAngle: 270,
          progress: progress,
          barWidth: !Responsive.isDesktop(context)? 6 : 12,
          progressColor: AppColors.primary900,
          innerThumbStrokeWidth: !Responsive.isDesktop(context)?5: 10,
          innerThumbColor: AppColors.darkYellow,
          outerThumbColor: Colors.transparent,
          trackColor: AppColors.primary100,
          strokeCap: StrokeCap.round,
          animation: true,
          animDurationMillis: 1500,
          interactive: false,
          child: Padding(
            padding: EdgeInsets.only(top: !Responsive.isDesktop(context)? 4.0 : 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextBoldTitle(title: progress.toString()),
                    CustomTextBoldTitle(title: '%')
                  ],
                ),
                Container(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.turquoiseBlue,
                      fontSize: Responsive.isMobile(context) || Responsive.isDesktopS(context) ? textTheme.bodySmall!.fontSize!/1.2:textTheme.bodySmall!.fontSize!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}