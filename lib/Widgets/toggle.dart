import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
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