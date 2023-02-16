import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Toast {
  // ignore: non_constant_identifier_names
  static final int LENGTH_SHORT = 1;

  // ignore: non_constant_identifier_names
  static final int LENGTH_LONG = 2;

  // ignore: non_constant_identifier_names
  static final int BOTTOM = 0;

  // ignore: non_constant_identifier_names
  static final int CENTER = 1;

  // ignore: non_constant_identifier_names
  static final int TOP = 2;

  static void show(
    String msg,
    BuildContext context, {
    int duration = 1,
    int gravity = 0,
    Color backgroundColor = const Color(0xAA000000),
    Color textColor = Colors.white,
    double backgroundRadius = 20,
  }) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textColor, backgroundRadius, Border.all());
  }
}

class ToastView {
  static final ToastView _singleton = ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState? overlayState;
  static OverlayEntry? _overlayEntry;
  static bool? _isVisible = false;

  static void createView(
      String msg,
      BuildContext context,
      int duration,
      int gravity,
      Color background,
      Color textColor,
      double backgroundRadius,
      Border border) async {
    overlayState = Overlay.of(context);

    Paint paint = Paint();
    paint.strokeCap = StrokeCap.square;
    paint.color = background;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(backgroundRadius),
                    border: border,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Text(msg,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(fontSize: 15.sp, color: textColor)),
                )),
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState!.insert(_overlayEntry!);
    await Future.delayed(Duration(seconds: duration));
    dismiss();
  }

  static dismiss() async {
    if (!_isVisible!) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key? key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget? widget;
  final int? gravity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: gravity == 2 ? 50 : null,
        bottom: gravity == 0 ? 100 : null,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ));
  }
}
