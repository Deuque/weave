import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/theme_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Screens/confirm_logout.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/toggle.dart';
import 'package:share/share.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File selectedImage;
  bool uploadingImage = false;

  showLogoutConfirmSheet() async {
    var result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        context: (context),
        builder: (_) => ConfirmLogout());
    return result;
  }

  selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null)
      setState(() {
        selectedImage = File(pickedFile.path);
      });
  }

  uploadImage() async {
    if (selectedImage == null || uploadingImage) return;
    setState(() {
      uploadingImage = true;
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('ProfileImages')
        .child(context.read(userProvider.state).id);
    await ref.putFile(selectedImage).then((taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      await UserController().saveUserData({'photo': url});
      setState(() {
        selectedImage = null;
      });
    }).catchError((e) => Fluttertoast.showToast(msg: e.toString()));
    setState(() {
      uploadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    spacer() => SizedBox(
          height: height * .07,
        );
    spacer2() => SizedBox(
          height: height * .02,
        );

    _profileImageWidget() => Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: selectImage,
                child: Container(
                    height: width * .3,
                    width: width * .3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              offset: Offset(2, 1.3),
                              spreadRadius: 1.6,
                              blurRadius: 2)
                        ]),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage,
                              fit: BoxFit.cover,
                            ),
                          )
                        : profileImage(context.read(userProvider.state).photo,
                            width * .3, context,
                            radius: 20, imagePadding: 15)),
              ),
              if (selectedImage != null)
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Center(
                    child: InkWell(
                      onTap: uploadImage,
                      child: Material(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(.7),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: uploadingImage
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(accentColor),
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/upload.png',
                                  height: width * .05,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        );

    List<Map<String, dynamic>> toggleData() => [
          {
            'title': 'Dark Mode',
            'toggles': ['Off', 'On'],
            'selected': context.read(themeProvider.state) ? 1 : 0,
            'onSelected': (int index) => context.read(themeProvider).toggle()
          },
          {
            'title': 'Available for Invites',
            'toggles': ['No', 'Yes'],
            'selected':
                context.read(userProvider.state).availableForInvite ? 1 : 0,
            'onSelected': (int index) {
              UserController().saveUserData({'availableForInvite': index == 1});
            }
          },
        ];
    List<Map<String, dynamic>> userSettings() => [
          {
            'title': 'Change Username',
            'onClick': () => Navigator.pushNamed(context, 'username',
                arguments: context.read(userProvider.state).username)
          },
          {
            'title': 'Add a Phone Number',
            'onClick': () => Navigator.pushNamed(context, 'phone',
                arguments: context.read(userProvider.state).phone)
          },
          {
            'title': 'Notifications',
            'onClick': () => Navigator.pushNamed(context, 'notifications')
          },
          {'title': 'Share weave with friends', 'onClick': () =>Share.share('Check out https://play.google.com/store/apps/details?id=com.dcdevs.weave_mobile', subject: 'Let\'s play a game!')},
        ];

    infoWidget(String title, Function onClick, [Color color]) => ListTile(
          onTap: onClick,
          title: Text(
            title,
            style: TextStyle(
                color: color ??
                    Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                fontSize: 14),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.3),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 20,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            _profileImageWidget(),
            spacer2(),
            Consumer(builder: (context, watch, _) {
              return Text(
                '@${watch(userProvider.state).username}',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 16),
              );
            }),
            spacer(),
            // _shareWeaveWidget()
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => Toggle(
                        title: toggleData()[i]['title'],
                        toggles: toggleData()[i]['toggles'],
                        selected: toggleData()[i]['selected'],
                        onSelected: toggleData()[i]['onSelected'],
                      ),
                  separatorBuilder: (_, i) => Divider(
                        height: 2,
                      ),
                  itemCount: toggleData().length),
            ),
            spacer2(),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => infoWidget(
                      userSettings()[i]['title'], userSettings()[i]['onClick']),
                  separatorBuilder: (_, i) => Divider(
                        height: 2,
                      ),
                  itemCount: userSettings().length),
            ),
            spacer2(),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              child: infoWidget('Logout', () async {
                var response = await showLogoutConfirmSheet();
                if (response != null && response) {
                  await UserController().signOut();
                  Navigator.pushReplacementNamed(context, 'auth');
                }
              }, error),
            ),
          ],
        ),
      ),
    );
  }
}
