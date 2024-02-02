import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:ongc/dbhelper.dart';
import 'dart:convert';
import 'package:ongc/format.dart';

var logger = Logger();

Future<void> sendOnline(Format inputData) async {
  try {
    final url = Uri.parse('http://10.0.2.2:5000/api');
    var dict = {
      'name': inputData.name,
      'age': inputData.age,
      'canteen': inputData.canteen,
    };
    final response = await http.post(url, body: json.encode(dict));
    if (response.statusCode == 200) {
      logger.i("Data sent Successfully");
    } else {
      logger.e("Data not able to send ");
    }
  } catch (error) {
    logger.e("Catch Error");
  }
}

Future<List<dynamic>> fetchDataFromFlask() async {
  try {
    final url = Uri.parse('http://10.0.2.2:5000/data');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      logger.i("Data received Successfully");
      var allRows = jsonDecode(response.body);
      return allRows;
    } else {
      logger.e("Failed to send Data");
      return [];
    }
  } catch (error) {
    logger.e("Error: $error");
    return [];
  }
}

Future<void> checkConnectivity(Function(bool) updateConnectivity) async {
  var connectionChecker = InternetConnectionChecker();
  bool isConnected = await connectionChecker.hasConnection;

  connectionChecker.onStatusChange.listen((status) {
    isConnected = status == InternetConnectionStatus.connected;
    updateConnectivity(isConnected);
  });
}

Future<void> storeInLocalDatabase(Format inputData) async {
  int flag = 1;
  if (inputData.canteen == true) flag = 0;

  Map<String, dynamic> row = {
    DatabaseHelper.columnName: inputData.name,
    DatabaseHelper.columnAge: inputData.age,
    DatabaseHelper.columnCanteen: flag
  };
  final id = await DatabaseHelper.instance.insertData(row);
  logger.i(id);
}

// Future<void> getLocalData() async {
//   var allRows = await DatabaseHelper.instance.readData();
//   for (var row in allRows) {
//     logger.i(row);
//   }
// }



