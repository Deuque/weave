import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/theme_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Screens/confirm_logout.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  showLogoutConfirmSheet() async{
    var result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top:Radius.circular(10))),
        context: (context),
        builder: (_) => ConfirmLogout());
    return result;
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
          child: Container(
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
              child: profileImage(
                  context.read(userProvider.state).photo, width * .3, context,
                  radius: 20, imagePadding: 15)),
        );

    _shareWeavWidget() => Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: accentColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/share.png',
                  color: Theme.of(context).secondaryHeaderColor,
                  height: 16,
                ),
              ],
            ),
            title: Text(
              'Share weave with friends',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor, fontSize: 16),
            ),
            trailing: Icon(
              Icons.chevron_right_outlined,
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.4),
            ),
          ),
        );

    List<Map<String, dynamic>> toggleData() => [
          {
            'title': 'Dark mode',
            'toggles': ['Off', 'On'],
            'selected': context.read(themeProvider.state) ? 1 : 0,
            'onSelected': (int index) => context.read(themeProvider).toggle()
          },
          {
            'title': 'Available for invites',
            'toggles': ['No', 'Yes'],
            'selected': 1,
            'onSelected': (int index) {}
          },
        ];
    List<Map<String, dynamic>> userSettings() => [
          {
            'title': 'Change Username',
            'onClick': () => Navigator.pushNamed(context, 'username',
                    arguments: context.read(userProvider.state).username)
          },
          {'title': 'Add a phone number', 'onClick': () => Navigator.pushNamed(context, 'phone',
              arguments: context.read(userProvider.state).phone)},
          {'title': 'Share weave with friends', 'onClick': () {}},
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
            Text(
              '@${context.read(userProvider.state).username}',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor, fontSize: 16),
            ),
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
                if(response!=null && response){
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

class Toggle extends StatefulWidget {
  final String title;
  final List<String> toggles;
  final int selected;
  final Function(int index) onSelected;

  const Toggle(
      {Key key, this.title, this.toggles, this.selected, this.onSelected})
      : super(key: key);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
            fontSize: 14),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() => index = index == 0 ? 1 : 0);
          widget.onSelected(index);
        },
        child: Container(
          width: 30,
          height: 22,
          //alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOutCirc,
                width: double.infinity,
                height: 13,
                decoration: BoxDecoration(
                  color: index == 1
                      ? accentColor.withOpacity(.2)
                      : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: AnimatedAlign(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOutCirc,
                  alignment:
                      index == 0 ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 1
                          ? accentColor.withOpacity(.7)
                          : lightGrey.withOpacity(.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
