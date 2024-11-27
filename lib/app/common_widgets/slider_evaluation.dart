import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class SliderEvaluation extends StatefulWidget {
  const SliderEvaluation({super.key, required this.weight});

  final double weight;
  @override
  State<SliderEvaluation> createState() => _SliderEvaluationState();
}

class _SliderEvaluationState extends State<SliderEvaluation> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 18,
          decoration: BoxDecoration(
            gradient: AppColors.sliderGradient,
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        FlutterSlider(
          values: [widget.weight],
          max: 1,
          min: 0,
          disabled: true,
          handler: FlutterSliderHandler(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: getGradientColorAtPosition(startColor: AppColors.redGradient, middleColor: AppColors.orangeGradient, endColor: AppColors.greenGradient, position: widget.weight),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
            ),
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarDraggable: false,
            inactiveTrackBar: BoxDecoration(
                color: Colors.transparent,
            ),
            inactiveTrackBarHeight: 0.1,

            activeTrackBar: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5)
            ),
            activeTrackBarHeight: 0.1,
          ),
        ),
      ],
    );
  }

  Color getGradientColorAtPosition({
    required Color startColor,
    required Color middleColor,
    required Color endColor,
    required double position, // Posición entre 0.0 y 1.0
  }) {
    // Aseguramos que la posición esté dentro del rango 0.0 a 1.0
    position = position.clamp(0.0, 1.0);

    if (position <= 0.5) {
      // Interpolación entre startColor y middleColor
      double segmentPosition = position / 0.5;
      return Color.lerp(startColor, middleColor, segmentPosition)!;
    } else {
      // Interpolación entre middleColor y endColor
      double segmentPosition = (position - 0.5) / 0.5;
      return Color.lerp(middleColor, endColor, segmentPosition)!;
    }
  }
}
