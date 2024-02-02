import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';
import 'package:ongc/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

Logger logger = Logger();
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

Future<bool> isTableEmpty(Database? db, String tableName) async {
  final count = Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM $tableName'));
  logger.i("Entering in the empty function and the count is $count");
  return count == 0;
}

Future<List<Map<String, dynamic>>> getDatafromSqlite(
    Database? database, String tableName) async {
  Database db = await DatabaseHelper.instance.getDatabase();
  return await db.query(tableName);
}

Future<void> sendDataToapi(List<Map<String, dynamic>> data) async {
  try {
    Logger().i("Sending Data to API");
    final url = Uri.parse('http://10.0.2.2:5000/localDatabase');
    for (var dict in data) {
      Database? database = await DatabaseHelper.instance.getDatabase();
      var tableName = DatabaseHelper.table;
      bool isEmpty = await isTableEmpty(database, tableName);
      if (isEmpty) break;

      final response = await http.post(url, body: json.encode(dict));
      if (response.statusCode == 200) {
        logger.i("Data sent successfuly");
        logger.i("Response: ${response.body}");
        DatabaseHelper.instance.deleteData(dict['id']);
      } else {
        logger.e("Failed to send data");
      }
    }
  } catch (error) {
    logger.e("Error: $error");
  }
}

void onStart(ServiceInstance service) async {
  logger.i("Backend Services started");
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize any required plugins or services here

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackgroundService').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Application Name",
          content: "Data sent successfully",
        );
      }
    }
    Logger().i("Background service is running ");
    // Running the background Services
    Database? database = await DatabaseHelper.instance.getDatabase();
    var tableName = DatabaseHelper.table;
    bool isEmpty = await isTableEmpty(database, tableName);
    
    if (!isEmpty) {
      List<Map<String, dynamic>> data =
          await getDatafromSqlite(database, tableName);
      sendDataToapi(data);
    } else {
      Logger().i("The sqflite database is empty");
      service.stopSelf();
    }

    service.invoke('update');
  });
}
