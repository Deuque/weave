import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_widget.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, String>(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            elements: sampleMessages,
            groupBy: (element) => element.date,
            groupSeparatorBuilder: (String groupByValue) => Align(
              alignment: Alignment.topCenter,
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
              previousIsSameSender: sampleMessages.indexOf(element) != 0
                  ? sampleMessages[sampleMessages.indexOf(element) - 1]
                          .userIsSender ==
                      element.userIsSender && sampleMessages[sampleMessages.indexOf(element) - 1].date==element.date
                  : false,
            ),
            useStickyGroupSeparators: true,
            floatingHeader: true,
          ),
        ),
        TypingArea()
      ],
    );
  }
}

class TypingArea extends StatelessWidget {
  final Function(String x) onSend;

  const TypingArea({Key key, this.onSend}) : super(key: key);

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
              onPressed: null)
        ],
      ),
    );
  }
}
