import 'dart:async';

import 'package:journal/services/authentication_api.dart';

class AuthenticationBloc{
  final AuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController=StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user=> _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authenticationApi){
    onAuthChanged();
  }

  void dispose(){
    _authenticationController.close();
    _logoutController.close();
  }


  void onAuthChanged(){
    authenticationApi
        .getFirebaseAuth()
        .onAuthStateChanged
        .listen((user){
      final String uid = user!= null ? user.uid : null;
      addUser.add(uid);
    });
     _logoutController.stream.listen((logout){
       if(logout == true){
         _signOut();
       }
     });
  }

  void _signOut(){
    authenticationApi.signOut();
  }

}