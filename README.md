# flutter_safe_setstate

A Flutter package that provides a safe setState extension to prevent calling setState on disposed widgets.

## Features

- 🔒 **Safe setState**: Wraps setState in a try-catch block so errors from disposed widgets are caught instead of propagated
- 🎯 **Null-safe**: Fully supports null safety
- 📦 **Lightweight**: No additional dependencies required
- 🔧 **Easy to use**: Simple extension method on State
- 📤 **Return value**: Returns `bool` indicating whether setState was called successfully
- 🚨 **Error handling**: Optional `onError` callback for handling errors thrown by setState

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_safe_setstate: ^1.2.0
```

Then run:

```bash
flutter pub get
```

## Usage

Simply import the package and use `safeSetStateWrapper` instead of `setState`:

```dart
import 'package:flutter_safe_setstate/flutter_safe_setstate.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  void _incrementCounter() {
    // Use safeSetStateWrapper instead of setState
    safeSetStateWrapper(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Counter: $_counter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Why use safeSetStateWrapper?

When using `setState` in asynchronous operations (like API calls), the widget might get disposed before the operation completes. This causes Flutter to throw an error:

````dart
// ❌ This can cause errors if the widget is disposed
Future<void> fetchData() async {
  final data = await api.getData();
  setState(() {
    _data = data;
  });
}

```dart
// ✅ This is safe
Future<void> fetchData() async {
  final data = await api.getData();
  safeSetStateWrapper(() {
    _data = data;
  });
}
````

### Using return value and onError callback

The `safeSetStateWrapper` method returns a `bool` indicating whether setState completed without throwing. You can also provide an optional `onError` callback to handle errors caught from setState, e.g. when the widget has already been disposed:

```dart
Future<void> fetchData() async {
  final data = await api.getData();

  final success = safeSetStateWrapper(
    () {
      _data = data;
    },
    onError: (error) {
      print('setState failed: $error');
    },
  );

  if (!success) {
    print('setState did not complete because an error was caught');
  }
}
```

### Using it as a regular function

An extension method can only be called on a `State` from inside that state. If you hold a `State` reference elsewhere, use the top-level `safeSetState` function instead — it forwards to the extension method:

```dart
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

> Note: `state` must be the `State` that owns the data being updated. Passing an unrelated `State` still compiles but updates the wrong widget.

## Additional information

For more information, visit the [GitHub repository](https://github.com/qiqd/flutter-safe-setstate).

If you find any issues or have suggestions, please file them on the [issue tracker](https://github.com/qiqd/flutter-safe-setstate/issues).
