
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/user.dart';

final userProvider =
StateNotifierProvider<CurrentUser>((ref) => CurrentUser());

class CurrentUser extends StateNotifier<User> {
  CurrentUser([User user]) : super(user ?? null);

  User currentUser()=>state;

  Future<User> getInitialUserData() async{
    var doc = await UserController().userStream(UserController().currentUserId()).first;
    state = User.fromMap(doc.data())..id=doc.id;
    return state;
  }

  startCurrentUserStream(){
    UserController().userStream(UserController().currentUserId()).listen((event) {
      state = User.fromMap(event.data())..id=event.id;
    });
  }

  startTokenCheck() async{
    String token = await FirebaseMessaging().getToken();
    if(state.token.isEmpty || state.token!=token){
      if(token.isNotEmpty)UserController().saveUserData({'token':token});
    }
  }




}
