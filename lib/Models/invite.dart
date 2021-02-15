class Invite {
  String sender, receiver, date;
  int gameType;

  Invite({this.sender, this.receiver, this.gameType, this.date});
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
