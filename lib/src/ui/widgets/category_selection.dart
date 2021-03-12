import 'package:flutter/material.dart';

import 'package:app_gastos/src/ui/widgets/category.dart';

class CategorySelection extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;

  CategorySelection({Key key, this.categories, this.onValueChanged})
      : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  String _currentItem = "Shopping";
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach((name, icon) => widgets.add(GestureDetector(
          onTap: () {
            setState(() {
              this._currentItem = name;
              widget.onValueChanged(name);
            });
          },
          child: Category(
            name: name,
            icon: icon,
            selected: name == this._currentItem,
          ),
        )));
    return ListView(
      children: widgets,
      scrollDirection: Axis.horizontal,
    );
  }
}
