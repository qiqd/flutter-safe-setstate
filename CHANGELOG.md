## 1.2.0

- Added top-level `safeSetState` function that takes a `State` and forwards to the extension method
- Added optional named `onError` parameter to the top-level function, matching the extension method
- Renamed the extension method to `safeSetStateWrapper` to avoid a name clash with the top-level function
- Updated API documentation with examples and an explanation of how the two entry points differ
- Updated example app and README to use the new method name and `onError` parameter
- Added tests covering the top-level function: mounted update, disposed behavior, return value and `onError` forwarding

### Breaking change

- The extension member `safeSetState` has been renamed to `safeSetStateWrapper`. The name `safeSetState` is now used by a top-level function.

### Migration from 1.1.x

- Calling `safeSetState(...)` inside a `State` (extension member) must be changed to `safeSetStateWrapper(...)`:

  ```dart
  // 1.1.x
  safeSetState(() {
    _counter++;
  });

  // 1.2.0
  safeSetStateWrapper(() {
    _counter++;
  });
  ```

- If you need to call it on a `State` reference from outside that state, use the new top-level function, which takes the `State` as its first argument:

  ```dart
  // 1.2.0
  final success = safeSetState(
    someState,
    () {
      // update that state's data
    },
    onError: (error) {
      print('setState failed: $error');
    },
  );
  ```

- The `onError` parameter keeps the same name and semantics on both entry points.

## 1.1.2

- Added `onError` optional callback parameter for error handling
- Added try-catch exception handling
- Changed return type from `void` to `bool` indicating whether setState completed without throwing

## 1.0.2

- Modified the method parameter name to callback

## 1.0.1

- Added comprehensive API documentation
- Created example app demonstrating usage
- Improved package score to 160/160 points
- Added detailed code examples and usage instructions

## 1.0.0

- Initial release of flutter_safe_setstate
- Provides safe setState extension to prevent calling setState on disposed widgets
- Includes comprehensive test coverage
- Fully null-safe implementation
- Lightweight with no additional dependencies
