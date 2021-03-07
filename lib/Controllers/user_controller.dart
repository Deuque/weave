import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Repos/repo.dart';

class UserController {
  var repo = Repo();

  String currentUserId() => repo.currentUserId();

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

  Stream<QuerySnapshot> getChats() {
    return repo.getChats();
  }

  Future<void> addAnagramGame(Map<String,dynamic> game) async {
    await repo.addOrEditAnagramGame(game);
  }

  Future<void> editAnagramGame(Map<String,dynamic> game) async {
    await repo.addOrEditAnagramGame(game, edit: true);
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

  Future<void> startNewTttGame(TictactoeActivity game)async{
    await editTttGame(game);
  }

  Stream<QuerySnapshot> getTttGames() {
    return repo.getTttGames();
  }
}
