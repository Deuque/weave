import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weave/Models/user.dart';

class Activity {
  String image, username;
  String opponentId;
  User opponent;
  int gameType,unreadChat;
  bool gameTurn;
  Timestamp timestamp;
  Activity({this.image,this.username,this.gameType,this.timestamp,this.opponentId,this.opponent, this.gameTurn,this.unreadChat});


}

List<Activity> sampleActivities = [
  // Activity(
  //     image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
  //     username: '@hilary',
  //     gameType: 0,
  //     date: '13th Jan, 21',
  //     status: 1,
  //     unseenCount: 3),
  // Activity(
  //     image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
  //     username: '@donapo',
  //     gameType: 1,
  //     date: '4th Jan, 21'),
  // Activity(
  //     image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
  //     username: '@scotapu',
  //     gameType: 1,
  //     status: 1,
  //     date: '15th Feb, 21'),
  // Activity(
  //     image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
  //     username: '@deeq',
  //     gameType: 0,
  //     date: '23rd Feb, 21',
  //     unseenCount: 1),
];