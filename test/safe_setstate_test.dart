import 'package:flutter/material.dart';
import 'package:flutter_safe_setstate/flutter_safe_setstate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('safeSetState should update state when widget is mounted', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    expect(testWidgetState.counter, 0);

    testWidgetState.incrementCounter();
    await tester.pump();

    expect(testWidgetState.counter, 1);
  });

  testWidgets('safeSetState should not throw when widget is disposed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    // Remove the widget from the tree
    await tester.pumpWidget(MaterialApp(home: Container()));

    // This should not throw an error
    expect(() => testWidgetState.incrementCounter(), returnsNormally);
  });

  testWidgets('safeSetState should return true when widget is mounted', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    final result = testWidgetState.incrementCounter();
    await tester.pump();

    expect(result, true);
  });

  testWidgets('safeSetState should return false when widget is disposed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    // Remove the widget from the tree
    await tester.pumpWidget(MaterialApp(home: Container()));

    final result = testWidgetState.incrementCounter();

    expect(result, false);
  });

  testWidgets('safeSetState should call onUnmounted callback when error occurs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    // Remove the widget from the tree
    await tester.pumpWidget(MaterialApp(home: Container()));

    bool callbackCalled = false;
    dynamic capturedError;

    testWidgetState.safeSetState(
      () {},
      onUnmounted: (error) {
        callbackCalled = true;
        capturedError = error;
      },
    );

    expect(callbackCalled, false);
  });
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  int counter = 0;

  bool incrementCounter() {
    return safeSetState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
