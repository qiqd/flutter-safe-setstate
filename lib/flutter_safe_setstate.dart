/// flutter_safe_setstate
///
/// A Flutter package that provides a safe setState extension to prevent calling
/// setState on disposed widgets.
///
/// This package helps avoid common Flutter errors when using setState in
/// asynchronous operations where the widget might be disposed before the
/// operation completes.
library;

import 'package:flutter/widgets.dart';

/// Extension that provides a safe alternative to setState for StatefulWidget.
///
/// This extension adds the [safeSetState] method which automatically checks
/// if the widget is still mounted before calling setState, preventing
/// runtime errors when setState is called on disposed widgets.
extension FlutterSafeSetState<T extends StatefulWidget> on State<T> {
  /// Safely calls setState if the widget is still mounted.
  ///
  /// This method should be used instead of the regular setState when there's
  /// a possibility that the widget might be disposed before the state update
  /// occurs, such as in asynchronous operations.
  ///
  /// Example:
  /// ```dart
  /// Future<void> fetchData() async {
  ///   final data = await api.getData();
  ///   // Safe: won't throw if widget is disposed
  ///   safeSetState(() {
  ///     _data = data;
  ///   });
  /// }
  /// ```
  ///
  /// See also:
  /// * [setState] - The original Flutter setState method
  /// * [mounted] - Property that indicates if the widget is still in the tree
  void safeSetState(VoidCallback callback) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(callback);
    }
  }
}
