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
  /// [callback] is the function to execute when the widget is mounted.
  ///
  /// [onUnmounted] is an optional callback that is called if an error occurs
  /// during the setState operation. The error object is passed as a parameter.
  ///
  /// Returns `true` if setState was called successfully, `false` if the widget
  /// was not mounted or an error was caught.
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
  /// Example with error handling and return value:
  /// ```dart
  /// Future<void> fetchData() async {
  ///   final data = await api.getData();
  ///   final success = safeSetState(
  ///     () {
  ///       _data = data;
  ///     },
  ///     onUnmounted: (error) {
  ///       print('Error occurred: $error');
  ///     },
  ///   );
  ///   if (!success) {
  ///     print('State was not updated');
  ///   }
  /// }
  /// ```
  ///
  /// See also:
  /// * [setState] - The original Flutter setState method
  /// * [mounted] - Property that indicates if the widget is still in the tree
  bool safeSetState(
    VoidCallback callback, {
    void Function(dynamic e)? onUnmounted,
  }) {
    try {
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(callback);
        return true;
      }
    } catch (e) {
      onUnmounted?.call(e);
      return false;
    }
    return false;
  }
}
