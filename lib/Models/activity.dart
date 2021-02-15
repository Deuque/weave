import 'dart:math';

class Activity {
  String image, username, date;
  int unseenCount,gameType,status;
  Activity({this.image,this.username,this.gameType,this.date,this.unseenCount=0,this.status=0});
}

List<Activity> sampleActivities = [
  Activity(
      image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
      username: '@hilary',
      gameType: 0,
      date: '13th Jan, 21',
      status: 1,
      unseenCount: 3),
  Activity(
      image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
      username: '@donapo',
      gameType: 1,
      date: '4th Jan, 21'),
  Activity(
      image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
      username: '@scotapu',
      gameType: 1,
      status: 1,
      date: '15th Feb, 21'),
  Activity(
      image: 'assets/user_dummies/img${1 + Random().nextInt(8)}.jpg',
      username: '@deeq',
      gameType: 0,
      date: '23rd Feb, 21',
      unseenCount: 1),
];