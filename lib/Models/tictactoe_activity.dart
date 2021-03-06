import 'package:cloud_firestore/cloud_firestore.dart';

class TictactoeActivity{
  String id,sender;
  List<Map<String,dynamic>> plays;
  List<String> parties;
  int index;
  bool seenByReceiver;
  Timestamp timestamp;

  TictactoeActivity({this.id, this.sender, this.plays, this.parties, this.index,this.seenByReceiver,
      this.timestamp});

  factory TictactoeActivity.fromMap(Map<String,dynamic> data)=>TictactoeActivity(
    id: data['id']??'',
    plays: List<Map<String,dynamic>>.from(data['plays']),
    parties: List<String>.from(data['parties']),
    index: data['index'],
    sender: data['sender'],
    seenByReceiver: data['seenByReceiver'],
    timestamp: data['timestamp']
  );

  Map<String,dynamic> toJson()=>{
    'id':id,
    'sender':sender,
    'plays':plays,
    'parties':parties,
    'index':index,
    'seenByReceiver':seenByReceiver,
    'timestamp':timestamp
  };
}