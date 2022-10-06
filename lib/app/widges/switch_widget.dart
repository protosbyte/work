import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget(
      {Key? key,
      required this.title,
      required this.initialValue,
      this.secondaryIcon = null,
      required this.onChecked})
      : super(key: key);

  final Function(bool) onChecked;
  final String title;
  final bool initialValue;
  final Icon? secondaryIcon;

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool selectedValue = false;

  @override
  void initState() {
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _switchField(widget.title, selectedValue, widget.onChecked);
  }

  Widget _switchField(
      String title, bool initialValue, Function(bool) onChecked) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
            height: 50,
            child: SwitchListTile(
              title: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
              ),
              value: initialValue,
              onChanged: (checked) {
                onChecked(checked);
                setState(() {
                  selectedValue = checked;
                });
              },
              secondary: widget.secondaryIcon,
            )));
  }
}
