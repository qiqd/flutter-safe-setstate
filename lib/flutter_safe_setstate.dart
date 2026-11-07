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
/// This extension adds the [safeSetStateWrapper] method which wraps setState in
/// a try-catch block. When setState throws (for example, because the widget has
/// already been disposed), the error is caught instead of propagated,
/// preventing runtime errors when setState is called on disposed widgets.
///
/// If you prefer calling it as a regular function instead of a member, use the
/// top-level [safeSetState] function, which forwards to this method.
extension FlutterSafeSetState<T extends StatefulWidget> on State<T> {
  /// Safely calls setState, catching any errors thrown during the update.
  ///
  /// This method should be used instead of the regular setState when there's
  /// a possibility that the widget might be disposed before the state update
  /// occurs, such as in asynchronous operations. Any exception thrown by
  /// setState is caught instead of being propagated.
  ///
  /// [callback] is the function that is passed to setState to execute the
  /// state update. Note that it is always invoked via setState; if setState
  /// throws, the exception is caught and [onError] (if provided) is called.
  ///
  /// [onError] is an optional callback that is called with the caught error
  /// when setState throws. Typically used to handle the case where the widget
  /// has already been disposed.
  ///
  /// Returns `true` if setState completed without throwing, `false` if an
  /// error was caught.
  ///
  /// Example:
  /// ```dart
  /// Future<void> fetchData() async {
  ///   final data = await api.getData();
  ///   // Safe: won't propagate an error if widget is disposed
  ///   safeSetStateWrapper(() {
  ///     _data = data;
  ///   });
  /// }
  /// ```
  ///
  /// Example with error handling and return value:
  /// ```dart
  /// Future<void> fetchData() async {
  ///   final data = await api.getData();
  ///   final success = safeSetStateWrapper(
  ///     () {
  ///       _data = data;
  ///     },
  ///     onError: (error) {
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
  /// * [safeSetState] - Top-level function variant of this method
  /// * [setState] - The original Flutter setState method
  /// * [mounted] - Property that indicates if the widget is still in the tree
  bool safeSetStateWrapper(
    VoidCallback callback, {
    void Function(dynamic e)? onError,
  }) {
    try {
      // ignore: invalid_use_of_protected_member
      setState(callback);
      return true;
    } catch (e) {
      onError?.call(e);
      return false;
    }
  }
}

/// Top-level variant of [FlutterSafeSetState.safeSetStateWrapper].
///
/// Safely calls setState on the given [state], catching any error thrown
/// during the update instead of propagating it. Use this when you cannot call
/// the extension method on `this`, for example when holding a [State] reference
/// from elsewhere.
///
/// [state] is the [State] object whose setState should be called. It must be
/// the state that owns the data being updated; passing an unrelated state will
/// still compile but updates the wrong widget.
///
/// [callback] is the function that is passed to setState to execute the state
/// update. Note that it is always invoked via setState; if setState throws, the
/// exception is caught and [onError] (if provided) is called.
///
/// [onError] is an optional callback that is called with the caught error when
/// setState throws. Typically used to handle the case where the widget has
/// already been disposed.
///
/// Returns `true` if setState completed without throwing, `false` if an error
/// was caught.
///
/// Example:
/// ```dart
/// Future<void> fetchData(State<MyWidget> state) async {
///   final data = await api.getData();
///   final success = safeSetState(state, () {
///     // update state-owned data
///   }, onError: (error) {
///     print('Error occurred: $error');
///   });
///   if (!success) {
///     print('State was not updated');
///   }
/// }
/// ```
///
/// See also:
/// * [FlutterSafeSetState.safeSetStateWrapper] - The extension method
bool safeSetState<T extends StatefulWidget>(
  State<T> state,
  VoidCallback callback, {
  void Function(dynamic e)? onError,
}) => state.safeSetStateWrapper(callback, onError: onError);
