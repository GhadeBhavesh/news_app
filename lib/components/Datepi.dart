import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Datepi extends StatefulWidget {
  @override
  _DatepiState createState() => _DatepiState();
}

class _DatepiState extends State<Datepi> {
  late DateTime yesterday;
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    yesterday = DateTime.now();
    fromDate = yesterday.subtract(Duration(days: 1));
    toDate = DateTime.now();
  }

  Future<void> _selectFromDate() async {
    DateTime? newFromDate = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (newFromDate != null) {
      setState(() {
        fromDate = newFromDate;
      });
    }
  }

  Future<void> _selectToDate() async {
    DateTime? newToDate = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (newToDate != null) {
      setState(() {
        toDate = newToDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Set Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('From: ${DateFormat('yyyy-MM-dd').format(fromDate)}'),
            SizedBox(height: 20),
            Text('To: ${DateFormat('yyyy-MM-dd').format(toDate)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _selectFromDate();
                await _selectToDate();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HomePage(
                //       fromDate: fromDate,
                //       toDate: toDate,
                //       // selectedCategory: selectedCategory,
                //     ),
                //   ),
                // );
              },
              child: Text('Go to News'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
