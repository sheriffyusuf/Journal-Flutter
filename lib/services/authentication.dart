import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_api.dart';

class AuthenticationService implements AuthenticationApi{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth(){
    return _firebaseAuth;
  }


  Future<String> currentUserUid() async{
    FirebaseUser user= await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async{
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithEmailAndPassword({String email,String password}) async{
    FirebaseUser user= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword({String email,String password}) async{
    FirebaseUser user= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<void> sendEmailVerification() async{
    FirebaseUser user= await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async{
    FirebaseUser user= await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}