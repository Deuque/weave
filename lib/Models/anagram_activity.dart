import 'package:cloud_firestore/cloud_firestore.dart';

class AnagramActivity{
  String id, word,scrambledWord, opponentAnswer, hint,type,date,sender;
  bool userIsSender,answered,isCorrect,seenByReceiver;
  List<String> parties;
  Timestamp timestamp;
  int index;

  AnagramActivity({this.id,this.index, this.word, this.type, this.date, this.scrambledWord, this.opponentAnswer, this.hint,
      this.userIsSender,this.parties, this.answered, this.isCorrect,this.timestamp,this.sender,this.seenByReceiver});

  Map<String,dynamic> toJson()=>{
    'id':id,
    'word':word,
    'scrambledWord':scrambledWord,
    'opponentAnswer':opponentAnswer,
    'hint':hint,
    'answered':answered,
    'timestamp':timestamp,
    'sender':this.sender,
    'parties': this.parties,
    'seenByReceiver': this.seenByReceiver,
    'index':this.index
  };

  factory AnagramActivity.fromMap(Map<String,dynamic> data)=>AnagramActivity(
    id: data['id'],
    word: data['word'],
    scrambledWord: data['scrambledWord'],
    opponentAnswer: data['opponentAnswer'],
    hint: data['hint'],
    answered: data['answered'],
    timestamp: data['timestamp'],
    sender: data['sender'],
    isCorrect: !data['answered']??false?false:data['opponentAnswer']==data['word'],
    seenByReceiver: data['seenByReceiver'],
      parties: List<String>.from(data['parties']),
    index: data['index']
  );
}

List<AnagramActivity> sampleAnagrams = [
  // AnagramActivity(
  //     word: 'Hey, how are you doing',
  //     date: '13th Nov, 2020',
  //     time: '2:30pm',
  //     userIsSender: true,
  //   answered: true,isCorrect: true
  // ),
  // AnagramActivity(
  //     word: 'Mehn, i\'m alright',
  //     date: '13th Nov, 2020',
  //     time: '1:09pm',
  //     userIsSender: false,
  //     answered: true,isCorrect: false
  // ),
  // AnagramActivity(
  //     word: 'Yeah i went to the gym, what of you',
  //     date: '14th Nov, 2020',
  //     time: '7:54pm',
  //     userIsSender: true,
  //     answered: true,isCorrect: true
  // ),
  // AnagramActivity(
  //     word: 'I dont gym na, you know me',
  //     date: '14th Nov, 2020',
  //     time: '5:56pm',
  //     userIsSender: false,
  //     answered: true,isCorrect: true
  // ),



];