import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Repos/repo.dart';

final userStreamsProvider = ChangeNotifierProvider<UserStreams>((ref) => new UserStreams());

class UserStreams extends ChangeNotifier {
  List<Invite> myInvites =[];
  List<Message> myMessages = [];
  List<AnagramActivity> myAnagramGames = [];

  void startStreams() {
   UserController().getInvites().listen((event) {
     myInvites = event.docs.map((e) => Invite.fromMap(e.data())..id=e.id).toList();
     notifyListeners();
   });
   UserController().getChats().listen((event) {
     myMessages = event.docs.map((e) => Message.fromMap(e.data())..id=e.id).toList();
     notifyListeners();
   });
   UserController().getAnagramGames().listen((event) {
     myAnagramGames = event.docs.map((e) => AnagramActivity.fromMap(e.data())..id=e.id).toList();
     notifyListeners();
   });
  }

}