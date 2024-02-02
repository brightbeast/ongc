import 'package:flutter/material.dart';

class FetchData extends StatelessWidget {
  const FetchData(this.data, {super.key});
  final List<dynamic> data;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fetched Data"),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(data[index].toString()),
            );
          }),
    );
  }
}
