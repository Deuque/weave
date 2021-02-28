import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Repo {
  var authInstance = FirebaseAuth.instance;
  var userDbInstance = FirebaseFirestore.instance.collection('Users');
  var weaveDbInstance = FirebaseFirestore.instance.collection('Weaves');
  var inviteDbInstance = FirebaseFirestore.instance.collection('Invites');
  var chatDbInstance = FirebaseFirestore.instance.collection('Chats');
  var gameDbInstance = FirebaseFirestore.instance.collection('Games');

  currentUserId()=>authInstance.currentUser?.uid;

  registerUser({@required email, @required password}) {
    return authInstance.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  loginUser({@required email, @required password}) {
    return  authInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  saveUserData(Map<String,dynamic> data){
    return  userDbInstance.doc(currentUserId()).set(data, SetOptions(merge: true));
  }

  Future<QuerySnapshot> getUsersWithUsername(String username){
    return userDbInstance.where('username',isEqualTo: username).get();
  }
  Stream<DocumentSnapshot> userStream(String id) {
    return userDbInstance.doc(id).snapshots();
  }
}
