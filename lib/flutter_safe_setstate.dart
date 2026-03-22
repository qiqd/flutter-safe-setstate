import 'package:flutter/widgets.dart';

extension FlutterSafeSetState<T extends StatefulWidget> on State<T> {
  void safeSetState(void Function() fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}
