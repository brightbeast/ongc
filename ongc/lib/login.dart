import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:logger/logger.dart';
import 'package:ongc/background_services.dart';
import 'package:ongc/dbhelper.dart';
import 'package:ongc/format.dart';
import 'package:ongc/funcs.dart';
import 'package:ongc/fetch_data.dart';
import 'package:ongc/get_unsynced_data.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  Format data = Format();
  String? _currVal;
  bool flag = true;
  final List<String> _dropdownItems = ["Yes", "No"];
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();

    checkConnectivity((isConnected) {
      setState(() {
        flag = isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Name"),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      controller: _textController1,
                      onChanged: (text) {
                        data.name = text;
                      },
                      decoration: const InputDecoration(
                          hintText: "Name FatherName Sirname"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Age"),
                  const SizedBox(
                    width: 25,
                  ),
                  Flexible(
                    child: TextField(
                      controller: _textController2,
                      keyboardType: TextInputType.number,
                      onChanged: (number) {
                        data.age = int.tryParse(number);
                      },
                      decoration: const InputDecoration(hintText: "Enter age"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do you love Canteen?"),
                  const SizedBox(
                    width: 25,
                  ),
                  DropdownButton<String>(
                    value: _currVal,
                    hint: const Text('Select'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _currVal = newValue;
                        if (newValue == "Yes") {
                          data.canteen = true;
                        } else {
                          data.canteen = false;
                        }
                      });
                    },
                    items: _dropdownItems.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      WidgetsFlutterBinding.ensureInitialized();
                      initializeService();
                      FlutterBackgroundService()
                          .invoke('setAsBackgroundService');
                      if (flag == true) {
                        Logger().i("Send online=> Firebase");
                        sendOnline(data);
                      } else {
                        Logger().i("Send offline=> Sqlite");
                        storeInLocalDatabase(data);
                      }

                      // clearing the textField()
                      _textController1.clear();
                      _textController2.clear();
                    },
                    child: const Text("submit"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    // onPressed: getLocalData,
                    onPressed: () {
                      DatabaseHelper.instance.readData().then((fetchedData) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnsyncedData(fetchedData),
                          ),
                        );
                      });
                    },
                    child: const Text('Unsynced Data'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      fetchDataFromFlask().then((fetchedData) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FetchData(fetchedData),
                          ),
                        );
                      });
                      
                    },
                    child: const Text("Synced data"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
