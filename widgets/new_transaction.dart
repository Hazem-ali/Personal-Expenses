import 'package:flutter/material.dart';
// import './user_transactions.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(title, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Input Field
    return SingleChildScrollView(
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: [
              TextField(
                // cursorColor: Colors.red,
                decoration: InputDecoration(labelText: "Title"),
                // onChanged: (value) {
                //   titleInput = value;
                // },
                controller: _titleController,
              ),
              TextField(
                // cursorColor: Colors.red,
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  _submitData();
                },
                // onChanged: (value) {
                //   amountInput = value;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen"
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {
                          _presentDatePicker();
                        },
                        child: Text(
                          "Add a date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // print(titleController.text);
                  _submitData();
                  // print(amountInput);
                },
                child: Text(
                  "Add Transaction",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
