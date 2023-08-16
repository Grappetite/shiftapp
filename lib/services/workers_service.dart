import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/model/login_model.dart';
import 'package:shiftapp/model/ppe_model.dart';

import '../config/constants.dart';
import '../model/worker_type_model.dart';
import '../model/workers_model.dart';
import 'login_service.dart';

class WorkersService {
  static Future<WorkersListing?> getShiftWorkers(
      int? shiftId, int processId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "newWorkerList/" + processId.toString();
      if (shiftId != null) {
        url = baseUrl +
            'newWorkerList/' +
            processId.toString() +
            '/' +
            shiftId.toString();
      }

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      var responseObject = WorkersListing.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      if (responseObject.data!.shiftWorker == null) {
        responseObject.data!.shiftWorker = [];
      }

      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<ShiftWorkerList?> getAllShiftWorkersList(int? shiftId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "startedShiftWorkerList/" + shiftId.toString();

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      //print(response.data);

      var responseObject = ShiftWorkerList.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<dynamic> startedProcessList(
      // processId,
      executeShiftId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      String url = baseUrl + "startedProcessList/$executeShiftId";

      Response response = await dio.get(url,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      //print(jsonEncode(response.data));
      var responseObject = List<Process>.from(
          response.data["data"].map((x) => Process.fromJson(x)));
      // if (responseObject.isEmpty) {
      //   return null;
      // }

      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<WorkersListing?> searchWorkers(String searchId,
      {int? executionid}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      String url = baseUrl +
          'searchWorker/' +
          searchId +
          (executionid != null ? "/${executionid.toString()}" : '');

      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );
      // d.log(response.data.toString());

      var responseObject =
          WorkersListing.fromJson(response.data, isSearch: true);
      if (responseObject.searchWorker == null) {
        return null;
      }
      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<bool> addWorkers(
      int exshiftId,
      List<String> workerUserId,
      List<String> startTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      for (int i = 1;
          i <
              [
                workerUserId.length,
                startTime.length,
                executeShiftId.length,
                efficiencyCalculation.length
              ].reduce(max);
          i++) {
        startTime.add(startTime[0]);
      }
      Response response = await dio.post(
        baseUrl + 'shifts/addWorkers',
        data: {
          'execute_shift_id': exshiftId.toString(),
          'worker_user_id': workerUserId,
          'starttime': startTime,
          'efficiency_calculation': efficiencyCalculation,
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      //print(response.data);

      if (response.data['code'] == 200) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<bool> moveWorkers(
      {required int exshiftId,
      required String moveTime,
      required String startedExecuteShiftId,
      required int workerUserId,
      required int workerTypeId}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'moveWorker',
        data: {
          'execute_shift_id': exshiftId.toString(),
          'worker_user_id': workerUserId,
          'start_time': moveTime,
          'started_execute_shift_id': startedExecuteShiftId,
          'worker_type_id': workerTypeId,
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      //print(response.data);

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<bool> removeWorkers(
      int shiftId,
      List<String> workerUserId,
      List<String> endTime,
      List<String> executeShiftId,
      List<String> efficiencyCalculation) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString(tokenKey);

      Response response = await dio.post(
        baseUrl + 'shifts/removeWorkers',
        data: {
          'execute_shift_id': shiftId.toString(),
          'worker_user_id': workerUserId,
          'endtime': endTime,
          'efficiency_calculation': efficiencyCalculation
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      //print(response.data);

      if (response.data['code'] == 200) {
        return true;
      }

      return false;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<AddWorkersResponse?> addShiftWorker(
    int shiftId,
    int processId,
    String startTime,
    String endTime,
    List<String> workerUserId,
    List<String> efficiencyCalculation,
    String comment, {
    PpeModel? ppe,
    String? discrepancyComment,
  }) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      List<int> ppe_check = [];
      ppe!.data!.forEach((element) {
        if (element.selected!) {
          ppe_check.add(element.workerTypeId!);
        }
      });

      Response response = await dio.post(
        baseUrl + 'addShiftWorker',
        data: {
          'shift_id': shiftId.toString(),
          'process_id': processId.toString(),
          'start_time': startTime,
          'end_time': endTime,
          'worker_user_id': workerUserId,
          'efficiency_calculation': efficiencyCalculation,
          'comment': comment,
          "ppe_comment": discrepancyComment,
          "ppe_check": ppe_check,
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      var responseObject = AddWorkersResponse.fromJson(response.data);

      if (responseObject.code != 200) {
        return null;
      }

      return responseObject;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data != null) {
          return AddWorkersResponse.fromJson(e.response!.data!, error: true);
        }
      } else {
        return null;
      }
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<WorkerTypeResponse?> getWorkTypes(
      String shiftId, String processId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      Response response = await dio.get(baseUrl + 'workerType/' + processId,
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      var responseObject = WorkerTypeResponse.fromJson(response.data);

      //print(response.data);

      if (responseObject.data == null) {
        return null;
      }

      if (responseObject.data!.isEmpty) {
        return getWorkTypes('', '');
      }

      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<bool?> updateExpiry(
      {required ShiftWorker worker,
      required issueDate,
      required expiryDate}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'licenseUpdate',
        data: {
          'worker_user_id': worker.id,
          'license_expiry': expiryDate,
          'issue_date': issueDate,
          'user_id': worker.userId,
          'license_id': worker.licenseId,
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      return true;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }

  static Future<AddTempResponse?> addTempWorkers(
      String firstName,
      String lastName,
      String key,
      String workerType,
      String shiftId,
      String startTime) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 120 seconds
          receiveTimeout: Duration(minutes: 2) // 120 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(
        baseUrl + 'workers',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'key': key,
          'worker_type': workerType,
          'execute_shift_id': shiftId,
          'start_time': startTime
        },
        options: Options(
          headers: {
            authorization: 'Bearer ' + prefs.getString(tokenKey)!,
          },
        ),
      );

      //print(response.data);

      var responseObject = AddTempResponse.fromJson(response.data);

      if (responseObject.data == null) {
        return null;
      }

      return responseObject;
    } on DioException catch (e) {
      return Errors.returnResponse(e.response!);
    }
  }
}
