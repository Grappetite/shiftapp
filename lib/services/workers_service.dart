import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../model/login_model.dart';
import '../model/shifts_model.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';

class WorkersService {
  static Future<WorkersListing?> getShiftWorkers(int? shiftId) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "workers";
      if (shiftId != null) {
        url = baseUrl + 'workers/' + shiftId.toString();
      }

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = WorkersListing.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<WorkersListing?> searchWorkers(String searchId) async {
    //{{shift_url}I/searchWorker/2
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      String url = baseUrl + 'searchWorker/' + searchId;

      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );
      print(response.data);

      var responseObject = WorkersListing.fromJson(response.data,isSearch: true);
      if (responseObject.searchWorker == null) {
        return null;
      }
      return responseObject;
    } catch (e) {
      return null;
    }
  }

  //{{shift_url})/addShiftWorker

  static Future<ShiftStartModel?> addWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> startTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'shifts/workers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'starttime': startTime,
          'efficiency_calculation': efficiencyCalculation
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = ShiftStartModel.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }
      //     final prefs = await SharedPreferences.getInstance();
      //   responseObject.data!.user!.lastName;

      // prefs.setString(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<ShiftStartModel?> addShiftWorker(
      int shiftId,
      List<String> workerUserId,
      List<String> startTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'shifts/workers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'starttime': startTime,
          'efficiency_calculation': efficiencyCalculation
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = ShiftStartModel.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }
      //     final prefs = await SharedPreferences.getInstance();
      //   responseObject.data!.user!.lastName;

      // prefs.setString(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }


  static Future<WorkerTypeResponse?> getWorkTypes(int shiftId) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      Response response = await dio.get(baseUrl + 'workerType/',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      var responseObject = WorkerTypeResponse.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } catch (e) {
      return null;
    }
  }

  static Future<AddTempResponse?> addTempWorkers(
      String firstName, String lastName, String key, String workerType) async {
    try {
      var dio = Dio();
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'workers',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'key': key,
          'worker_type': workerType
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      print(response.data);

      var responseObject = AddTempResponse.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }
      //     final prefs = await SharedPreferences.getInstance();
      //   responseObject.data!.user!.lastName;

      // prefs.setString(tokenKey, responseObject.token!);

      return responseObject;
    } catch (e) {
      return null;
    }
  }
}
