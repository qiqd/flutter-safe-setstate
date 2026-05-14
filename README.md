# flutter_safe_setstate

A Flutter package that provides a safe setState extension to prevent calling setState on disposed widgets.

## Features

- 🔒 **Safe setState**: Automatically checks if the widget is still mounted before calling setState
- 🎯 **Null-safe**: Fully supports null safety
- 📦 **Lightweight**: No additional dependencies required
- 🔧 **Easy to use**: Simple extension method on State

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_safe_setstate: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## Usage

Simply import the package and use `safeSetState` instead of `setState`:

```dart
import 'package:flutter_safe_setstate/safe_setstate.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  void _incrementCounter() {
    // Use safeSetState instead of setState
    safeSetState(() {
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

### Why use safeSetState?

When using `setState` in asynchronous operations (like API calls), the widget might get disposed before the operation completes. This causes Flutter to throw an error:

```dart
// ❌ This can cause errors if the widget is disposed
Future<void> fetchData() async {
  final data = await api.getData();
  setState(() {
    _data = data;
  });
}

// ✅ This is safe
Future<void> fetchData() async {
  final data = await api.getData();
  safeSetState(() {
    _data = data;
  });
}
```

## Additional information

For more information, visit the [GitHub repository](https://github.com/qiqd/flutter-safe-setstate).

If you find any issues or have suggestions, please file them on the [issue tracker](https://github.com/qiqd/flutter-safe-setstate/issues).
