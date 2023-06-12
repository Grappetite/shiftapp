import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/sop_model.dart';
import 'package:shiftapp/model/worker_sop_model.dart';
import 'package:shiftapp/model/workers_model.dart' as worker;
import 'package:shiftapp/services/login_service.dart';

class SOPService {
  static Future<SopModel>? getSops(int processId,
      {int? executionShiftId}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(
          baseUrl +
              'sops/' +
              processId.toString() +
              (executionShiftId != null ? "/$executionShiftId" : ""),
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = SopModel.fromJson(response.data);

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static Future<WorkerModel> getWorker(int i, url,
      {int? executionShiftId, String? searchParam}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Map<String, dynamic> queryPeremater = new HashMap();
      queryPeremater["sop_id"] = i;
      if (executionShiftId != null) {
        queryPeremater["execute_shift_id"] = executionShiftId;
      }
      if (searchParam != null) {
        queryPeremater["keyword"] = searchParam;
      }
      Response response =
          await dio.get(url ?? (baseUrl + 'requireTrainingWorker'),
              options: Options(
                headers: {
                  authorization: 'Bearer ' + prefs.getString(tokenKey)!,
                },
              ),
              queryParameters: queryPeremater);

      print(response.data);

      var responseObject = WorkerModel.fromJson(response.data);

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static postSign(File file, Datum sopDetail, worker.ShiftWorker shiftWorker,
      {int? executionShiftId}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.post(baseUrl + "sops",
          data: executionShiftId != null
              ? FormData.fromMap({
                  "sop_id": sopDetail.id,
                  "user_id": shiftWorker.userId,
                  "worker_type_id": shiftWorker.workerTypeId,
                  "worker_user_id": shiftWorker.id,
                  "execute_shift_id": executionShiftId,
                  "signature": await MultipartFile.fromFile(file.path,
                      filename: "${DateTime.now().microsecondsSinceEpoch}.png"),
                })
              : FormData.fromMap({
                  "sop_id": sopDetail.id,
                  "user_id": shiftWorker.userId,
                  "worker_type_id": shiftWorker.workerTypeId,
                  "worker_user_id": shiftWorker.id,
                  "signature": await MultipartFile.fromFile(file.path,
                      filename: "${DateTime.now().microsecondsSinceEpoch}.png"),
                }),
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
              Headers.acceptHeader: "application/json",
            },
            contentType: 'multipart/form-data',
          ));
      if (response.statusCode == 200) {
        print(true);
      }
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }
}
