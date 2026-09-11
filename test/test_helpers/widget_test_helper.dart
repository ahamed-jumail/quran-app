import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class WidgetTestHelper {
  static FutureOr<void> ensureTextIsVisible({
    required WidgetTester tester,
    required String text,
  }) async {
    final Finder finder = find.text(text, skipOffstage: false);
    await tester.ensureVisible(finder);
    expect(finder, findsOne);
  }

  static FutureOr<void> ensureTextIsNotVisible({
    required WidgetTester tester,
    required String text,
  }) async {
    final Finder finder = find.text(text, skipOffstage: false);
    expect(finder, findsNothing);
  }

  static FutureOr<void> ensureTextIsVisibleExactly({
    required WidgetTester tester,
    required String text,
    required int exactly,
  }) async {
    final Finder finder = find.text(text, skipOffstage: false);
    expect(finder, findsExactly(exactly));
  }

  static FutureOr<void> ensureKeyIsVisible({
    required WidgetTester tester,
    required Key key,
  }) async {
    final Finder finder = find.byKey(key, skipOffstage: false);
    await tester.ensureVisible(finder);
    expect(finder, findsOne);
  }

  static FutureOr<void> ensureFinderIsVisible({
    required WidgetTester tester,
    required Finder finder,
  }) async {
    await tester.ensureVisible(finder);
    expect(finder, findsOne);
  }

  static FutureOr<void> ensureFinderIsVisibleAndTap({
    required WidgetTester tester,
    required Finder finder,
  }) async {
    await tester.ensureVisible(finder);
    expect(finder, findsOne);
    await tester.tap(finder);
  }

  static FutureOr<void> enterTextByFinder(
    WidgetTester tester, {
    required Finder finder,
    required String text,
  }) async {
    await tester.enterText(finder, text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await WidgetTestHelper.ensureTextIsVisible(tester: tester, text: text);
  }
}
