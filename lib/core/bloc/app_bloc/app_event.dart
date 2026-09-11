part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class SaveCurrentUser extends AppEvent {

  SaveCurrentUser({this.user});
  final AppUser? user;
}
