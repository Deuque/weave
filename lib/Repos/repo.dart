import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';

class Repo {
  static const fcm_key = 'AAAAQ5EsAiY:APA91bG0H1YTsFNipaGBEfmFa2zi_R2KYYhigtjPyQMDLtkJ0LDspEWkzFdNXVRqI_ZfPUwIkd28rsEQAIXfIoAOi4nxaBg8C00B7ncVDORdmp7Ntzxla3b1ttOma3EwHMzgEz8WNZ6K';
  static const defUserImage = 'https://firebasestorage.googleapis.com/v0/b/weave-4ee05.appspot.com/o/user.png?alt=media&token=aeee4727-60a1-44fd-94a3-2882d4d3a8c9';
  static const anagramImage = 'https://firebasestorage.googleapis.com/v0/b/weave-4ee05.appspot.com/o/anagram.png?alt=media&token=e423d2a6-bb45-4be5-89a7-8678e57c08cc';
  static const tttImage = 'https://firebasestorage.googleapis.com/v0/b/weave-4ee05.appspot.com/o/tictactoe.png?alt=media&token=e152018b-4d75-4861-970c-1197a62e72db';
  var authInstance = FirebaseAuth.instance;
  var userDbInstance = FirebaseFirestore.instance.collection('Users');
  var weaveDbInstance = FirebaseFirestore.instance.collection('Weaves');
  var inviteDbInstance = FirebaseFirestore.instance.collection('Invites');
  var chatDbInstance = FirebaseFirestore.instance.collection('Chats');
  var anagramGameDbInstance = FirebaseFirestore.instance.collection('AnagramGames');
  var tttGameDbInstance = FirebaseFirestore.instance.collection('TictactoeGames');

  currentUserId()=>authInstance.currentUser?.uid;

  registerUser({@required email, @required password}) {
    return authInstance.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  loginUser({@required email, @required password}) {
    return  authInstance.signInWithEmailAndPassword(
        email: email, password: password);
  }

  signOut(){
    return authInstance.signOut();
  }

  resetPassword(String email){
    return authInstance.sendPasswordResetEmail(email: email);
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

  Future<dynamic> addOrEditInvite(Invite invite, {bool edit = false}){
    if(!edit)
      return inviteDbInstance.add(invite.toJson());
    else
      return inviteDbInstance.doc(invite.id).update(invite.toJson());
  }

  Stream<QuerySnapshot> getInvites(){
    return inviteDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }

  Future<dynamic> addOrEditMessage(Message message, {bool edit = false}){
    if(!edit)
      return chatDbInstance.add(message.toJson());
    else
      return chatDbInstance.doc(message.id).update(message.toJson());
  }

  Future<void> deleteMessage(String id){
    return chatDbInstance.doc(id).delete();
  }

  Stream<QuerySnapshot> getChats(){
    return chatDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }

  Future<dynamic> addOrEditAnagramGame(AnagramActivity game, {bool edit = false}){
    if(!edit)
      return anagramGameDbInstance.add(game.toJson());
    else
      return anagramGameDbInstance.doc(game.id).update(game.toJson());
  }

  Future<void> deleteAnagramGame(String id){
    return anagramGameDbInstance.doc(id).delete();
  }

  Stream<QuerySnapshot> getAnagramGames(){
    return anagramGameDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }

  Future<dynamic> addOrEditTttGame(TictactoeActivity game, {bool edit = false}){
    if(!edit)
      return tttGameDbInstance.add(game.toJson());
    else
      return tttGameDbInstance.doc(game.id).update(game.toJson());
  }

  Future<void> deleteTttGame(String id){
    return tttGameDbInstance.doc(id).delete();
  }

  Stream<QuerySnapshot> getTttGames(){
    return tttGameDbInstance.where('parties',arrayContains: currentUserId()).snapshots();
  }
}
