import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shiftapp/Network/environment.dart';
import 'package:shiftapp/config/constants.dart';

import 'appExceptions.dart';

final String baseUrl = Environment().config.baseUrl;
final String apiUrl = Environment().config.apiUrl;
final String imageUrl = Environment().config.imageUrl;
final String socketUrl = Environment().config.socketUrl;
final String mapKey = Environment().config.mapKey;
const String placeHolder =
    "https://www.itdp.org/wp-content/uploads/2021/06/avatar-man-icon-profile-placeholder-260nw-1229859850-e1623694994111.jpg";

class Api {
  var sp = GetStorage();

  Future<dynamic> get(String url, {fullUrl, isProgressShow = false}) async {
    if (isProgressShow == false) {
      BotToast.showLoading();
    }
    Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ));
    print('Api Get, url $url');
    dio.options.headers['Authorization'] = "Bearer ${sp.read(tokenKey)}";
    if (url != "") {
      try {
        final response = await dio.get(fullUrl ?? apiUrl + url);
        Future.delayed(Duration(seconds: 1), () {
          if (isProgressShow == false) {
            BotToast.closeAllLoading();
          }
        });
        return response;
      } on SocketException {
        Future.delayed(Duration(seconds: 1), () {
          if (isProgressShow == false) {
            BotToast.closeAllLoading();
          }
        });
        throw FetchDataException('No Internet connection');
      } on DioError catch (e) {
        Future.delayed(Duration(seconds: 1), () {
          if (isProgressShow == false) {
            BotToast.closeAllLoading();
          }
        });
        return _returnResponse(e.response!);
      }
    }
  }

  Future<dynamic> delete(formData, String url, {isProgressShow = false}) async {
    if (isProgressShow == false) {
      BotToast.showLoading();
    }
    Dio dio = Dio(BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ));
    dio.options.headers['Authorization'] = "Bearer ${sp.read(tokenKey)}";

    try {
      final response = await dio.post(
        apiUrl + url,
        data: formData,
        options: Options(
          headers: {
            Headers.acceptHeader: "application/json",
          },
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });
      return response;
    } on SocketException {
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        BotToast.closeAllLoading();
        BotToast.showText(text: "Connection Timeout Exception");
        throw Exception("Connection Timeout Exception");
      }
      Future.delayed(Duration(seconds: 1), () {
        if (isProgressShow == false) {
          BotToast.closeAllLoading();
        }
      });
      return _returnResponse(e.response!);
    }
  }

  Future<dynamic> post(formData, url,
      {auth = false,
      multiPart = false,
      isProgressShow = false,
      fullUrl}) async {
    print('Api Post, url $url');

    if (isProgressShow == false) {
      BotToast.showLoading();
    }
    Dio dio = Dio();
    if (auth == false) {
      print(sp.read(tokenKey));
      dio.options.headers['Authorization'] = "Bearer ${sp.read(tokenKey)}";
    }

    try {
      dynamic response = await dio.post(
        fullUrl ?? apiUrl + url,
        data: formData,
        options: multiPart == true
            ? Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
                contentType: 'multipart/form-data',
              )
            : Options(
                headers: {
                  Headers.acceptHeader: "application/json",
                },
              ),
      );
      print("hide");
      if (isProgressShow == false) {
        BotToast.closeAllLoading();
      }
      return response;
    } on DioError catch (e) {
      print("erro hide");
      if (isProgressShow == false) {
        BotToast.closeAllLoading();
      }

      if (e.type == DioErrorType.other) {
        BotToast.showText(text: 'No Internet connection');
        throw FetchDataException('No Internet connection');
      } else {
        return _returnResponse(e.response!);
      }
    }
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data.toString());
        print(responseJson);
        return responseJson;
      case 400:
        BotToast.showText(
            text:
                response.data["message"].runtimeType.toString().toLowerCase() ==
                        "string"
                    ? response.data["message"]
                    : response.data["message"][0].toString());

        break;
      case 401:
        BotToast.showText(text: response.data["message"][0].toString());
        break;
      case 409:
        BotToast.showText(text: response.data["message"][0].toString());
        // g.Get.offAllNamed(Routes.barberPortfolio);
        break;
      case 410:
        BotToast.showText(text: response.data["message"][0].toString());
        // g.Get.offAllNamed(Routes.selectBarber);
        break;
      case 404:
        BotToast.showText(text: response.data["message"][0].toString());
        break;
      case 403:
        BotToast.showText(text: response.data["message"][0].toString());
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
