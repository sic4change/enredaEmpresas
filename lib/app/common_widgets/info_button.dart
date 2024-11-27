import 'package:enreda_empresas/app/common_widgets/custom_text.dart';
import 'package:enreda_empresas/app/common_widgets/on_hover_effect.dart';
import 'package:enreda_empresas/app/utils/responsive.dart';
import 'package:enreda_empresas/app/utils/triangle_painter.dart';
import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatefulWidget {
  const InfoButton({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _InfoButtonState createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  late OverlayEntry _overlayEntry;
  GlobalKey key = GlobalKey();
  bool wasMoved = false;

  @override
  void initState() {
    super.initState();
    _overlayEntry = OverlayEntry(builder: (context) {
      RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);
      double x = position.dx + box.size.width;
      if(box.size.width < 30){
        x += 6;
      }
      print(box.size.width);
      double y = position.dy + box.size.height; // Posicionar justo debajo del botón

      // Ajusta la posición si el recuadro se sale de los límites de la pantalla
      if (x + 300 > MediaQuery.of(context).size.width) x -= 260;
      if (y + 150 > MediaQuery.of(context).size.height){
        wasMoved = true;
        y -= 180;
      }

      return Stack(
        children: [
          GestureDetector(onTap: () => _overlayEntry.remove()),
          Positioned(
            top: y,
            left: x,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Stack(
                children: [
                  !wasMoved ? Positioned(
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor: AppColors.primary050,
                          strokeWidth: 10,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                        ),
                      ),
                    ),
                  ) : Container(),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(
                        top: 13, bottom: 13, right: 18, left: 18),
                    decoration: BoxDecoration(
                      color: AppColors.primary050,
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    constraints: BoxConstraints(maxWidth: 240),
                    child: Column(
                      children: [
                        _buildText(widget.title)
                      ],
                    ),
                  ),
                  // Icono de cierre
                  /*Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        _overlayEntry.remove();
                      },
                      icon: Icon(Icons.close), iconSize: 20,
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() {
    _overlayEntry.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnHoverEffect(builder: (isHovered) {
      final double iconSize = 24;
      //final double iconSize = isHovered ? 34 : 24;
      return InkWell(
        key: key,
        onTap: () {
          if (Responsive.isMobile(context)) {
            showDialog(
              context: context,
              useRootNavigator: false,
              builder: (dialogContext) => Dialog(
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildText(widget.title),
                  ],
                ),
              ),
            );
          } else {
            if (_overlayEntry.mounted) {
              _overlayEntry.remove();
            } else {
              Overlay.of(context).insert(_overlayEntry);
            }
          }
        },
        child: Container(
          width: iconSize,
          height: iconSize,
          child: Image.asset(ImagePath.ICON_INFO))
      );
    });
  }

  _buildText(String text) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.labelMedium!,
    );
  }
}
