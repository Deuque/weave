import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weave/Controllers/contacts_controller.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

enum SelectUserType { single, multiple }

class SelectUser extends StatefulWidget {
  final SelectUserType selectUserType;
  final List<User> selectedUsers;
  final String title;

  SelectUser({Key key, this.selectUserType, this.selectedUsers, this.title})
      : super(key: key);

  @override
  _SelectUserState createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  List<User> selectedUsers = [];
  StreamController<List<User>> selectedUsersHorizontalController =
      new StreamController();
  FocusNode searchFocusNode = new FocusNode();
  bool textEntered=false;
  List<User> weaveUsers=[];
  List<User> filteredWeaveUsers=[];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeaveUsers();
    selectedUsers = widget.selectedUsers;
    selectedUsersHorizontalController.sink.add(selectedUsers);
    searchController.addListener(() {
      if(searchController.text.isEmpty && textEntered){
        setState(() {
          textEntered=false;
        });
      }
      if(searchController.text.isNotEmpty && !textEntered){
        setState(() {
          textEntered=true;
        });
      }

      if(searchController.text.isNotEmpty){
        performSearch(searchController.text);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedUsersHorizontalController.close();
    super.dispose();
  }

  performSearch(String text){
    setState(() {
      filteredWeaveUsers=[];
    });
    String ntext = text.replaceAll('@', '');
    if(ntext.isEmpty)return;

    filteredWeaveUsers = weaveUsers.where((element) => element.username.toLowerCase().contains(ntext.toLowerCase())).toList();
    setState(() {
    });
  }

  getWeaveUsers() async{
   weaveUsers = await UserController().getUsers();
   weaveUsers=weaveUsers.where((element) => element.id!=context.read(userProvider.state).id).toList();
   setState(() {

   });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    _space() {
      return SizedBox(
        height: 20,
      );
    }

    _searchBar() {
      return PreferredSize(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * .02),
          child: TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.9),
            ),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintText: 'Enter @weave username',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  size: 17,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
      );
    }

    _selectedUsersHorizontalLayout() {
      return StreamBuilder<List<User>>(
          stream: selectedUsersHorizontalController.stream,
          builder: (_, snapshot) {
            if (snapshot.data == null || snapshot.data.isEmpty)
              return SizedBox(
                height: 0,
              );

            return SizedBox(
              height: 90,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: snapshot.data
                    .map((e) => Container(
                          width: width * .2,
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    profileImage(
                                      e.photo,
                                      width * .1,
                                      context,
                                      imagePadding: 5
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedUsers.removeWhere((item) =>
                                                item.username == e.username);
                                          });
                                          selectedUsersHorizontalController.sink
                                              .add(selectedUsers);
                                        },
                                        child: Material(
                                          shape: CircleBorder(),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Material(
                                              shape: CircleBorder(),
                                              color: lightGrey.withOpacity(.1),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: width * .025,
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                e.username,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            );
          });
    }

    return GestureDetector(
      onTap: () {
        if (searchFocusNode.hasFocus) searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 120,
          title: Text(
            widget.title,
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          elevation: 5,
          shadowColor: Theme.of(context).backgroundColor.withOpacity(.4),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context, selectedUsers),
              icon: Icon(
                Icons.clear,
                size: 16,
                color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
              ),
            )
          ],
          bottom: _searchBar(),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: width * .05,
              right: width * .05,
              top: height * .02,
              bottom: height * .02),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectedUsersHorizontalLayout(),
              _space(),
              textEntered ? UsersOnWeave(
                key: Key(filteredWeaveUsers.toString()),
                usersOnWeave: filteredWeaveUsers,
                selected: (User user) => selectedUsers
                    .map((e) => e.username)
                    .contains(user.username),
                onClick: (User user) {
                  widget.selectUserType == SelectUserType.single
                      ? Navigator.pop(context, [user])
                      : setState(() {
                    if (selectedUsers
                        .map((e) => e.username)
                        .toList()
                        .contains(user.username)) {
                      selectedUsers.removeWhere(
                              (e) => e.username == user.username);
                    } else {
                      selectedUsers.add(user);
                    }
                  });
                  selectedUsersHorizontalController.sink.add(selectedUsers);
                },
                selectUserType: widget.selectUserType,
              ):ContactsOnWeave(
                selected: (User user) => selectedUsers
                    .map((e) => e.username)
                    .contains(user.username),
                onClick: (User user) {
                  widget.selectUserType == SelectUserType.single
                      ? Navigator.pop(context, [user])
                      : setState(() {
                          if (selectedUsers
                              .map((e) => e.username)
                              .toList()
                              .contains(user.username)) {
                            selectedUsers.removeWhere(
                                (e) => e.username == user.username);
                          } else {
                            selectedUsers.add(user);
                          }
                        });
                  selectedUsersHorizontalController.sink.add(selectedUsers);
                },
                selectUserType: widget.selectUserType,
              ),
              if (widget.selectUserType == SelectUserType.multiple)
                actionButton('DONE', true, false,
                    () => Navigator.pop(context, selectedUsers), context),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactsOnWeave extends StatefulWidget {
  bool Function(User x) selected;
  Function(User x) onClick;
  SelectUserType selectUserType;

  ContactsOnWeave({Key key, this.selected, this.onClick, this.selectUserType})
      : super(key: key);

  @override
  _ContactsOnWeaveState createState() => _ContactsOnWeaveState();
}

class _ContactsOnWeaveState extends State<ContactsOnWeave> {
  StreamController<List<User>> allUsersController = new StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    allUsersController.close();
    super.dispose();
  }

  Future<void> getAllUsers([bool refresh]) {
    context.read(contactsProvider).getContactsOnWeave(refresh).then((value) {
      allUsersController.sink.add(value);
      if(refresh!=null && refresh){
        Fluttertoast.showToast(msg: 'Refreshed weave contacts');
      }
    });
    // allUsersController.sink.add(contacts);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    _space() {
      return SizedBox(
        height: 20,
      );
    }

    _allUsersLayout() {
      return Expanded(
        child: StreamBuilder<List<User>>(
            stream: allUsersController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        backgroundColor: lightGrey.withOpacity(.6),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primary.withOpacity(.87)),
                        strokeWidth: 1.7,
                      )),
                );
              if (snapshot.hasData && snapshot.data.isEmpty)
                return emptyWidget(
                    image: 'assets/images/emptySearch.png', size: width * .2);
              return ListView(
                  padding: EdgeInsets.only(top: 20),
                  children: snapshot.data
                      .map(
                        (user) => UserWidget(
                            user: user,
                            selected: widget.selected(user),
                            showNumber: true,
                            onClick: () => widget.onClick(user)),
                      )
                      .toList());
            }),
      );
    }

    _addPhoneLayout() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: accentColor),
              margin: EdgeInsets.only(right: 10),
            ),
            Expanded(
              child: Text(
                'Add a phone number so your contacts can see you too',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pushNamed(context, 'phone'),
              child: Text(
                'Add number',
                style: TextStyle(color: accentColor, fontSize: 13),
              ),
            )
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Weave Contacts',
                style: TextStyle(color: primary, fontSize: 15),
              ),
              IconButton(
                  icon: Image.asset(
                    'assets/images/refresh.png',
                    height: 14,
                    color: Theme.of(context)
                        .secondaryHeaderColor
                        .withOpacity(.6),
                  ),
                  onPressed: ()=>getAllUsers(true)),
            ],
          ),
          _allUsersLayout(),
          _space(),
          Consumer(builder: (context, watch, _) {
            User currentUser = watch(userProvider.state);
            return currentUser.phone.isEmpty
                ? _addPhoneLayout()
                : SizedBox(
                    height: 0,
                  );
          })
        ],
      ),
    );
  }
}

class UsersOnWeave extends StatefulWidget {
  List<User> usersOnWeave;
  bool Function(User x) selected;
  Function(User x) onClick;
  SelectUserType selectUserType;

  UsersOnWeave({Key key, this.usersOnWeave, this.selected, this.onClick, this.selectUserType})
      : super(key: key);

  @override
  _UsersOnWeaveState createState() => _UsersOnWeaveState();
}

class _UsersOnWeaveState extends State<UsersOnWeave> {
  StreamController<List<User>> allUsersController = new StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allUsersController.sink.add(widget.usersOnWeave);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    allUsersController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    _space() {
      return SizedBox(
        height: 20,
      );
    }

    _allUsersLayout() {
      return Expanded(
        child: StreamBuilder<List<User>>(
            stream: allUsersController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        backgroundColor: lightGrey.withOpacity(.6),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primary.withOpacity(.87)),
                        strokeWidth: 1.7,
                      )),
                );
              if (snapshot.hasData && snapshot.data.isEmpty)
                return emptyWidget(
                    image: 'assets/images/emptySearch.png', size: width * .2);
              return ListView(
                  padding: EdgeInsets.zero,
                  children: snapshot.data
                      .map(
                        (user) => UserWidget(
                        user: user,
                        selected: widget.selected(user),
                        onClick: () => widget.onClick(user)),
                  )
                      .toList());
            }),
      );
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search results',
            style: TextStyle(color: primary, fontSize: 15),
          ),
          _space(),
          _allUsersLayout(),
        ],
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  final User user;
  final bool selected,showNumber;
  final Function onClick;

  const UserWidget({Key key, this.user, this.selected = false, this.showNumber=false, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(showNumber||!user.availableForInvite);
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        !user.availableForInvite?Fluttertoast.showToast(msg: '@${user.username} is unavailable') : onClick();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          //onTap: ()=>Navigator.pop(context,user),
          leading: profileImage(user.photo, size.width * .08, context),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${user.username}',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: size.width * .035,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          subtitle: showNumber||!user.availableForInvite ? Text.rich(
            TextSpan(
              children: [
                if(showNumber)
                  TextSpan(
                    text: user.phone,
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
                        fontSize: size.width * .03,
                        fontWeight: FontWeight.w400),
                  ),
                TextSpan(
                  text: user.availableForInvite?'':'Unavailable',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.4),
                      fontStyle: FontStyle.italic,
                      fontSize: size.width * .03,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ) : null,
          trailing: selected
              ? Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 14,
                )
              : SizedBox(height: 0),
        ),
      ),
    );
  }
}
