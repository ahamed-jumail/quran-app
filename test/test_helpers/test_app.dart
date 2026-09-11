import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/core/theme/theme.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TestApp extends StatefulWidget {
  const TestApp({
    super.key,
    required this.testWidget,
  });
  final Widget testWidget;

  @override
  TestAppState createState() => TestAppState();
}

class TestAppState extends State<TestApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    TestWidgetsFlutterBinding.instance.addObserver(this);
    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        designSize: const Size(380, 844),
        builder: (_, Widget? child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            home: widget.testWidget,
            debugShowCheckedModeBanner: false,
          );
        },
      
    );
  }
}
