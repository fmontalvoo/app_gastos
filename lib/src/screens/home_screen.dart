import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_gastos/src/widgets/graph_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int currentPage = 9;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 9,
      viewportFraction: 0.4,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: _bottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          _selector(),
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 24.0,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
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

  Widget _expenses() {
    return Column(
      children: [
        Text(
          "\$1234.56",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
        ),
        Text(
          "Total expenses",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _graph() {
    return Container(
      height: 250.0,
      child: GraphWidget(),
    );
  }

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: 2,
        itemBuilder: (context, index) =>
            _item(FontAwesomeIcons.shoppingCart, "Shopping", 14, 145.12),
        separatorBuilder: (context, index) => Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height: 8.0,
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, int percent, double price) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      subtitle: Text("$percent% of expense",
          style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
      trailing: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            "\$$price",
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )),
    );
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomButton(FontAwesomeIcons.history),
            _bottomButton(FontAwesomeIcons.chartPie),
            SizedBox(width: 48.0),
            _bottomButton(FontAwesomeIcons.wallet),
            _bottomButton(Icons.settings),
          ],
        ));
  }

  Widget _bottomButton(IconData icon) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Icon(icon),
      ),
      onTap: () {},
    );
  }
}
