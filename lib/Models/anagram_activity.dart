class AnagramActivity{
  String id, word,scrambledWord, opponentAnswer, hint, time,date;
  bool userIsSender,answered,isCorrect;

  AnagramActivity({this.id, this.word, this.scrambledWord, this.opponentAnswer, this.hint, this.time, this.date,
      this.userIsSender, this.answered, this.isCorrect});
}

List<AnagramActivity> sampleAnagrams = [
  AnagramActivity(
      word: 'Hey, how are you doing',
      date: '13th Nov, 2020',
      time: '2:30pm',
      userIsSender: true,
    answered: true,isCorrect: true
  ),
  AnagramActivity(
      word: 'Mehn, i\'m alright',
      date: '13th Nov, 2020',
      time: '1:09pm',
      userIsSender: false,
      answered: true,isCorrect: false
  ),
  AnagramActivity(
      word: 'Yeah i went to the gym, what of you',
      date: '14th Nov, 2020',
      time: '7:54pm',
      userIsSender: true,
      answered: true,isCorrect: true
  ),
  AnagramActivity(
      word: 'I dont gym na, you know me',
      date: '14th Nov, 2020',
      time: '5:56pm',
      userIsSender: false,
      answered: true,isCorrect: true
  ),



];