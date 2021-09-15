import 'dart:isolate';

import 'package:flutter/services.dart';

import 'widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  // headline6 the same as title
                  fontFamily: 'OpenSans',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      // headline6 the same as title
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // final List<Transaction> transactions = [
  //   Transaction(
  //       id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
  //   Transaction(
  //       id: 't2', title: 'New Short', amount: 13.5, date: DateTime.now()),
  // ];
  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --------------- VARIABLES ---------------
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2', title: 'New Short', amount: 13.5, date: DateTime.now()),
  ];

  // --------------- FUNCTIONS ---------------
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // this file controls data entry and set new state
  // we pass the reference of _addTransaction function to another widget 3ady
  // In this function, we setState, then TransactionList is updated
  void _addTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(_addTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  // --------------- MAIN WIDGET ---------------
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            })
      ],
    );
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    final appBarHeight = appBar.preferredSize.height;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final txListWidget = Container(
        height: (mediaQuery.size.height - appBarHeight - statusBarHeight) * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      })
                ],
              ),
            if (!isLandscape)
              Container(
                child: Chart(_recentTransactions),
                height:
                    (mediaQuery.size.height - appBarHeight - statusBarHeight) *
                        0.3,
              ),

            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      child: Chart(_recentTransactions),
                      height: (mediaQuery.size.height -
                              appBarHeight -
                              statusBarHeight) *
                          0.7,
                    )
                  : txListWidget
            // TransactionList()
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}
