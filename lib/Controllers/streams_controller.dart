import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Repos/repo.dart';

final userStreamsProvider = ChangeNotifierProvider<UserStreams>((ref) => new UserStreams());

class UserStreams extends ChangeNotifier {
  List<Invite> myInvites =[];

  void startStreams() {
   UserController().getInvites().listen((event) {
     myInvites = event.docs.map((e) => Invite.fromMap(e.data())..id=e.id).toList();
     notifyListeners();
   }).onDone(() {

   });
  }
}