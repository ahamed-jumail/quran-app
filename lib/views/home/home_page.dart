import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app_router.dart';
import '../../core/bloc/app_bloc/app_bloc.dart';
import '../../core/bloc/auth_bloc/auth_bloc.dart';
import '../../global_widgets/common_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppBloc appBloc;
  late final AuthBloc authBloc;

  @override
  void initState() {
    appBloc = BlocProvider.of<AppBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      authBloc.stream.listen((AuthState state) => (mounted
          ? onAuthBlocChange(context: context, state: state)
          : null));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState state) {
        return Scaffold(
          appBar: AppBar(
              title: Text('Flutter BLoC Boiler Plate',
                  style: textTheme.titleLarge)),
          body: Column(
            children: <Widget>[
              const Spacer(),
              Center(
                child: BlocBuilder<AppBloc, AppState>(
                    builder: (BuildContext context, AppState state) {
                  return Text(
                      'Welcome, ${appBloc.stateData.user?.firstname ?? ''} ${appBloc.stateData.user?.lastname ?? ''}',
                      style: textTheme.titleLarge);
                }),
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: CommonButton(
              onPressed: () {
                authBloc.add(LogOut());
              },
              text: 'Logout',
              isRedText: true,
              isLoading: state is AuthLoading,
              loadingText: 'Logging out...'),
        );
      },
    );
  }

  void onAuthBlocChange(
      {required BuildContext context, required AuthState state}) {
    switch (state.runtimeType) {
      case const (LogOutSuccess):
        context.goNamed(RouteConstants.loginPage);
    }
  }
}
