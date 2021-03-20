import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_widget.dart';
import 'package:flutter_riverpod/all.dart';

class Chat extends StatefulWidget {
  final User opponent;
  List<Message> messages;

  Chat({Key key, this.opponent, this.messages}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController controller = new ScrollController();
  Message replying;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      controller.jumpTo(0.0);
    } catch (e) {}
  }

  onSendMessage(String text) async{
    if (text.isEmpty) return;
    Message message = Message(
      message: text,
      sender: context.read(userProvider.state).id,
      receiver: widget.opponent.id,
      parties: [context.read(userProvider.state).id, widget.opponent.id],
      timestamp: Timestamp.now(),
      seenByReceiver: false,
      index: widget.messages.length,
      replyMessage: replying == null ? '' : replying.message,
      replySender: replying == null ? '' : replying.sender,
      replyId: replying == null ? '' : replying.id,
    );
    await UserController().sendMessage(message).then((value) =>setState(()=>replying=null));
    if (widget.opponent.receiveMessageNotifications && widget.opponent.token.isNotEmpty)
      await UserController().sendNotification(
          title: '@${context.read(userProvider.state).username}',
          body: '${message.message}',
          token: widget.opponent.token,
          id: 'chat',
          extraData: context.read(userProvider.state).id,
      imageUrl: context.read(userProvider.state).photo.isEmpty?UserController().defUserImage():context.read(userProvider.state).photo);
  }

  onWantToReply(Message message) {
    setState(() {
      replying = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = new ScrollController();

    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, String>(
            sort: false,
            order: GroupedListOrder.DESC,
            controller: controller,
            reverse: true,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 15),
            elements: widget.messages,
            groupBy: (element) => element.date,
            groupSeparatorBuilder: (String groupByValue) => Align(
              alignment: Alignment.center,
              child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      groupByValue,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: lightGrey.withOpacity(.5)),
                    ),
                  )),
            ),
            itemBuilder: (context, Message element) => ChatLayout(
              message: element,
              previousIsSameSender:
                  widget.messages.indexOf(element) != widget.messages.length - 1
                      ? widget.messages[widget.messages.indexOf(element) + 1]
                                  .userIsSender ==
                              element.userIsSender &&
                          widget.messages[widget.messages.indexOf(element) + 1]
                                  .date ==
                              element.date
                      : false,
              onWantToReply: () => onWantToReply(element),
              replySenderName: element.replyMessage.isEmpty?'':element.replySender==widget.opponent.id?'@${widget.opponent.username}':'You',
            ),
            // useStickyGroupSeparators: true,
            // floatingHeader: true,
          ),
        ),
        TypingArea(
            onSend: onSendMessage,
            replying: replying,
            cancelReplying: () => setState(() => replying = null))
      ],
    );
  }
}

class TypingArea extends StatefulWidget {
  final Function(String x) onSend;
  final Message replying;
  final Function cancelReplying;

  TypingArea({Key key, this.onSend, this.replying, this.cancelReplying})
      : super(key: key);

  @override
  _TypingAreaState createState() => _TypingAreaState();
}

class _TypingAreaState extends State<TypingArea> {
  TextEditingController messageController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor.withOpacity(.2),
        borderRadius: BorderRadius.circular(widget.replying != null ? 15 : 30),
      ),
      child: Column(
        children: [
          if (widget.replying != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                top: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 2,
                    height: 35,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: lightGrey.withOpacity(.25),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Replying',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 10,
                              color: accentColor),
                        ),
                        Text(
                          widget.replying.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withOpacity(.7)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: lightGrey.withOpacity(.3),
                        size: 13,
                      ),
                      onPressed: widget.cancelReplying)
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 8,
                  style: TextStyle(
                      fontSize: 14.5,
                      color: Theme.of(context).secondaryHeaderColor),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Say something...',
                      hintStyle: TextStyle(
                          fontSize: 14, color: lightGrey.withOpacity(.7))),
                ),
              ),
              IconButton(
                  icon: Image.asset(
                    'assets/images/send.png',
                    height: 16,
                    color: primary,
                  ),
                  onPressed: () {
                    widget.onSend(messageController.value.text.trim());
                    messageController.clear();
                  })
            ],
          ),
        ],
      ),
    );
  }
}
