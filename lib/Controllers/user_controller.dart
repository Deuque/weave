import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weave/Repos/repo.dart';

class UserController{
  var repo = Repo();

  String currentUserId()=>repo.currentUserId();

  Future<Map<String,dynamic>> registerUser({@required email, @required password}) async{
    var userCredentials, error;
    await repo.registerUser(email: email,password: password).then((value) => userCredentials=value).catchError((e)=>error=e.toString()
    );

    return {'error': error, 'data':userCredentials};

  }

  Future<Map<String,dynamic>> loginUser({@required email, @required password}) async{
    var responseData, error;
    await repo.loginUser(email: email,password: password).then((value) => responseData=value).catchError((e)=>error=e.toString()
    );

    return {'error': error, 'data':responseData};

  }

  Future<Map<String,dynamic>> saveUserData(Map<String,dynamic> data) async{
    var responseData, error;
    await repo.saveUserData(data).then((value) => responseData=value).catchError((e)=>error=e.toString()
    );

    return {'error': error, 'data':responseData};
  }

  Stream<DocumentSnapshot> userStream(String id) {
    return repo.userStream(id);
  }

  Future<bool> checkUsername(String username) async{
    var query = await repo.getUsersWithUsername(username);
    return query.docs.isNotEmpty;
  }

}