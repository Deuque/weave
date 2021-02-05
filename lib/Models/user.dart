class User{
  String id,fullname,email,phoneNumber, imageUrl,userName,token;
  bool emailConfirmed,phoneNumberConfirmed;

  User({this.id, this.fullname, this.email, this.phoneNumber, this.imageUrl, this.userName,this.emailConfirmed,this.phoneNumberConfirmed,this.token});
  factory User.fromMap(data)=>User(
    id: data['id'],
    fullname: data['fullname'],
    email: data['email'],
    phoneNumber: data['phoneNumber'],
    userName: data['userName'],
    emailConfirmed: data['emailConfirmed']?? false,
    phoneNumberConfirmed: data['phoneNumberConfirmed']?? false,
    token: data['token']??'',
    imageUrl: data['imageUrl']??''
  );

  toJson()=>{
    'id': id,
    'fullname': fullname,
    'email': email,
    'phoneNumber': phoneNumber,
    'userName': userName,
    'emailConfirmed': emailConfirmed,
    'phoneNumberConfirmed': phoneNumberConfirmed,
    'token': token,
    'imageUrl': imageUrl
  };
}