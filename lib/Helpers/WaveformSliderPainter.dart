import 'package:flutter/material.dart';

// dessiner un slider de forme rectangulaire en utilisant les échantillons d'une forme d'onde audio
class WaveformSliderPainter extends CustomPainter {
  final List<int> samples;
  final Color color;
  final Color progressColor;
  final double progress;

  WaveformSliderPainter({required this.samples, required this.color, required this.progressColor, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final scaleY = size.height / 255;

    for (int i = 0; i < samples.length; i++) {
      final sample = samples[i].toDouble();
      final x = i * (size.width / samples.length);
      final lineHeight = sample * scaleY;
      final top = (size.height - lineHeight) / 2;
      final bottom = top + lineHeight;
      final rect = Rect.fromLTRB(x, top, x + (size.width / samples.length), bottom);
      if (i / samples.length < progress) {
        paint.color = progressColor;
      } else {
        paint.color = color;
      }
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(WaveformSliderPainter oldDelegate) => oldDelegate.progress != progress;
}
