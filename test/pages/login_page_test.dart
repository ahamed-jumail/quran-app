import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_bp/core/bloc/app_bloc/app_bloc.dart';
import 'package:flutter_bloc_bp/core/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc_bp/views/auth/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_helpers/test_app.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<void> pumpLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          BlocProvider<AppBloc>(create: (_) => AppBloc()),
        ],
        child: const TestApp(testWidget: LoginPage()),
      ),
    );
    await tester.pump();
  }

  group('Login Page', () {
    testWidgets('renders the static elements', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      expect(find.text('Flutter BLoC Boiler Plate'), findsOneWidget);
      expect(find.byKey(const Key('username_textfield_key')), findsOneWidget);
      expect(find.byKey(const Key('password_textfield_key')), findsOneWidget);
      expect(find.byKey(const Key('login_button_key')), findsOneWidget);
    });
  });
}
