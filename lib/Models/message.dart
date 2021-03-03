class Message{
  String message,time,date,receiver,sender;
  bool userIsSender,seenByReceiver;
  List<String> parties;

  Message({this.message, this.time, this.date, this.userIsSender, this.parties,this.seenByReceiver});
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