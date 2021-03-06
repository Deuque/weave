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
  var anagramGameDbInstance = FirebaseFirestore.instance.collection('AnagramGames');

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

  Future<DocumentReference> addOrEditAnagramGame(Map<String,dynamic> game, {bool edit = false}){
    if(!edit)
      return anagramGameDbInstance.add(game);
    else
      return anagramGameDbInstance.doc(game['id']).update(game);
  }

  Stream<QuerySnapshot> getAnagramGames(){
    return anagramGameDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }
}
