import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_widget.dart';
import 'package:flutter_riverpod/all.dart';

class Chat extends StatefulWidget {
  final String opponentId;
  List<Message> messages;

  Chat({Key key, this.opponentId, this.messages}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat>{
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      controller.jumpTo(0.0);
    } catch (e) {}
  }


  onSendMessage(String text) {
    if (text.isEmpty) return;
    Message message = Message(
        message: text,
        sender: context.read(userProvider.state).id,
        receiver: widget.opponentId,
        parties: [context.read(userProvider.state).id, widget.opponentId],
        timestamp: Timestamp.now(),
        seenByReceiver: false,
    index: widget.messages.length);
    UserController().sendMessage(message);
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
              previousIsSameSender: widget.messages.indexOf(element) != widget.messages.length-1
                  ? widget.messages[widget.messages.indexOf(element) + 1]
                              .userIsSender ==
                          element.userIsSender &&
                      widget.messages[widget.messages.indexOf(element) + 1]
                              .date ==
                          element.date
                  : false,
            ),
            // useStickyGroupSeparators: true,
            // floatingHeader: true,
          ),
        ),
        TypingArea(
          onSend: onSendMessage,
        )
      ],
    );
  }
}

class TypingArea extends StatefulWidget  {
  final Function(String x) onSend;
  TypingArea({Key key, this.onSend}) : super(key: key);

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
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
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
    );
  }
}
