class AnagramActivity{
  String message,time,date;
  bool userIsSender,answered,isCorrect;

  AnagramActivity({this.message, this.time, this.date, this.userIsSender,this.answered, this.isCorrect});
}

List<AnagramActivity> sampleAnagrams = [
  AnagramActivity(
      message: 'Hey, how are you doing',
      date: '13th Nov, 2020',
      time: '2:30pm',
      userIsSender: true,
    answered: true,isCorrect: true
  ),
  AnagramActivity(
      message: 'Mehn, i\'m alright',
      date: '13th Nov, 2020',
      time: '1:09pm',
      userIsSender: false,
      answered: true,isCorrect: false
  ),
  AnagramActivity(
      message: 'Yeah i went to the gym, what of you',
      date: '14th Nov, 2020',
      time: '7:54pm',
      userIsSender: true,
      answered: true,isCorrect: true
  ),
  AnagramActivity(
      message: 'I dont gym na, you know me',
      date: '14th Nov, 2020',
      time: '5:56pm',
      userIsSender: false,
      answered: true,isCorrect: true
  ),



];