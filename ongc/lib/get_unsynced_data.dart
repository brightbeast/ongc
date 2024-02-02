import 'package:flutter/material.dart';

class UnsyncedData extends StatelessWidget {
  const UnsyncedData(this.data, {super.key});
  final List<dynamic> data;

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unsynced data"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(data[index].toString()),
          );
        }
      )
    );
  }
}


