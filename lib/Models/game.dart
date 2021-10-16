import 'package:cloud_firestore/cloud_firestore.dart';

class Game{
  String id;
  String starter;
  String toPlay;
  bool seenLastPlay;
  List<String> parties;
  List<dynamic> plays;
  Timestamp timestamp;

  Game({this.id, this.starter, this.toPlay, this.seenLastPlay, this.parties, this.plays, this.timestamp});

  Map<String,dynamic> toJson()=>{
    'id': this.id,
    'starter': this.starter,
    'toPlay': this.toPlay,
    'seenLastPlay': this.seenLastPlay,
    'parties': this.parties,
    'plays': this.plays,
    'timestamp':this.timestamp
  };

  factory Game.fromMap(Map<String,dynamic> data)=>Game(
    id: data['id']??'',
    starter: data['starter'],
    toPlay: data['toPlay'],
    seenLastPlay: data['seenLastPlay'],
    parties: List<String>.from(data['parties']),
    plays: data['plays'],
    timestamp: data['timestamp']
  );
}