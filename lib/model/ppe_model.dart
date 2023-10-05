// To parse this JSON data, do
//
//     final ppeModel = ppeModelFromJson(jsonString);

import 'dart:convert';

PpeModel ppeModelFromJson(String str) => PpeModel.fromJson(json.decode(str));

String ppeModelToJson(PpeModel data) => json.encode(data.toJson());

class PpeModel {
  PpeModel({
    this.code,
    this.status,
    this.message,
    this.data,
  });

  int? code;
  String? status;
  String? message;
  List<Datum>? data;

  factory PpeModel.fromJson(Map<String, dynamic> json) => PpeModel(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.workerTypeId,
    this.name,
    this.count,
    this.selected,
    this.ppeCheckBoxSelected,
    this.details,
  });

  int? workerTypeId;
  String? name;
  int? count;
  bool? selected;
  bool? ppeCheckBoxSelected;
  List<Detail>? details;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        workerTypeId: json["worker_type_id"],
        name: json["name"],
        count: json["count"],
        selected: false,
        ppeCheckBoxSelected: false,
        details: json["details"] == null
            ? []
            : List<Detail>.from(
                json["details"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "worker_type_id": workerTypeId,
        "name": name,
        "count": count,
        "details": details == null
            ? []
            : List<dynamic>.from(details!.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    this.name,
    this.id,
    this.itemnumber,
    this.imageUrl,
  });

  String? name;
  int? id;
  String? itemnumber;
  String? imageUrl;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        name: json["name"],
        id: json["id"],
        itemnumber: json["itemnumber"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "itemnumber": itemnumber,
        "image_url": imageUrl,
      };
}
