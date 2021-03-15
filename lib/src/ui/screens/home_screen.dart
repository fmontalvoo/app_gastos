import 'package:app_gastos/src/ui/screens/add_expense_page.dart';
import 'package:app_gastos/src/utils/add_expense_transition.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_gastos/src/ui/widgets/month_expenses.dart';

import 'package:app_gastos/src/utils/utlis.dart';
import 'package:app_gastos/src/utils/login_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var globalKey = RectGetter.createGlobalKey();
  Rect buttonRect;

  PageController _pageController;
  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot> _stream;
  GraphType _currentType = GraphType.LINES;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (context, loginState, child) {
        // var user =
        //     Provider.of<LoginState>(context, listen: false).currentUser;
        var user = context.read<LoginState>().currentUser;
        _stream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('expenses')
            .where('month', isEqualTo: currentPage + 1)
            .snapshots();

        return Scaffold(
          body: _body(),
          bottomNavigationBar: _bottomAppBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _floatingActionButton(context),
        );
      },
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return MonthExpenses(
                    graphType: this._currentType,
                    days: daysInMonth(currentPage + 1),
                    month: (currentPage + 1),
                    docs: snapshot.data.docs);
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return RectGetter(
      key: globalKey,
      child: FloatingActionButton(
        heroTag: "add",
        child: Icon(Icons.add),
        onPressed: () {
          buttonRect = RectGetter.getRectFromKey(globalKey);
          var screen = AddExpenseTransition(
              background: widget,
              screen: AddExpensePage(buttonRect: buttonRect));
          // Navigator.of(context).push(screen);
          Navigator.push(context, screen);
        },
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (index) {
          setState(() {
            // var user =
            //     Provider.of<LoginState>(context, listen: false).currentUser;
            var user = context.read<LoginState>().currentUser;
            currentPage = index;
            _stream = FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('expenses')
                .where('month', isEqualTo: currentPage + 1)
                .snapshots();
          });
        },
        controller: _pageController,
        children: [
          _selectorItem("Enero", 0),
          _selectorItem("Febrero", 1),
          _selectorItem("Marzo", 2),
          _selectorItem("Abril", 3),
          _selectorItem("Mayo", 4),
          _selectorItem("Junio", 5),
          _selectorItem("Julio", 6),
          _selectorItem("Agosto", 7),
          _selectorItem("Septiembre", 8),
          _selectorItem("Octubre", 9),
          _selectorItem("Noviembre", 10),
          _selectorItem("Diciembre", 11),
        ],
      ),
    );
  }

  Widget _selectorItem(String name, int index) {
    var _alignment;
    if (index == currentPage)
      _alignment = Alignment.center;
    else if (index > currentPage)
      _alignment = Alignment.centerRight;
    else
      _alignment = Alignment.centerLeft;

    final selected = TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueGrey);
    final unselected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.withOpacity(0.4));

    return Align(
        alignment: _alignment,
        child: Text(
          name,
          style: (index == currentPage) ? selected : unselected,
        ));
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomButton(FontAwesomeIcons.chartLine, () {
              setState(() {
                this._currentType = GraphType.LINES;
              });
            }),
            _bottomButton(FontAwesomeIcons.chartPie, () {
              setState(() {
                this._currentType = GraphType.PIE;
              });
            }),
            SizedBox(width: 48.0),
            _bottomButton(FontAwesomeIcons.wallet, () {}),
            _bottomButton(Icons.settings, () {}),
          ],
        ));
  }

  Widget _bottomButton(IconData icon, void Function() onTap) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Icon(icon),
      ),
      onTap: onTap,
    );
  }
}
