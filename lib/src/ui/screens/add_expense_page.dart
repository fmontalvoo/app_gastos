import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_gastos/src/ui/widgets/category_selection.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String _category = "";
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Category', style: TextStyle(color: Colors.grey)),
        actions: [
          IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80.0,
      child: CategorySelection(categories: {
        "Shopping": Icons.shopping_cart,
        "Alcohol": FontAwesomeIcons.beer,
        "Fast food": FontAwesomeIcons.hamburger,
        "Bills": FontAwesomeIcons.wallet,
      }, onValueChanged: (value) => this._category = value),
    );
  }

  Widget _currentValue() {
    var realValue = _value / 100.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.0),
      child: Text(
        "\$${realValue.toStringAsFixed(2)}",
        style: TextStyle(
            fontSize: 50.0,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(child: LayoutBuilder(
      builder: (context, constraints) {
        var height = constraints.biggest.height / 4;
        return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(children: [
              _button(text: '1', height: height),
              _button(text: '2', height: height),
              _button(text: '3', height: height),
            ]),
            TableRow(children: [
              _button(text: '4', height: height),
              _button(text: '5', height: height),
              _button(text: '6', height: height),
            ]),
            TableRow(children: [
              _button(text: '7', height: height),
              _button(text: '8', height: height),
              _button(text: '9', height: height),
            ]),
            TableRow(children: [
              _button(text: '.', height: height),
              _button(text: '0', height: height),
              InkWell(
                child: Container(
                    height: height,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.backspace,
                      color: Colors.grey,
                      size: 40.0,
                    )),
                onTap: () {
                  setState(() {
                    _value = _value ~/ 10;
                  });
                },
              ),
            ]),
          ],
        );
      },
    ));
  }

  Widget _submit() {
    return Builder(
        builder: (context) => Hero(
              tag: "add",
              child: Container(
                height: 70.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: MaterialButton(
                  child: Text(
                    "Add expense",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    if (_value > 0 && _category != "") {
                      FirebaseFirestore.instance
                          .collection('expenses')
                          .doc()
                          .set({
                        "category": _category,
                        "value": _value,
                        "month": DateTime.now().month,
                        "day": DateTime.now().day
                      });
                      Navigator.pop(context);
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Ingresa un valor y selecciona una categoria")));
                    }
                  },
                ),
              ),
            ));
  }

  Widget _button({String text, double height}) => InkWell(
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(fontSize: 40.0, color: Colors.grey),
          ),
        ),
        onTap: () {
          setState(() {
            if (text == '.')
              _value = _value * 100;
            else
              _value = _value * 10 + int.parse(text);
          });
        },
      );
}
