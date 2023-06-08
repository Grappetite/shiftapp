// To parse this JSON data, do
//
//     final inciedentsModel = inciedentsModelFromJson(jsonString);

import 'dart:convert';

IncidentsModel inciedentsModelFromJson(String str) =>
    IncidentsModel.fromJson(json.decode(str));

String inciedentsModelToJson(IncidentsModel data) => json.encode(data.toJson());

class IncidentsModel {
  IncidentsModel({
    this.code,
    this.status,
    this.data,
    this.message,
  });

  int? code;
  String? status;
  List<Datum>? data;
  String? message;

  factory IncidentsModel.fromJson(Map<String, dynamic> json) => IncidentsModel(
        code: json["code"],
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.processId,
    this.incidentTypeId,
    this.incidentId,
    this.details,
    this.isDowntime,
    this.downtime,
    this.createdAt,
    this.process,
    this.incidentType,
    this.incident,
    this.images,
  });

  int? id;
  int? processId;
  int? incidentTypeId;
  int? incidentId;
  String? details;
  String? isDowntime;
  String? downtime;
  String? createdAt;
  Incident? process;
  IncidentType? incidentType;
  Incident? incident;
  List<Pictures>? images;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        processId: json["process_id"],
        incidentTypeId: json["incident_type_id"],
        incidentId: json["incident_id"],
        details: json["details"] ?? "",
        isDowntime: json["is_downtime"],
        downtime: json["downTime"],
        createdAt: json["incident_at"] ?? DateTime.now().toString(),
        process:
            json["process"] == null ? null : Incident.fromJson(json["process"]),
        incidentType: json["incident_type"] == null
            ? null
            : IncidentType.fromJson(json["incident_type"]),
        incident: json["incident"] == null
            ? null
            : Incident.fromJson(json["incident"]),
        images: json["images"] == null
            ? []
            : List<Pictures>.from(
                json["images"]!.map((x) => Pictures.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "process_id": processId,
        "incident_type_id": incidentTypeId,
        "incident_id": incidentId,
        "details": details,
        "is_downtime": isDowntime,
        "downtime": downtime,
        "incident_at": createdAt,
        "process": process?.toJson(),
        "incident_type": incidentType?.toJson(),
        "incident": incident?.toJson(),
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Pictures {
  Pictures({
    this.id,
    this.incidentShiftId,
    this.image,
  });

  int? id;
  int? incidentShiftId;
  String? image;

  factory Pictures.fromJson(Map<String, dynamic> json) => Pictures(
        id: json["id"],
        incidentShiftId: json["incident_shift_id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "incident_shift_id": incidentShiftId,
        "image": image,
      };
}

class Incident {
  Incident({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Incident.fromJson(Map<String, dynamic> json) => Incident(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class IncidentType {
  IncidentType({
    this.id,
    this.name,
    this.icon,
    this.icon_url,
  });

  int? id;
  String? name;
  String? icon;
  String? icon_url;

  factory IncidentType.fromJson(Map<String, dynamic> json) => IncidentType(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        icon_url: json["icon_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "icon_url": icon_url,
      };
}
