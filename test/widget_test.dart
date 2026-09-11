import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';
import 'package:quran_app/app.dart';
import 'package:quran_app/core/bloc/app_bloc/app_bloc.dart';
import 'package:quran_app/core/bloc/auth_bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app loads', (WidgetTester tester) async {
    // REQUIRED for plugins that rely on WidgetsBinding
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // App is a MaterialApp.router; it only needs the blocs main.dart provides.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
          BlocProvider<AppBloc>(create: (_) => AppBloc()),
        ],
        child: const App(),
      ),
    );

    await tester.pump();

    expect(find.byType(App), findsOneWidget); // sanity check
  });
}
