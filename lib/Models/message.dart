import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String id, message,time,date,receiver,sender;
  String replyId; String replyMessage;String replySender;
  bool userIsSender,seenByReceiver;
  List<String> parties;
  Timestamp timestamp;
  int index;


  Message({this.id, this.message, this.time, this.date, this.sender, this.receiver, this.replyId, this.replyMessage, this.replySender, this.userIsSender, this.parties, this.seenByReceiver, this.timestamp,this.index});

  Map<String,dynamic> toJson()=>{
    'id':this.id,
    'message':this.message,
    'receiver':this.receiver,
    'sender':this.sender,
    'replyId':this.replyId,
    'replyMessage':this.replyMessage,
    'replySender': this.replySender,
    'seenByReceiver':this.seenByReceiver,
    'parties': this.parties,
    'timestamp': this.timestamp,
    'index': this.index,

  };

  factory Message.fromMap(Map<String,dynamic> data)=>Message(
    id: data['id']??'',
    message: data['message'],
    receiver: data['receiver'],
    sender: data['sender'],
    replyId: data['replyId']??'',
    replyMessage: data['replyMessage']??'',
    replySender: data['replySender']??'',
    seenByReceiver: data['seenByReceiver'],
    parties: List<String>.from(data['parties']),
    timestamp: data['timestamp'],
    index: data['index'],

  );

}

List<Message> sampleMessages = [
  Message(
      message: 'Hey, how are you doing',
      date: '13th Nov, 2020',
      time: '2:30pm',
      userIsSender: true
  ),
  Message(
      message: 'Mehn, i\'m alright',
      date: '13th Nov, 2020',
      time: '1:09pm',
      userIsSender: false
  ),
  Message(
      message: 'I saw you yesterday, are you alright',
      date: '14th Nov, 2020',
      time: '4:56pm',
      userIsSender: false
  ),
  Message(
      message: 'Yeah i went to the gym, what of you',
      date: '14th Nov, 2020',
      time: '7:54pm',
      userIsSender: true
  ),
  Message(
      message: 'I dont gym na, you know me',
      date: '14th Nov, 2020',
      time: '5:56pm',
      userIsSender: true
  ),
  Message(
      message: 'I dont gym na, you know me',
      date: '14th Nov, 2020',
      time: '5:56pm',
      userIsSender: true
  ),
  Message(
      message: 'Hey, how are you doing',
      date: '15th Nov, 2020',
      time: '2:30pm',
      userIsSender: false
  ),
  Message(
      message: 'Mehn, i\'m alright',
      date: '15th Nov, 2020',
      time: '1:09pm',
      userIsSender: false
  ),
  Message(
      message: 'I saw you yesterday, are you alright',
      date: '15th Nov, 2020',
      time: '4:56pm',
      userIsSender: true
  ),
  Message(
      message: 'Yeah i went to the gym, what of you',
      date: '15th Nov, 2020',
      time: '7:54pm',
      userIsSender: false
  ),

];