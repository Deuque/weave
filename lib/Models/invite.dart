import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  String id,sender, receiver,date;
  List<String> parties;
  int gameType;
  bool accepted,declined,seenByReceiver;
  Timestamp timestamp;

  Invite({this.id, this.sender, this.receiver, this.gameType, this.date, this.parties, this.accepted, this.declined, this.seenByReceiver, this.timestamp});

  Map<String,dynamic> toJson()=>{
    'id': this.id,
    'sender': this.sender,
    'receiver': this.receiver,
    'parties': this.parties,
    'gameType': this.gameType,
    'timestamp': this.timestamp,
    'accepted': this.accepted,
    'declined': this.declined,
    'seenByReceiver': this.seenByReceiver
  };

  factory Invite.fromMap(Map<String,dynamic> data)=>Invite(
    id: data['id']??'',
    sender: data['sender'],
    receiver: data['receiver'],
    parties: List<String>.from(data['parties']),
    gameType: data['gameType'],
    timestamp: data['timestamp'],
    accepted: data['accepted']??false,
    declined: data['declined']??false,
    seenByReceiver: data['seenByReceiver']??false
  );
}

List<Invite> sampleInvites = [
  Invite(
      sender: '@deeq', receiver: '@hilary', gameType: 0, date: '13th Jan, 21'),
  Invite(sender: '@ragea', receiver: '@deeq', gameType: 1, date: '4th Jan, 21'),
  Invite(
      sender: '@mariam', receiver: '@deeq', gameType: 1, date: '15th Feb, 21'),
  Invite(
      sender: '@deeq', receiver: '@stanley', gameType: 0, date: '23rd Feb, 21'),
];
