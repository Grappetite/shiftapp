import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiftapp/config/constants.dart';
import 'package:shiftapp/model/incident_model.dart';
import 'package:shiftapp/services/login_service.dart';

import '../model/workers_model.dart';

class IncidentService {
  static Future<IncidentsModel>? getIncident(int processId, exeId) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'incidents/',
          queryParameters: {
            "process_id": processId.toString(),
            "execute_shift_id": exeId.toString()
          },
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = IncidentsModel.fromJson(response.data);

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static Future<List<IncidentType>>? getIncidentType() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'type/',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = List<IncidentType>.from(
          response.data["data"]!.map((x) => IncidentType.fromJson(x)));

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static Future<List<IncidentType>>? getSeverity() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'severity/',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = List<IncidentType>.from(
          response.data["data"]!.map((x) => IncidentType.fromJson(x)));

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static Future<List<ShiftWorker>>? getSectionManager() async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();

      Response response = await dio.get(baseUrl + 'managerList/',
          options: Options(
            headers: {
              authorization: 'Bearer ' + prefs.getString(tokenKey)!,
            },
          ));

      print(response.data);

      var responseObject = List<ShiftWorker>.from(
          response.data["data"]!.map((x) => ShiftWorker.fromJson(x)));

      return responseObject;
    } on DioError catch (e) {
      return Errors.returnResponse(e.response!);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  static postIncident(
      {String? dateTimeIncident,
      int? process_id,
      IncidentType? incidentType,
      IncidentType? severity,
      bool? isDowntime,
      int? execute_shift_id,
      String? description,
      List<dynamic>? selectedWorker,
      List? imageFileList}) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      List<MultipartFile> test = [];
      for (var element in imageFileList!) {
        test.add(await MultipartFile.fromFile(element.path,
            filename: "${DateTime.now().microsecondsSinceEpoch}.png"));
      }
      ;
      Response response = await dio.post(baseUrl + "incidents",
          data: FormData.fromMap({
            "execute_shift_id": execute_shift_id,
            "process_id": process_id,
            "incident_type_id": incidentType!.id,
            "incident_id": severity!.id,
            "is_downtime": isDowntime! ? "Yes" : "No",
            "details": description,
            "incident_at": dateTimeIncident,
            "image[]": test,
            "user_id": selectedWorker
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

  static updateIncident({
    String? dateTimeIncident,
    int? incidentId,
  }) async {
    try {
      var dio = Dio(BaseOptions(
          receiveDataWhenStatusError: true,
          connectTimeout: Duration(minutes: 2), // 60 seconds
          receiveTimeout: Duration(minutes: 2) // 60 seconds
          ));
      final prefs = await SharedPreferences.getInstance();
      Response response = await dio.put(
          baseUrl + "incidents/$incidentId?downtime=${dateTimeIncident}",
          data: FormData.fromMap({}),
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
