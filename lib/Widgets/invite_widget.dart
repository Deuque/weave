import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class InviteLayout extends StatefulWidget {
  final Invite invite;
  final User currentUser;

  const InviteLayout({Key key, this.invite,this.currentUser}) : super(key: key);

  @override
  _InviteLayoutState createState() => _InviteLayoutState();
}

class _InviteLayoutState extends State<InviteLayout>
    with AutomaticKeepAliveClientMixin {
  User invitee;
  String currentAction = '';

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInvitee();
    updateReceiverSeen();

  }

  getInvitee() async {
    await UserController()
        .userStream(widget.invite.parties.firstWhere(
            (element) => element != context.read(userProvider.state).id))
        .first
        .then((value) => setState(() {
              invitee = User.fromMap(value.data())..id = value.id;
            }));
  }

  updateReceiverSeen()async{
    if(widget.invite.receiver==context.read(userProvider.state).id && !widget.invite.seenByReceiver){
      UserController().editInvite(widget.invite..seenByReceiver=true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    bool userIsSender =
        widget.invite.sender == context.read(userProvider.state).id;


    String date = dateFormat(DateTime.fromMillisecondsSinceEpoch(
        widget.invite.timestamp.millisecondsSinceEpoch));

    loader(Color color) => Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        );

    Widget actionWidgets() => Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              {
                'color': error,
                'text': 'Decline',
                'onClick': () async {
                  await UserController()
                      .editInvite(widget.invite..declined = true);
                  if (invitee!=null && invitee.receiveInviteNotifications && invitee.token.isNotEmpty)
                    await UserController().sendNotification(
                        title: '${widget.invite.gameType == 0 ? 'TicTacToe' : 'Anagram'} Invite',
                        body: '@${widget.currentUser.username} declined your invite😢',
                        token: invitee.token,
                        id: 'invite',
                        extraData: widget.currentUser.id,
                        imageUrl: widget.currentUser.photo.isEmpty?UserController().defUserImage():widget.currentUser.photo);
                }
              },
              {},
              {
                'color': success,
                'text': 'Accept',
                'onClick': () async {
                  await UserController()
                      .editInvite(widget.invite..accepted = true);
                  if (invitee!=null && invitee.receiveInviteNotifications && invitee.token.isNotEmpty)
                    await UserController().sendNotification(
                        title: '${widget.invite.gameType == 0 ? 'TicTacToe' : 'Anagram'} Invite',
                        body: '@${widget.currentUser.username} accepted your invite😀',
                        token: invitee.token,
                        id: 'invite',
                        extraData: widget.currentUser.id,
                        imageUrl: widget.currentUser.photo.isEmpty?UserController().defUserImage():widget.currentUser.photo);
                }
              },
            ]
                .map((e) => e.isEmpty
                    ? VerticalDivider()
                    : Expanded(
                        child: FlatButton(
                          onPressed: () async{
                            setState(() => currentAction = e['text']);
                            await e['onClick']();
                            if(mounted)setState(() => currentAction = '');
                          },
                          //color: e['color'],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                e['text'],
                                style: TextStyle(
                                  color: e['color'],
                                ),
                              ),
                              if (currentAction == e['text']) loader(e['color'])
                            ],
                          ),
                        ),
                      ))
                .toList(),
          ),
        );

    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 6, left: 6),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: userIsSender
                      ? 'You'
                      : invitee == null
                          ? '...'
                          : '@${invitee.username}',
                  style: TextStyle(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.8),
                      fontWeight:
                          userIsSender ? FontWeight.w300 : FontWeight.w500,
                      fontSize:
                          userIsSender ? size.width * .032 : size.width * .035),
                ),
                TextSpan(
                  text: ' sent ',
                  style: TextStyle(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.8),
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * .032),
                ),
                TextSpan(
                  text: userIsSender
                      ? invitee == null
                          ? '...'
                          : '@${invitee.username}'
                      : 'you',
                  style: TextStyle(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.8),
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * .035),
                ),
                TextSpan(
                  text: ' an invite ',
                  style: TextStyle(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.8),
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * .032),
                ),
              ],
            )),
            subtitle: gameTypeWidget(
                type: widget.invite.gameType,
                size: size.width * .03,
                context: context),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * .026),
                ),
                if(widget.invite.declined)Padding(
                  padding: const EdgeInsets.only(top:2.0),
                  child: Text(
                    'Declined',
                    style: TextStyle(
                      color: error,
                        fontSize: size.width * .032
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!userIsSender&& !widget.invite.declined)
            Divider(
              height: 0,
            ),
          if (!userIsSender && !widget.invite.declined) actionWidgets(),

        ],
      ),
    );
  }
}
