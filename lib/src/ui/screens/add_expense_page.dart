import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_gastos/src/ui/widgets/category_selection.dart';

import 'package:app_gastos/src/utils/login_state.dart';

class AddExpensePage extends StatefulWidget {
  final Rect buttonRect;

  const AddExpensePage({Key key, this.buttonRect}) : super(key: key);
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _buttonAnimation;
  Animation _screenAnimation;

  String _category;
  int _value = 0;

  @override
  void initState() {
    super.initState();
    this._controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    this._buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: this._controller, curve: Curves.fastOutSlowIn));

    this._screenAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: this._controller, curve: Curves.fastOutSlowIn));

    this._controller.addListener(() {
      print(_controller.value);
      setState(() {});
    });

    this._controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) Navigator.pop(context);
    });

    this._controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0.0, h * (1 - this._screenAnimation.value)),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text('Category', style: TextStyle(color: Colors.grey)),
              actions: [
                IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => this._controller.reverse())
              ],
            ),
            body: _body(),
          ),
        ),
        _submit(),
      ],
    );
  }

  Widget _body() {
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numpad(),
        SizedBox(height: h - widget.buttonRect.top),
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
    var realValue = this._value / 100.0;
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
                    this._value = this._value ~/ 10;
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
    if (this._controller.value < 1) {
      var buttonWidth = widget.buttonRect.right - widget.buttonRect.left;
      var size = MediaQuery.of(context).size;
      return Positioned(
        top: widget.buttonRect.top,
        left: widget.buttonRect.left * (1 - this._buttonAnimation.value),
        right: (size.width - widget.buttonRect.right) *
            (1 - this._buttonAnimation.value),
        bottom: (size.height - widget.buttonRect.bottom) *
            (1 - this._buttonAnimation.value),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(
                  buttonWidth * (1 - this._buttonAnimation.value))),
        ),
      );
    } else
      return Builder(
          builder: (context) => Positioned(
                top: widget.buttonRect.top,
                left: 0.0,
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: MaterialButton(
                    child: Text(
                      "Add expense",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () {
                      // var user = Provider.of<LoginState>(context, listen: false)
                      //     .currentUser;
                      var user = context.read<LoginState>().currentUser;
                      if (this._value > 0 && this._category != "") {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('expenses')
                            .doc()
                            .set({
                          "category": this._category,
                          "value": this._value / 100,
                          "month": DateTime.now().month,
                          "day": DateTime.now().day
                        });
                        this._controller.reverse();
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
              this._value = this._value * 100;
            else
              this._value = this._value * 10 + int.parse(text);
          });
        },
      );
}
