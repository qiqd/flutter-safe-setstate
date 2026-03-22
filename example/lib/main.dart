import 'package:flutter/material.dart';
import 'package:flutter_safe_setstate/flutter_safe_setstate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe SetState Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SafeSetStateDemo(),
    );
  }
}

class SafeSetStateDemo extends StatefulWidget {
  const SafeSetStateDemo({super.key});

  @override
  State<SafeSetStateDemo> createState() => _SafeSetStateDemoState();
}

class _SafeSetStateDemoState extends State<SafeSetStateDemo> {
  int _counter = 0;
  bool _isLoading = false;
  String _status = 'Ready';

  Future<void> _incrementWithDelay() async {
    safeSetState(() {
      _isLoading = true;
      _status = 'Processing...';
    });

    await Future.delayed(const Duration(seconds: 2));

    safeSetState(() {
      _counter++;
      _isLoading = false;
      _status = 'Completed!';
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      safeSetState(() {
        _status = 'Ready';
      });
    });
  }

  void _incrementDirectly() {
    safeSetState(() {
      _counter++;
      _status = 'Incremented directly';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe SetState Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Counter Value:', style: TextStyle(fontSize: 20)),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Status: $_status',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _incrementWithDelay,
                  icon: const Icon(Icons.timer),
                  label: const Text('Async Increment'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _incrementDirectly,
                  icon: const Icon(Icons.add),
                  label: const Text('Direct Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
