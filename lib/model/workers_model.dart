import 'package:painter/painter.dart';

class WorkersListing {
  int? code;
  String? status;
  String? message;
  WorkersData? data;

  List<ShiftWorker>? searchWorker;

  WorkersListing({this.code, this.status, this.message, this.data});

  WorkersListing.fromJson(Map<String, dynamic> json, {bool isSearch = false}) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (isSearch) {
      searchWorker = [];

      json['data'].forEach((v) {
        searchWorker!.add(ShiftWorker.fromJson(v));
      });
    } else {
      data = json['data'] != null ? WorkersData.fromJson(json['data']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WorkersData {
  List<ShiftWorker>? worker;
  List<ShiftWorker>? shiftWorker;

  WorkersData({this.worker, this.shiftWorker});

  WorkersData.fromJson(Map<String, dynamic> json) {
    shiftWorker = <ShiftWorker>[];

    worker = <ShiftWorker>[];

    if (json['worker'] != null) {
      var workersListTemp = json['worker'];

      json['worker'].forEach((v) {
        var toAddAdd = ShiftWorker.fromJson(v);

        if (toAddAdd.workerTypeId != null) {
          worker!.add(ShiftWorker.fromJson(v));
        }
      });
    }
    if (json['shift_worker'] != null) {
      json['shift_worker'].forEach((v) {
        var toAddAdd = ShiftWorker.fromJson(v);
        if (toAddAdd.workerTypeId != null) {
          shiftWorker!.add(ShiftWorker.fromJson(v));
        }
      });
    } else {
      shiftWorker = <ShiftWorker>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (worker != null) {
      data['worker'] = worker!.map((v) => v.toJson()).toList();
    }
    if (shiftWorker != null) {
      data['shift_worker'] = shiftWorker!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftWorker {
  int? id;
  int? userId;
  int? workerTypeId;
  int? expiryDays;
  String? workerType;
  String? firstName;
  String? lastName;
  String? key;
  int? efficiencyCalculation;

  bool isTemp = false;

  String picture = '';
  String? role = '';

  bool isSelected = false;

  bool isAdded = false;
  String? licenseName;
  DateTime? license_expiry;
  bool newAdded = false;
  bool newRemove = false;
  final PainterController painterController = PainterController();

  ShiftWorker(
      {this.id,
      this.userId,
      this.workerTypeId,
      this.workerType,
      this.firstName,
      this.lastName,
      this.key,
      this.role,
      this.licenseName,
      this.license_expiry,
      this.efficiencyCalculation});

  ShiftWorker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    workerTypeId = json['workerTypeId'];
    workerType = json['workerType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    key = json['key'];
    efficiencyCalculation = json['efficiencyCalculation'];
    picture = json['picture'];
    licenseName = json["licenseName"];
    expiryDays = json["expiry_days"];
    role = json["role"];
    license_expiry = json["license_expiry"] != null
        ? DateTime.parse(json["license_expiry"])
        : null;
    if (json.keys.contains('worker_add')) {
      isAdded = json['worker_add'] == '1';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['workerTypeId'] = workerTypeId;
    data['workerType'] = workerType;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['key'] = key;
    data['efficiencyCalculation'] = efficiencyCalculation;
    return data;
  }
}

class AddTempResponse {
  int? code;
  String? status;
  String? message;
  ShiftWorker? data;

  AddTempResponse({this.code, this.status, this.message, this.data});

  AddTempResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ShiftWorker.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AddWorkersResponse {
  int? code;
  String? status;
  String? message;
  AddWorkerData? data;

  String? error;

  AddWorkersResponse({this.code, this.status, this.message});

  AddWorkersResponse.fromJson(Map<String, dynamic> json, {bool error = false}) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (error == false) {
      data = json['data'] != null
          ? new AddWorkerData.fromJson(json['data'])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}

class AddWorkerData {
  int? executeShiftId;
  int? shiftId;
  int? processId;

  AddWorkerData({this.executeShiftId, this.shiftId, this.processId});

  AddWorkerData.fromJson(Map<String, dynamic> json) {
    executeShiftId = json['execute_shift_id'];
    shiftId = json['shift_id'];
    processId = json['process_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['execute_shift_id'] = this.executeShiftId;
    data['shift_id'] = this.shiftId;
    data['process_id'] = this.processId;
    return data;
  }
}

class ShiftWorkerList {
  ShiftWorkerList({
    this.code,
    this.status,
    this.data,
    this.totalDowntime,
    this.sopCount,
    this.message,
  });

  int? code;
  String? status;
  List<Datum>? data;
  int? sopCount;
  String? message;
  TotalDowntime? totalDowntime;
  factory ShiftWorkerList.fromJson(Map<String, dynamic> json) =>
      ShiftWorkerList(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        sopCount: json["sopCount"] == null ? null : json["sopCount"],
        totalDowntime: json["totalDowntime"] == null
            ? null
            : TotalDowntime.fromJson(json["totalDowntime"]),
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null ? null : message,
      };
}

class TotalDowntime {
  TotalDowntime({
    this.totalDowntime,
    this.totalIncident,
  });

  dynamic totalDowntime;
  int? totalIncident;

  factory TotalDowntime.fromJson(Map<String, dynamic> json) => TotalDowntime(
        totalDowntime: json["total_downtime"] ?? 0,
        totalIncident: json["total_incident"],
      );

  Map<String, dynamic> toJson() => {
        "total_downtime": totalDowntime,
        "total_incident": totalIncident,
      };
}

class Datum {
  Datum({
    this.shiftWorkerId,
    this.workerUserId,
    this.userId,
    this.executeShiftId,
    this.actualTimeloggedin,
    this.actualTimeloggedout,
    this.status,
    this.name,
    this.lastName,
  });

  int? shiftWorkerId;
  int? workerUserId;
  int? userId;
  int? executeShiftId;
  DateTime? actualTimeloggedin;
  DateTime? actualTimeloggedout;
  String? status;
  String? name;
  String? lastName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        shiftWorkerId:
            json["shift_worker_id"] == null ? null : json["shift_worker_id"],
        workerUserId:
            json["worker_user_id"] == null ? null : json["worker_user_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        executeShiftId:
            json["execute_shift_id"] == null ? null : json["execute_shift_id"],
        actualTimeloggedin: json["actual_timeloggedin"] == null
            ? null
            : DateTime.parse(json["actual_timeloggedin"]),
        actualTimeloggedout: json["actual_timeloggedout"] == null
            ? null
            : json["status"].toString().toLowerCase() == "active"
                ? DateTime.now()
                : DateTime.parse(json["actual_timeloggedout"]),
        status: json["status"] == null ? null : json["status"],
        name: json["name"] == null ? null : json["name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "shift_worker_id": shiftWorkerId == null ? null : shiftWorkerId,
        "worker_user_id": workerUserId == null ? null : workerUserId,
        "user_id": userId == null ? null : userId,
        "execute_shift_id": executeShiftId == null ? null : executeShiftId,
        "actual_timeloggedin": actualTimeloggedin == null
            ? null
            : actualTimeloggedin!.toIso8601String(),
        "actual_timeloggedout": actualTimeloggedout == null
            ? null
            : actualTimeloggedout!.toIso8601String(),
        "status": status == null ? null : status,
        "name": name == null ? null : name,
        "last_name": lastName == null ? null : lastName,
      };
}
