import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/model/login_model.dart';

import '../config/constants.dart';
import 'login_service.dart';

class ShiftService {
  static Future<bool?> cancelShift(
    int shiftId,
    String endTime,
  ) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'cancelShift',
        data: {'execute_shift_id': shiftId.toString(), 'end_time': endTime},
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);
      return true;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<List<ShiftStartDetails>> startedShiftsList() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(
        baseUrl + 'startedShiftDetails',
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);
      return List<ShiftStartDetails>.from(
          response.data["data"].map((x) => ShiftStartDetails.fromJson(x)));
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future endShift(
      int shiftId, int processId, String unitsProduced, String endTime) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'endShift',
        data: {
          'execute_shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'end_time': endTime,
          'units_produced': unitsProduced,
          'comments': 'comment'
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      if (response.data['code'] == 200) {
        return response.data["data"];
      }

      return false;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static handOverShift({int? executionShiftId, int? userId}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'handOverShift',
        data: {"user_id": userId, "execute_shift_id": executionShiftId},
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      if (response.data['code'] == 200) {
        return true;
      }

      return false;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static getOnlineUsers() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "userLoginlist";
      print('');

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));
      return List<User>.from(
          response.data["data"].map((x) => User.fromJson(x)));
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e);
    }
  }

  static getEffeciency(int? id) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: 350 * 1000, // 60 seconds
          receiveTimeout: 350 * 1000 // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "efficiency/$id";
      print('');

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));
      return response.data['data'];
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e);
    }
  }
}
