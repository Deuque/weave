import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Repos/repo.dart';
import 'package:http/http.dart' as http;

class UserController {
  var repo = Repo();

  String currentUserId() => repo.currentUserId();

  String defUserImage()=>Repo.defUserImage;
  String anagramImage()=>Repo.anagramImage;
  String tttImage()=>Repo.tttImage;

  Future<Map<String, dynamic>> registerUser(
      {@required email, @required password}) async {
    var userCredentials, error;
    await repo
        .registerUser(email: email, password: password)
        .then((value) => userCredentials = value)
        .catchError((e) => error = e.toString());

    return {'error': error, 'data': userCredentials};
  }

  Future<Map<String, dynamic>> loginUser(
      {@required email, @required password}) async {
    var responseData, error;
    await repo
        .loginUser(email: email, password: password)
        .then((value) => responseData = value)
        .catchError((e) => error = e.toString());

    return {'error': error, 'data': responseData};
  }

  Future<void> signOut() async{
    await saveUserData({'token':''});
    await repo.signOut();
  }

  Future<void> forgotPassword(String email) async{
    await repo.resetPassword(email);
  }

  Future<Map<String, dynamic>> saveUserData(Map<String, dynamic> data) async {
    var responseData, error;
    await repo
        .saveUserData(data)
        .then((value) => responseData = value)
        .catchError((e) => error = e.toString());

    return {'error': error, 'data': responseData};
  }

  Stream<DocumentSnapshot> userStream(String id) {
    return repo.userStream(id);
  }

  Future<bool> checkUsername(String username) async {
    var query = await repo.getUsersWithUsername(username);
    return query.docs.isNotEmpty;
  }

  Future<List<User>> getUsers() async {
    var responseData, error;
    await repo
        .getUsers()
        .then((value) => responseData = value)
        .catchError((e) => error = e.toString());
    if (error == null) {
      return (responseData as QuerySnapshot)
          .docs
          .map((e) => User.fromMap(e.data())..id = e.id)
          .toList();
    } else {
      return [];
    }
  }

  Future<void> sendInvite(Invite invite) async {
    await repo.addOrEditInvite(invite);
  }

  Future<void> editInvite(Invite invite) async {
    await repo.addOrEditInvite(invite, edit: true);
  }

  Stream<QuerySnapshot> getInvites() {
    return repo.getInvites();
  }

  Future<void> sendMessage(Message message) async {
    await repo.addOrEditMessage(message);
  }

  Future<void> editMessage(Message message) async {
    await repo.addOrEditMessage(message, edit: true);
  }
  Future<void> deleteMessages(List<Message> messages) async {
    for(Message message in messages){
      await repo.deleteMessage(message.id);
    }
  }

  Stream<QuerySnapshot> getChats() {
    return repo.getChats();
  }

  Future<void> addAnagramGame(AnagramActivity game) async {
    await repo.addOrEditAnagramGame(game);
  }

  Future<void> editAnagramGame(AnagramActivity game) async {
    await repo.addOrEditAnagramGame(game, edit: true);
  }

  Future<void> deleteAnagramGame(List<String> anagramIds)async{
    for(final id in anagramIds.reversed)
      await repo.deleteAnagramGame(id);
  }

  Stream<QuerySnapshot> getAnagramGames() {
    return repo.getAnagramGames();
  }

  Future<void> addTttGame(TictactoeActivity game) async {
    await repo.addOrEditTttGame(game);
  }

  Future<void> editTttGame(TictactoeActivity game) async {
    await repo.addOrEditTttGame(game, edit: true);
  }

  Future<void> deleteTttGame(String id)async{
    await repo.deleteTttGame(id);
  }

  Stream<QuerySnapshot> getTttGames() {
    return repo.getTttGames();
  }

  sendNotification({ String title,String body, String token, String id,  String extraData,String imageUrl}) async {
    print(token);
    final data = {
      "notification": {"body": "$body", "title": "$title"},
      "priority": "high",
      "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": id, "extraData":extraData, "status": "done"},
      "to": token
    };
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=${Repo.fcm_key}",
      },
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      print('notification sending failed '+response.body);
    }else{
      print('sent');
    }
  }
}
