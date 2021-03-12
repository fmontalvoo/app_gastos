import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const Category({Key key, this.name, this.icon, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: this.selected ? Colors.blueAccent : Colors.grey,
                    width: this.selected ? 3.0 : 1.0)),
            child: Icon(icon),
          ),
          Text(name)
        ],
      ),
    );
  }
}
