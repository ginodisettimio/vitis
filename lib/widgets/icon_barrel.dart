import 'package:flutter/material.dart';

// Ícono de barril dibujado a mano (Flutter no trae uno en su set de Material Icons).
class IconoBarril extends StatelessWidget {
  final Color color;
  final double size;

  const IconoBarril({super.key, required this.color, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BarrilPainter(color: color),
      ),
    );
  }
}

class _BarrilPainter extends CustomPainter {
  final Color color;

  _BarrilPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paintRelleno = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintLinea = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round;

    // Cuerpo del barril: más ancho en el medio, angosto arriba y abajo.
    final cuerpo = Path()
      ..moveTo(w * 0.28, h * 0.08)
      ..quadraticBezierTo(w * 0.05, h * 0.30, w * 0.05, h * 0.50)
      ..quadraticBezierTo(w * 0.05, h * 0.70, w * 0.28, h * 0.92)
      ..lineTo(w * 0.72, h * 0.92)
      ..quadraticBezierTo(w * 0.95, h * 0.70, w * 0.95, h * 0.50)
      ..quadraticBezierTo(w * 0.95, h * 0.30, w * 0.72, h * 0.08)
      ..close();
    canvas.drawPath(cuerpo, paintRelleno);

    // Aros del barril (arriba y abajo) en un tono más claro.
    final paintAro = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06;
    canvas.drawLine(Offset(w * 0.10, h * 0.28), Offset(w * 0.90, h * 0.28), paintAro);
    canvas.drawLine(Offset(w * 0.10, h * 0.72), Offset(w * 0.90, h * 0.72), paintAro);

    // Tapa superior (línea curva sugiriendo la tapa del barril).
    canvas.drawLine(Offset(w * 0.30, h * 0.08), Offset(w * 0.70, h * 0.08), paintLinea);
  }

  @override
  bool shouldRepaint(covariant _BarrilPainter oldDelegate) => oldDelegate.color != color;
}