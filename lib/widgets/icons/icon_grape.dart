import 'package:flutter/material.dart';

/// Versión simplificada del logo de Vitis (un racimo de uvas), pensada
/// para usarse chica y en un solo color -como IconoBarril-, a
/// diferencia del logo.png que tiene demasiado detalle para verse
/// bien a tamaño de ícono de barra de navegación.
///
/// Sin color o size, los toma del IconTheme más cercano, igual que Icon.
class IconoUva extends StatelessWidget {
  final Color? color;
  final double? size;

  const IconoUva({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final size = this.size ?? iconTheme.size ?? 20;
    final color = this.color ?? iconTheme.color ?? Colors.black;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _UvaPainter(color: color)),
    );
  }
}

class _UvaPainter extends CustomPainter {
  final Color color;

  _UvaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final relleno = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final tallo = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;

    // Tallito curvo arriba del racimo.
    final pathTallo = Path()
      ..moveTo(w * 0.50, h * 0.02)
      ..quadraticBezierTo(w * 0.62, h * 0.10, w * 0.50, h * 0.22);
    canvas.drawPath(pathTallo, tallo);

    // Racimo: círculos superpuestos, más chicos arriba y más grandes abajo.
    final radios = <Offset, double>{
      Offset(w * 0.50, h * 0.32): w * 0.15,
      Offset(w * 0.32, h * 0.46): w * 0.16,
      Offset(w * 0.68, h * 0.46): w * 0.16,
      Offset(w * 0.50, h * 0.58): w * 0.15,
      Offset(w * 0.22, h * 0.64): w * 0.15,
      Offset(w * 0.78, h * 0.64): w * 0.15,
      Offset(w * 0.36, h * 0.78): w * 0.16,
      Offset(w * 0.64, h * 0.78): w * 0.16,
      Offset(w * 0.50, h * 0.92): w * 0.15,
    };
    radios.forEach((centro, radio) {
      canvas.drawCircle(centro, radio, relleno);
    });
  }

  @override
  bool shouldRepaint(covariant _UvaPainter oldDelegate) => oldDelegate.color != color;
}
