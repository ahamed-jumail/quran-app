part of 'app_bloc.dart';

abstract class AppState extends ErrorState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppError extends AppState {}


class StateData extends AppState {
  StateData({this.user});

  AppUser? user;
}
