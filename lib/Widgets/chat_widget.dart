import 'package:flutter/material.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_clipper.dart';
import 'package:flutter_riverpod/all.dart';

class ChatLayout extends StatefulWidget {
  final Message message;
  final bool previousIsSameSender;
  final Function onWantToReply;
  final String replySenderName;

  const ChatLayout({Key key, this.message, this.previousIsSameSender,this.onWantToReply,this.replySenderName}) : super(key: key);

  @override
  _ChatLayoutState createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout>{
  bool userIsSender;
  Offset initialOffset=Offset(0, 0);
  Offset dragOffset=Offset(0, 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIsSender = widget.message.userIsSender;
    updateReceiverSeen();
  }

  updateReceiverSeen()async{
    if(widget.message.receiver==context.read(userProvider.state).id && !widget.message.seenByReceiver){
      UserController().editMessage(widget.message..seenByReceiver=true);
    }
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    replyMessageWidget(){
      return widget.message.replyMessage.isEmpty?SizedBox(height: 0,):Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Material(
          color: dark.withOpacity(.05),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.replySenderName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.78)),
                ),
                Text(
                  widget.message.replyMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.75)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onHorizontalDragUpdate: (details){
      if(userIsSender)
        if(details.delta.dx>0){
          if(dragOffset.dx<30)
            setState(() {
              // dragOffset = Offset(details.localPosition.dx-size.width, 0);
              dragOffset = Offset(dragOffset.dx+details.delta.distance, 0);
            });
        }else{
          if(dragOffset.dx>-30)
            setState(() {
              // dragOffset = Offset(details.localPosition.dx-size.width, 0);
              dragOffset = Offset(dragOffset.dx-details.delta.distance, 0);
            });
        }
      else
        if(details.delta.dx<0){
          if(dragOffset.dx>-30)
            setState(() {
              // dragOffset = Offset(details.localPosition.dx-size.width, 0);
              dragOffset = Offset(dragOffset.dx-details.delta.distance, 0);
            });
        }else{
          if(dragOffset.dx<30)
            setState(() {
              // dragOffset = Offset(details.localPosition.dx-size.width, 0);
              dragOffset = Offset(dragOffset.dx+details.delta.distance, 0);
            });
        }

      },
      onHorizontalDragEnd: (details){
            setState(() {
              dragOffset = initialOffset;
            });
            widget.onWantToReply();
      },
      child: Transform.translate(
        offset: dragOffset,
        child: Container(
          width: size.width*.7,
          alignment: userIsSender?Alignment.centerRight:Alignment.centerLeft,
          margin: EdgeInsets.only(top: widget.previousIsSameSender?0:10,bottom: 2, left: userIsSender?size.width*.15 : 10,right: userIsSender?10:size.width*.15),
          child: ClipPath(
              clipper: ChatClipper(leftSide: !userIsSender,clip: !widget.previousIsSameSender),
              child: Container(
                color: userIsSender
                    ? primary.withOpacity(.85)
                    : lightGrey.withOpacity(.15),
                padding: EdgeInsets.only(top: 7,bottom: 10,right: userIsSender?23:10,left: userIsSender?10:23),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: userIsSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.time,
                      style:
                          TextStyle(fontSize: 11, color: Theme.of(context)
                              .secondaryHeaderColor.withOpacity(.5)),
                    ),
                    SizedBox(height: 4,),
                    replyMessageWidget(),
                    Text(
                      widget.message.message,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(.78)),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}


