import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:procrew_task_fin/data/models/user.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

abstract class AuthRepository {
  User? currentUser();

  Future<User> loginWithEmailAndPassword(String email, String password);

  Future<void> registerWithEmailAndPassword(String email, String password);

  Future<void> logout();

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<User> signInWithTwitter();
}

class FirebaseAuthRepository implements AuthRepository {
  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;

  @override
  User? currentUser() {
    firebaseAuth.User? user = _auth.currentUser;
    return user != null ? User(uid: user.uid) : null;
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    try {
      firebaseAuth.UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      firebaseAuth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw (e);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = firebaseAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebaseAuth.UserCredential result =
          await _auth.signInWithCredential(credential);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final facebookAuthCredential =
          firebaseAuth.FacebookAuthProvider.credential(
              loginResult.accessToken!.token);
      print(facebookAuthCredential.token.toString());
      firebaseAuth.UserCredential result =
          await _auth.signInWithCredential(facebookAuthCredential);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
          apiKey: 'consumer key',
          apiSecretKey: 'consumer secret',
          redirectURI: '<scheme>://');
      final twitterAuthCredential = firebaseAuth.TwitterAuthProvider.credential(
          accessToken: AuthResult().authToken!,
          secret: AuthResult().authTokenSecret!);
      firebaseAuth.UserCredential result =
          await _auth.signInWithCredential(twitterAuthCredential);
      return User(uid: result.user!.uid);
    } catch (e) {
      throw e;
    }
  }
}
