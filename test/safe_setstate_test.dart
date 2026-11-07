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

  testWidgets(
    'safeSetState should call onError callback when setState throws',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestWidget()));

      final testWidgetState = tester.state<TestWidgetState>(
        find.byType(TestWidget),
      );

      // Remove the widget from the tree
      await tester.pumpWidget(MaterialApp(home: Container()));

      bool callbackCalled = false;
      dynamic capturedError;

      final result = testWidgetState.safeSetStateWrapper(
        () {},
        onError: (error) {
          callbackCalled = true;
          capturedError = error;
        },
      );

      expect(callbackCalled, true);
      expect(capturedError, isNotNull);
      expect(result, false);
    },
  );

  testWidgets('safeSetState should not call onError when setState succeeds', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    bool callbackCalled = false;

    final result = testWidgetState.safeSetStateWrapper(
      () {},
      onError: (error) {
        callbackCalled = true;
      },
    );
    await tester.pump();

    expect(callbackCalled, false);
    expect(result, true);
  });

  testWidgets('top-level safeSetState should update state when mounted', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    expect(testWidgetState.counter, 0);

    final result = testWidgetState.incrementCounterGlobal();
    await tester.pump();

    expect(result, true);
    expect(testWidgetState.counter, 1);
  });

  testWidgets('top-level safeSetState should not throw when disposed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    await tester.pumpWidget(MaterialApp(home: Container()));

    expect(() => testWidgetState.incrementCounterGlobal(), returnsNormally);
  });

  testWidgets('top-level safeSetState should return false when disposed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    await tester.pumpWidget(MaterialApp(home: Container()));

    final result = testWidgetState.incrementCounterGlobal();

    expect(result, false);
  });

  testWidgets('top-level safeSetState should forward onError callback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: TestWidget()));

    final testWidgetState = tester.state<TestWidgetState>(
      find.byType(TestWidget),
    );

    await tester.pumpWidget(MaterialApp(home: Container()));

    bool callbackCalled = false;
    dynamic capturedError;

    final result = testWidgetState.incrementCounterGlobalWithOnError((error) {
      callbackCalled = true;
      capturedError = error;
    });

    expect(callbackCalled, true);
    expect(capturedError, isNotNull);
    expect(result, false);
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
    return safeSetStateWrapper(() {
      counter++;
    });
  }

  bool incrementCounterGlobal() {
    return safeSetState(this, () {
      counter++;
    });
  }

  bool incrementCounterGlobalWithOnError(void Function(dynamic e) onError) {
    return safeSetState(this, () {
      counter++;
    }, onError: onError);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
