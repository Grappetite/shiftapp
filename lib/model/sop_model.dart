import 'dart:convert';

SopModel sopModelFromJson(String str) => SopModel.fromJson(json.decode(str));

String sopModelToJson(SopModel data) => json.encode(data.toJson());

class SopModel {
  SopModel({
    this.code,
    this.status,
    this.data,
    this.message,
  });

  int? code;
  String? status;
  List<Datum>? data;
  String? message;

  factory SopModel.fromJson(Map<String, dynamic> json) => SopModel(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
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

class Datum {
  Datum({
    this.id,
    this.processId,
    this.name,
    this.updatedAt,
    this.stepCount,
    this.trainingRequired,
    this.sopStep,
  });

  int? id;
  int? processId;
  String? name;
  DateTime? updatedAt;
  int? stepCount;
  int? trainingRequired;
  List<SopStep>? sopStep;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        processId: json["process_id"] == null ? null : json["process_id"],
        name: json["name"] == null ? null : json["name"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        stepCount: json["stepCount"] == null ? null : json["stepCount"],
        trainingRequired:
            json["trainingRequired"] == null ? null : json["trainingRequired"],
        sopStep: json["sopStep"] == null
            ? null
            : List<SopStep>.from(
                json["sopStep"]!.map((x) => SopStep.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "process_id": processId == null ? null : processId,
        "name": name == null ? null : name,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "stepCount": stepCount == null ? null : stepCount,
        "trainingRequired": trainingRequired == null ? null : trainingRequired,
        "sopStep": sopStep == null
            ? null
            : List<dynamic>.from(sopStep!.map((x) => x.toJson())),
      };
}

class SopStep {
  SopStep({
    this.id,
    this.sopId,
    this.step,
    this.name,
    this.detail,
    this.equipment,
    this.image,
    this.updatedBy,
    this.imageUrl,
    this.sopWorkerType,
  });

  int? id;
  int? sopId;
  int? step;
  String? name;
  String? detail;
  String? equipment;
  String? image;
  int? updatedBy;
  String? imageUrl;
  List<SopWorkerType>? sopWorkerType;

  factory SopStep.fromJson(Map<String, dynamic> json) => SopStep(
        id: json["id"] == null ? null : json["id"],
        sopId: json["sop_id"] == null ? null : json["sop_id"],
        step: json["step"] == null ? null : json["step"],
        name: json["name"] == null ? null : json["name"],
        detail: json["detail"] == null ? null : json["detail"],
        equipment: json["equipment"] == null ? null : json["equipment"],
        image: json["image"] == null ? null : json["image"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        sopWorkerType: json["sop_worker_type"] == null
            ? null
            : List<SopWorkerType>.from(
                json["sop_worker_type"]!.map((x) => SopWorkerType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sop_id": sopId == null ? null : sopId,
        "step": step == null ? null : step,
        "name": name == null ? null : name,
        "detail": detail == null ? null : detail,
        "equipment": equipment == null ? null : equipment,
        "image": image == null ? null : image,
        "updated_by": updatedBy == null ? null : updatedBy,
        "image_url": imageUrl == null ? null : imageUrl,
        "sop_worker_type": sopWorkerType == null
            ? null
            : List<dynamic>.from(sopWorkerType!.map((x) => x.toJson())),
      };
}

class SopWorkerType {
  SopWorkerType({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory SopWorkerType.fromJson(Map<String, dynamic> json) => SopWorkerType(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}
