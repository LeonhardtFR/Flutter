import 'package:flutter/cupertino.dart';
import 'package:marquee/marquee.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double height;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double blankSpace;
  final double velocity;
  final double fadingEdgeStartFraction;
  final double fadingEdgeEndFraction;
  final TextAlign defaultAlignment;

  const AnimatedText({
    super.key,
    required this.text,
    this.style,
    this.height = 35,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.blankSpace = 80.0,
    this.velocity = 25.0,
    this.fadingEdgeStartFraction = 0.1,
    this.fadingEdgeEndFraction = 0.1,
    this.defaultAlignment = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: text,
          style: style,
        );
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        if (tp.didExceedMaxLines) {
          return SizedBox(
              height: height,
              child: Marquee(
                text: text,
                style: style,
                scrollAxis: scrollAxis,
                crossAxisAlignment: crossAxisAlignment,
                blankSpace: blankSpace,
                velocity: velocity,
                fadingEdgeEndFraction: fadingEdgeEndFraction,
                fadingEdgeStartFraction: fadingEdgeStartFraction,
              )
          );
        } else {
          return Text(text, style: style, textAlign: defaultAlignment);
        }
      },
    );
  }
}