import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:app_gastos/src/ui/widgets/graph_widget.dart';

class MonthExpenses extends StatefulWidget {
  final List<DocumentSnapshot> docs;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;

  MonthExpenses({Key key, int days, this.docs})
      : total = docs.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List.generate(
            days,
            (index) => docs
                .where((doc) => doc['day'] == index + 1)
                .map((doc) => doc['value'])
                .fold(0.0, (a, b) => a + b)),
        categories = docs.fold({}, (Map<String, double> map, doc) {
          if (!map.containsKey(doc['category'])) map[doc['category']] = 0.0;
          map[doc['category']] += doc['value'];
          return map;
        }),
        super(key: key);
  @override
  _MonthExpensesState createState() => _MonthExpensesState();
}

class _MonthExpensesState extends State<MonthExpenses> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        _expenses(),
        _graph(),
        Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height: 24.0,
        ),
        _list(),
      ],
    ));
  }

  Widget _expenses() {
    return Column(
      children: [
        Text(
          "\$${widget.total.toStringAsFixed(2)}",
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
      child: GraphWidget(data: widget.perDay),
    );
  }

  Widget _list() {
    var categories = widget.categories;
    return Expanded(
      child: ListView.separated(
        itemCount: categories.keys.length,
        itemBuilder: (context, index) {
          var key = categories.keys.elementAt(index);
          var data = categories[key];
          var percent = 100 * data ~/ widget.total;
          return _item(FontAwesomeIcons.shoppingCart, key, percent, data);
        },
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
            "\$${price.toStringAsFixed(2)}",
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )),
    );
  }
}
