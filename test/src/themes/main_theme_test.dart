import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/themes/main_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('themeData', () {
    test(
      'deve ser do tipo ThemeData.',
      () {
        // assert
        expect(themeData, isA<ThemeData>());
      },
    );
  });

  group('webThemeData', () {
    test(
      'deve ser do tipo ThemeData.',
      () {
        // assert
        expect(webThemeData, isA<ThemeData>());
      },
    );
  });

  group('mobileThemeData', () {
    test(
      'deve ser do tipo ThemeData.',
      () {
        // assert
        expect(mobileThemeData, isA<ThemeData>());
      },
    );
  });
}
