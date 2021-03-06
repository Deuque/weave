import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';

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

  Future<QuerySnapshot> getUsers(){
    return userDbInstance.get();
  }

  Stream<DocumentSnapshot> userStream(String id) {
    return userDbInstance.doc(id).snapshots();
  }

  Future<DocumentReference> addOrEditInvite(Invite invite, {bool edit = false}){
    if(!edit)
      return inviteDbInstance.add(invite.toJson());
    else
      return inviteDbInstance.doc(invite.id).update(invite.toJson());
  }

  Stream<QuerySnapshot> getInvites(){
    return inviteDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }

  Future<DocumentReference> addOrEditMessage(Message message, {bool edit = false}){
    if(!edit)
      return chatDbInstance.add(message.toJson());
    else
      return chatDbInstance.doc(message.id).update(message.toJson());
  }

  Stream<QuerySnapshot> getChats(){
    return chatDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }

  Future<DocumentReference> addOrEditGame(Game game, {bool edit = false}){
    if(!edit)
      return gameDbInstance.add(game.toJson());
    else
      return gameDbInstance.doc(game.id).update(game.toJson());
  }

  Stream<QuerySnapshot> getGames(){
    return gameDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }
}
