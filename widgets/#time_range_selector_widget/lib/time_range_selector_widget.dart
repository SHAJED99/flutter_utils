import 'dart:math';

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class TimeRangeSelectorWidget extends StatefulWidget {
  const TimeRangeSelectorWidget({
    super.key,
    required this.initialTime,
    this.minTime = 0,
    this.maxTime = 12,
    this.stockWidth = 24 * 2,
    this.padding = 8,
    this.stockColor,
    this.shadowColorLight,
    this.shadowColorDark,
    this.containerDecoration = const BoxDecoration(
      color: Colors.white,
    ),
    this.backgroundDecoration = const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.white,
        ],
      ),
    ),
    this.onChangeValue,
    this.childBuilder,
    this.canvasColors = const [
      Colors.white
    ],
    this.dotBuilder,
    this.dotHandleColor = Colors.white,
    this.indexPointerDotColor = Colors.black,
  });

  /// A callback function called when the selected time changes.
  final Function(int currentTime)? onChangeValue;

  /// A builder function to provide custom child widgets based on the selected time.
  final Widget Function(int currentTime)? childBuilder;

  /// A builder function to provide custom dots at specific positions.
  final Function(int itemIndex, Offset offset, Canvas canvas)? dotBuilder;

  /// Background BoxDecoration.
  final BoxDecoration backgroundDecoration;
  final BoxDecoration containerDecoration;

  /// Colors gradient for the circular canvas.
  final List<Color> canvasColors;

  /// Handler dot color.
  final Color dotHandleColor;

  /// Small index dots color.
  final Color indexPointerDotColor;

  /// The initial time value of the selector.
  final int initialTime;

  /// The maximum selectable time value.
  final int maxTime;

  /// The minimum selectable time value.
  final int minTime;

  /// Padding and shadow size
  final double padding;

  /// Shadow color for dark area.
  final Color? shadowColorDark;

  /// Shadow color for light area.
  final Color? shadowColorLight;

  /// Circular line color
  final Color? stockColor;

  /// The width of the circular line.
  final double stockWidth;

  @override
  State<TimeRangeSelectorWidget> createState() => _TimeRangeSelectorWidgetState();
}

class _TimeRangeSelectorWidgetState extends State<TimeRangeSelectorWidget> {
  late int currentTime;
  late int totalTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime < widget.minTime || widget.initialTime > widget.maxTime) {
      throw Exception("Current time must be in time range (Max and min time)");
    }
    currentTime = widget.initialTime - widget.minTime;

    totalTime = widget.maxTime - widget.minTime + 1;
    if (widget.maxTime <= widget.minTime) {
      throw Exception("Max Time must be greater than min time");
    }
  }

  /// Builds the circular box that contains the clock selector.
  Widget drawBox({required BuildContext context, Widget? child}) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          margin: child == null ? null : EdgeInsets.all(widget.stockWidth),
          // decoration: boxDecoration,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: child == null
                ? null
                : widget.canvasColors.length == 1
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.canvasColors,
                      ),
            color: child == null ? null : widget.canvasColors.first,
            boxShadow: [
              BoxShadow(
                color: widget.shadowColorLight ?? Theme.of(context).cardColor.withOpacity(0.5),
                blurRadius: widget.padding / 2,
                offset: Offset(-widget.padding / 2, -widget.padding / 2),
                inset: child == null, // This line should be comment if you don't want to use "flutter_inset_box_shadow" package
              ),
              BoxShadow(
                color: widget.shadowColorDark ?? Theme.of(context).shadowColor.withOpacity(0.5),
                blurRadius: widget.padding / 2,
                offset: Offset(widget.padding / 2, widget.padding / 2),
                inset: child == null, // This line should be comment if you don't want to use "flutter_inset_box_shadow" package
              ),
            ],
          ),

          child: child,
        ),
      ],
    );
  }

  /// Handles the time change when dragging.
  changeTime(double angle) async {
    int i = ((angle / 360) * totalTime).round();
    if (i >= totalTime) i = 0;
    if (currentTime != i && widget.onChangeValue != null) {
      if (mounted) setState(() => currentTime = i);
      widget.onChangeValue!(i + widget.minTime);
    }
  }

  /// Calculates the angle of a point relative to the center of the clock selector.
  double angleCounter(Size size, DragUpdateDetails details) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final double dx = details.localPosition.dx - centerX;
    final double dy = details.localPosition.dy - centerY;

    double angle = atan2(dy, dx);
    angle = 90 + (angle * 180 / pi);
    if (angle < 0) angle += 360;
    return angle;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(builder: (context, box) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            children: [
              /// -------------------------------------------------------------------------------------- Background
              Positioned.fill(
                child: Container(decoration: widget.backgroundDecoration),
              ),

              /// -------------------------------------------------------------------------------------- Line
              Positioned.fill(
                child: CustomPaint(
                  painter: _CustomClockPickerPaint(
                    time: currentTime,
                    totalTime: totalTime,
                    stokeWidth: widget.stockWidth,
                    stockColor: widget.stockColor ?? Theme.of(context).primaryColor,
                    padding: widget.padding,
                    dotBuilder: widget.dotBuilder,
                    dotHandleColor: widget.dotHandleColor,
                    indexPointerDotColor: widget.indexPointerDotColor,
                  ),
                ),
              ),

              /// -------------------------------------------------------------------------------------- Back Canvas
              Positioned.fill(child: drawBox(context: context)),

              /// -------------------------------------------------------------------------------------- Front Canvas
              drawBox(
                context: context,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: widget.childBuilder == null ? const SizedBox() : widget.childBuilder!(currentTime + widget.minTime),
                ),
              ),

              /// -------------------------------------------------------------------------------------- Draggable
              Positioned.fill(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    double angle = angleCounter(Size(box.maxWidth, box.maxHeight), details);
                    changeTime(angle);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              //! Blocking Touch
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.all(widget.stockWidth),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CustomClockPickerPaint extends CustomPainter {
  _CustomClockPickerPaint({
    required this.time,
    required this.totalTime,
    required this.stokeWidth,
    required this.padding,
    required this.stockColor,
    this.dotBuilder,
    required this.dotHandleColor,
    required this.indexPointerDotColor,
  });

  final Function(int itemIndex, Offset offset, Canvas canvas)? dotBuilder;
  final Color dotHandleColor;
  final Color indexPointerDotColor;
  final double padding;
  final Color stockColor;
  final double stokeWidth;
  final int time;
  final int totalTime;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min((size.height / 2) - (stokeWidth / 2), (size.width / 2) - (stokeWidth / 2));

    //! -------------------------------------------------------------------------------------------- Line
    var arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = stockColor;
    double currentAngle = time * (2 * pi) / totalTime;
    if (currentAngle == 0) currentAngle = 0.0001;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, -pi / 2, currentAngle, false, arcPaint);

    //! -------------------------------------------------------------------------------------------- Small Dot
    final smallDotColor = Paint()..color = indexPointerDotColor;
    for (var i = 0; i < totalTime; i++) {
      final smallDotX = centerX + radius * cos((270 + (360 * i / totalTime)) * pi / 180);
      final smallDotY = centerY + radius * sin((270 + (360 * i / totalTime)) * pi / 180);
      final offset = Offset(smallDotX, smallDotY);

      if (dotBuilder != null) {
        dotBuilder!(i, offset, canvas);
      } else {
        canvas.drawCircle(offset, padding / 3, smallDotColor);
      }
    }

    //! -------------------------------------------------------------------------------------------- Big Dot
    final fillPaint = Paint()..color = dotHandleColor;
    final dotX = centerX + radius * cos((270 + (360 * time / totalTime)) * pi / 180);
    final dotY = centerY + radius * sin((270 + (360 * time / totalTime)) * pi / 180);
    canvas.drawCircle(Offset(dotX, dotY), (stokeWidth / 2) - padding, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
