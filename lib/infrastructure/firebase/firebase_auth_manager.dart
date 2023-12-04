import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_on_flutter/values/app_string.dart';
import 'package:get/get.dart';

import '../../values/app_constant.dart';

class FirebaseAuthManager {
  FirebaseAuthManager._();

  static final _instance = FirebaseAuthManager._();

  static FirebaseAuthManager get instance => _instance;

  final _auth = FirebaseAuth.instance;

  /// Register new user in firebase.
  void registerUserWithEmailAndPassword(
      String email,
      String password,
      Function(String uuid) onAuthSuccess,
      Function(String error) onAuthError) async {
    try {
      if(GetPlatform.isWeb){
        await initialiseFirebase();
      }
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser.user != null) onAuthSuccess(newUser.user!.uid);
    } catch (e) {
      onAuthError(e.toString());
    }
  }

  /// Initialise firebase app
  Future<void> initialiseFirebase() async {
    if(GetPlatform.isWeb){
      return;
    }
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: AppConstants.firebaseKey,
          appId: GetPlatform.isWeb ? AppConstants.webAppId : AppConstants.appId,
          messagingSenderId: AppConstants.messagingSenderId,
          authDomain: AppConstants.authenticateDomain,
          projectId: AppConstants.projectId,
          storageBucket: '${AppConstants.projectId}.appspot.com',
          measurementId: 'G-KXCQ4YXJR2'),
      name: GetPlatform.isWeb?null:AppConstants.appName
    );
  }

  /// Login existing user in firebase.
  void loginUserWithEmailAndPassword(
      String email,
      String password,
      Function(String uuid) onAuthSuccess,
      Function(String error) onAuthError) async {
    if(GetPlatform.isWeb){
      await initialiseFirebase();
    }
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (newUser.user != null) onAuthSuccess(newUser.user!.uid);
    } catch (e) {
      onAuthError(e.toString());
    }
  }
}
