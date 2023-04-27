import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../main.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';

class AppException implements Exception {
  final dynamic _message;
  final dynamic _prefix;
  AppException([this._message, this._prefix]);
  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class Errors {
  static dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data.toString());
        print(responseJson);
        return responseJson;
      case 400:
        EasyLoading.showError(
            response.data["message"].runtimeType.toString().toLowerCase() ==
                    "string"
                ? response.data["message"]
                : response.data["message"][0].toString(),
            dismissOnTap: true,
            duration: Duration(seconds: 2));

        break;
      case 401:
        EasyLoading.showError(response.data["error"].toString(),
            dismissOnTap: true, duration: Duration(seconds: 2));
        break;
      case 409:
        EasyLoading.showError(response.data["message"][0].toString(),
            dismissOnTap: true, duration: Duration(seconds: 2));
        break;
      case 410:
        EasyLoading.showError(response.data["message"][0].toString(),
            dismissOnTap: true, duration: Duration(seconds: 2));
        break;
      case 404:
        EasyLoading.showError(response.data!["message"].toString(),
            dismissOnTap: true, duration: Duration(seconds: 2));
        break;
      case 403:
        EasyLoading.showError(response.data["message"][0].toString(),
            dismissOnTap: true, duration: Duration(seconds: 2));
        throw UnauthorisedException(response.data.toString());
      case 500:
        EasyLoading.showError(response.data,
            dismissOnTap: true, duration: Duration(seconds: 2));
        break;
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class LoginService {
  static Future<LoginResponse?> login(String username, String password) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      var fcmToken = await FirebaseMessaging.instance.getToken();
      Response response = await dio.post(
        baseUrl + 'login',
        data: {'email': username, 'password': password, 'fcmToken': fcmToken},
      );

      var responseObject = LoginResponse.fromJson(response.data);

      print(response.data['data']);

      final prefs = await SharedPreferences.getInstance();
      responseObject.data!.user!.lastName;
      if (prefs.getString("allNotification") == null) {
        flutterLocalNotificationsPlugin.cancelAll();
        prefs.setString("allNotification", "done");
      }
      prefs.setString(tokenKey, responseObject.token!);
      log(prefs.getString(tokenKey)!);
      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<ShiftsResponse?> getShifts(int processId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response =
          await dio.get(baseUrl + 'shifts/' + processId.toString(),
              options: Options(
                headers: {
                  authorization: 'Bearer ' + prefs.getString(tokenKey)!,
                },
              ));

      print(response.data);

      var responseObject = ShiftsResponse.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }
      if (responseObject.data!.isEmpty) {
        return null;
      }

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<Process>?> getProcess() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'processList',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);
      var process = <Process>[];

      response.data["data"]["process"].forEach((v) {
        process.add(Process.fromJson(v));
      });
      var responseObject = process;

      if (responseObject == null) {
        return null;
      }

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static logout() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(baseUrl + 'logout',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      return response;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static updateFcm() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      var fcmToken = await FirebaseMessaging.instance.getToken();
      Response response = await dio.patch(baseUrl + 'updateToken',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ),
          data: {'token': fcmToken});

      return response;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static checkVersion() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      Response response = await dio.get(
        baseUrl + 'appVersion',
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }
}
