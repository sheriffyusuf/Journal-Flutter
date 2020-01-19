import 'package:flutter/material.dart';
import 'package:journal/blocs/authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {Key key, Widget child, this.authenticationBloc})
      : super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();

    //   (context.inheritFromWidgetOfExactType(AuthenticationBlocProvider) as AuthenticationBlocProvider);
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}
