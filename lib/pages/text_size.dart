import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TextSizePage extends StatefulWidget {
  final DatabaseReference ref;

  const TextSizePage({Key? key, required this.ref}) : super(key: key);

  @override
  State<TextSizePage> createState() => _TextSizePageState();
}

class _TextSizePageState extends State<TextSizePage> {
  String selectedSize = "Medium"; // Initial selected size

  @override
  // void initState() {
  //   super.initState();
  //   widget.ref.once().then((snapshot) {
  //     if (snapshot.value != null) {
  //       setState(() {
  //         selectedSize =
  //             snapshot.value as String; // Set saved size from database
  //       });
  //     }
  //   });
  // }

  // void onSizeSelected(String size) {
  //   setState(() {
  //     selectedSize = size;
  //   });
  //   widget.ref.set(size); // Save selected size to database
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Size"),
      ),
      body: Center(
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     DropdownButton(
          //       value: selectedSize,
          //       items: [
          //         DropdownMenuItem(value: "Small", child: Text("Small")),
          //         DropdownMenuItem(value: "Medium", child: Text("Medium")),
          //         DropdownMenuItem(value: "Large", child: Text("Large")),
          //       ],
          //       // onChanged: (size) => onSizeSelected(size!),
          //     ),
          //     // Text widget that displays the selected size
          //     Text(
          //       "Selected Size: $selectedSize",
          //       style: TextStyle(fontSize: double.parse(selectedSize)),
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
