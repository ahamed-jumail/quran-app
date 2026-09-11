import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_router.dart';
import 'core/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (BuildContext context, Widget? widget) {
        ScreenUtil.init(
          context,
          designSize: const Size(380, 844),
          minTextAdapt: true,
        );

        return Theme(
          data: AppTheme.lightTheme,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: widget ?? Container(),
          ),
        );
      },
      routerConfig: GoRouterInit.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
