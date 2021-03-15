class User{
  String id,email,phone, photo,username,token;
  bool availableForInvite;

  User({this.id, this.email, this.phone, this.photo, this.username,this.token,this.availableForInvite});
  factory User.fromMap(data)=>User(
    id: data['id']??'',
    email: data['email']??'',
    phone: data['phone']??'',
    username: data['username']??'',
    token: data['token']??'',
    photo: data['photo']??'',
    availableForInvite: data['availableForInvite']??true
  );

  toJson()=>{
    'id': id,
    'email': email,
    'phone': phone,
    'username': username,
    'token': token,
    'photo': photo,
    'availableForInvite': availableForInvite
  };
}

List<User> contacts = [
  User(
    photo: 'assets/user_dummies/img1.jpg',
    phone: '+23409876544',
    username: '@jumo123',
  ),
  User(
    photo: 'assets/user_dummies/img5.jpg',
    phone: '+23409876904',
    username: '@scarytoad',
  ),
  User(
    photo: 'assets/user_dummies/img3.jpg',
    phone: '+23409876544',
    username: '@stan6969',
  ),
  User(
    photo: 'assets/user_dummies/img4.jpg',
    phone: '+23409844124',
    username: '@freeboy',
  ),
];