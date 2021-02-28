class User{
  String id,email,phone, photo,username,token;

  User({this.id, this.email, this.phone, this.photo, this.username,this.token});
  factory User.fromMap(data)=>User(
    email: data['email']??'',
    phone: data['phone']??'',
    username: data['username']??'',
    token: data['token']??'',
    photo: data['photo']??''
  );

  toJson()=>{
    'id': id,
    'email': email,
    'phone': phone,
    'userName': username,
    'token': token,
    'imageUrl': photo
  };
}

List<User> contacts = [
  // User(
  //   imageUrl: 'assets/user_dummies/img1.jpg',
  //   fullname: 'Jumo Ibrahim',
  //   userName: '@jumo123',
  // ),
  // User(
  //   imageUrl: 'assets/user_dummies/img5.jpg',
  //   fullname: 'Frank Lampard',
  //   userName: '@scarytoad',
  // ),
  // User(
  //   imageUrl: 'assets/user_dummies/img3.jpg',
  //   fullname: 'Stanley Afor',
  //   userName: '@stan6969',
  // ),
  // User(
  //   imageUrl: 'assets/user_dummies/img4.jpg',
  //   fullname: 'Baba Songo',
  //   userName: '@freeboy',
  // ),
];