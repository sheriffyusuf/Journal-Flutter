import 'package:flutter/material.dart';
import 'package:journal/blocs/authentication_bloc.dart';
import 'package:journal/blocs/authentication_bloc_provider.dart';
import 'package:journal/blocs/home_bloc.dart';
import 'package:journal/blocs/home_bloc_provider.dart';
import 'package:journal/pages/home.dart';
import 'package:journal/pages/login.dart';
import 'package:journal/services/authentication.dart';
import 'package:journal/services/db_firestore.dart';

//BlocSupervisor.delegate = SimpleBlocDelegate();

/*    BlocProvider(
      builder:(context) => AuthenticationBloc(userRepository: userRepository)
        ..dispatch(AppStarted()),*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /* final UserRepository _userRepository;

  MyApp({Key key,@required UserRepository userRepository}): assert(userRepository!=null),_userRepository =userRepository,super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
      builder: (context,state){
        if(state is Uninitialized){
          return SplashScreen();
        }
        if (state is UnAuthenticated) {
          return Login(userRepository: _userRepository);
        }
        if(state is Authenticated){
          return Home();
        }
        return Container();
      },
      ),
    );*/
  //}
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), _authenticationService),
              uid: snapshot.data,
              child: _buildMaterialApp(Home()),
            );
          } else {
            return _buildMaterialApp(Login());
          }
        },
      ),
    );
    //_buildMaterialApp();
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
        title: 'Journal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            canvasColor: Colors.lightGreen.shade50,
            bottomAppBarColor: Colors.lightGreen,
            platform: TargetPlatform.iOS),
        home: homePage);
  }
}
