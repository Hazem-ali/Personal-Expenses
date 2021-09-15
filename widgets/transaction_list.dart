// import 'dart:html';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  List<Transaction> transactions;
  Function deleteTx;
  TransactionList(transactions, deleteTx) {
    this.transactions = transactions;
    this.deleteTx = deleteTx;

    // this.transactions.addAll([
    //       Transaction(
    //           id: "1", title: "lol", amount: 1566.668, date: DateTime.now()),
    //       Transaction(
    //           id: "2", title: "Mofty", amount: 40.668, date: DateTime.now()),
    //       Transaction(
    //           id: "3", title: "goood", amount: 199.668, date: DateTime.now()),
    //       Transaction(
    //           id: "4",
    //           title: "aaa333",
    //           amount: 599987.668,
    //           date: DateTime.now())
    //     ].toList());
  }

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  "No Transactions Yet...",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.15,
                ), // SizedBox is a separator
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              // here we should return the recurring item
              // ListViewBuilder handles the loop here, we only show it how to return each item
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                elevation: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: FittedBox(
                          child: Text("\$${transactions[index].amount}")),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // trailing is for internal buttons for deleting..etc
                  trailing: MediaQuery.of(context).size.width > 430
                      ? TextButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text("Delete"),
                          style: TextButton.styleFrom(
                            primary: Theme.of(context).errorColor,
                          ),
                          onPressed: () {
                            deleteTx(transactions[index].id);
                          })
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            deleteTx(transactions[index].id);
                          },
                        ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
