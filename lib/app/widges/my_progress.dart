import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winebox/app/utils/colors.dart';

enum MyProgressType { Normal, Download }

String _dialogMessage = "";
double _progress = 0.0, _maxProgress = 100.0;

bool _isShowing = false;
MyProgressType _progressDialogType = MyProgressType.Normal;
bool _barrierDismissible = true, _showLogs = false;

TextStyle _progressTextStyle = TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    _messageStyle = TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600);

//double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.transparent;
Curve _insetAnimCurve = Curves.bounceInOut;

Widget _progressWidget = CircularProgressIndicator();

class MyProgress {
  late _Body _dialog;

  MyProgress(BuildContext context,
      {MyProgressType? type, bool? isDismissible, bool? showLogs}) {
    _progressDialogType = type ?? MyProgressType.Normal;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? false;
  }

  void style(
      {double? progress,
      double? maxProgress,
      String? message,
      Widget? progressWidget,
      Color? backgroundColor,
      TextStyle? progressTextStyle,
      TextStyle? messageTextStyle,
      double? elevation,
      double? borderRadius,
      Curve? insetAnimCurve}) {
    if (_isShowing) return;
    if (_progressDialogType == MyProgressType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
//    _dialogElevation = elevation ?? _dialogElevation;
//    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
  }

  void update(
      {double? progress,
      double? maxProgress,
      String? message,
      Widget? progressWidget,
      TextStyle? progressTextStyle,
      TextStyle? messageTextStyle}) {
    if (_progressDialogType == MyProgressType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;

    if (_isShowing) _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void dismiss(BuildContext context) {
    if (_isShowing) {
      try {
        _isShowing = false;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          if (_showLogs) debugPrint('MyProgress dismissed');
        } else {
          if (_showLogs) debugPrint('Cant pop MyProgress');
        }
      } catch (_) {}
    } else {
      if (_showLogs) debugPrint('MyProgress already dismissed');
    }
  }

  Future<bool> hide(BuildContext context) {
    if (_isShowing) {
      try {
        _isShowing = false;
        Navigator.of(context).pop(true);
        if (_showLogs) debugPrint('MyProgress dismissed');
        return Future.value(true);
      } catch (_) {
        return Future.value(false);
      }
    } else {
      if (_showLogs) debugPrint('MyProgress already dismissed');
      return Future.value(false);
    }
  }

  void show(BuildContext context, BuildContext dismissingContext) {
    if (!_isShowing) {
      _dialog = new _Body();
      _isShowing = true;

      if (_showLogs) debugPrint('MyProgress shown');

      showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dismissingContext = context;
          return WillPopScope(
            onWillPop: () {
              return Future.value(_barrierDismissible);
            },
            child: Dialog(
                backgroundColor: Colors.transparent,
                insetAnimationCurve: _insetAnimCurve,
                insetAnimationDuration: Duration(milliseconds: 5),
                elevation: 100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: _dialog),
          );
        },
      );
    } else {
      if (_showLogs) debugPrint("MyProgress already shown/showing");
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {

  }

  @override
  void dispose() {
    _isShowing = false;
    if (_showLogs) debugPrint('MyProgress dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          CircularProgressIndicator(color: winebox_red),
          SizedBox(
            height: 10,
          ),
          Text(
          'Please wait',
            style: TextStyle(color: winebox_red),
          )
        ]),
      ),
    );
  }
}
