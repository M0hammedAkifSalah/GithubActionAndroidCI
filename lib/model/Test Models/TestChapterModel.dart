
class TestChapterModel {
  TestChapterModel({
    this.aboutFile,
    // this.repository,
    this.id,
    this.name,
    this.filesUpload,
    // this.classId,
    // this.boardId,
    // this.subjectId,
    // this.syllabusId,
    // this.createdBy,
    // this.updatedBy,
    // this.createdAt,
    // this.updatedAt,
  });

  List<dynamic> aboutFile;
  //List<BoardIdRepository> repository;
  String id;
  String name;
  List<dynamic> filesUpload;
  // ClassId classId;
  // BoardId boardId;
  // SubjectId subjectId;
  // SyllabusId syllabusId;
  // String createdBy;
  // String updatedBy;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory TestChapterModel.fromJson(Map<String, dynamic> json) {
    // try {
      return TestChapterModel(
        aboutFile:json["about_file"] != null ? List<dynamic>.from(json["about_file"].map((x) => x)):null,
        // repository: List<BoardIdRepository>.from(
        //     json["repository"].map((x) => BoardIdRepository.fromJson(x))),
        id: json["_id"],
        name: json["name"],
        filesUpload: List<dynamic>.from(json["files_upload"].map((x) => x)),
        // classId: ClassId.fromJson(json["class_id"]),
        // boardId: BoardId.fromJson(json["board_id"]),
        // subjectId: SubjectId.fromJson(json["subject_id"]),
        // syllabusId: SyllabusId.fromJson(json["syllabus_id"]),
        // createdBy: json["created_by"],
        // updatedBy: json["updated_by"],
        // createdAt: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updatedAt"]),
      );
    // } catch (e) {
    //   // TODO
    //   log(e.toString() + e.runtimeType.toString());
    //   if(e is NoSuchMethodError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    // }
  }

  Map<String, dynamic> toJson() => {
        "about_file": List<dynamic>.from(aboutFile.map((x) => x)),
        // "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "_id": id,
        "name": name,
        "files_upload": List<dynamic>.from(filesUpload.map((x) => x)),
        // "class_id": classId.toJson(),
        // "board_id": boardId.toJson(),
        // "subject_id": subjectId.toJson(),
        // "syllabus_id": syllabusId.toJson(),
        // "created_by": createdBy,
        // "updated_by": updatedBy,
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
      };
}

class BoardId {
  BoardId({
    this.repository,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.createdBy,
    this.updatedBy,
    this.v,
  });

  List<BoardIdRepository> repository;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String createdBy;
  String updatedBy;
  int v;

  factory BoardId.fromJson(Map<String, dynamic> json) => BoardId(
        repository: List<BoardIdRepository>.from(
            json["repository"].map((x) => BoardIdRepository.fromJson(x))),
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "__v": v,
      };
}

class BoardIdRepository {
  BoardIdRepository({
    this.id,
    this.branchName,
    this.repositoryType,
    this.mapDetails,
  });

  String id;
  String branchName;
  String repositoryType;
  List<PurpleMapDetail> mapDetails;

  factory BoardIdRepository.fromJson(Map<String, dynamic> json) =>
      BoardIdRepository(
        id: json["id"],
        branchName: json["branch_name"] == null ? null : json["branch_name"],
        repositoryType: json["repository_type"],
        mapDetails: json["mapDetails"] == null
            ? null
            : List<PurpleMapDetail>.from(
                json["mapDetails"].map((x) => PurpleMapDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName == null ? null : branchName,
        "repository_type": repositoryType,
        "mapDetails": mapDetails == null
            ? null
            : List<dynamic>.from(mapDetails.map((x) => x.toJson())),
      };
}

class PurpleMapDetail {
  PurpleMapDetail({
    this.classId,
    this.id,
    this.boardId,
  });

  String classId;
  String id;
  String boardId;

  factory PurpleMapDetail.fromJson(Map<String, dynamic> json) =>
      PurpleMapDetail(
        classId: json["classId"],
        id: json["_id"] == null ? null : json["_id"],
        boardId: json["boardId"] == null ? null : json["boardId"],
      );

  Map<String, dynamic> toJson() => {
        "classId": classId,
        "_id": id == null ? null : id,
        "boardId": boardId == null ? null : boardId,
      };
}

class ClassId {
  ClassId({
    this.repository,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.createdBy,
    this.v,
    this.sequenceNumber,
  });

  List<BoardIdRepository> repository;
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String createdBy;
  int v;
  int sequenceNumber;

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        repository: List<BoardIdRepository>.from(
            json["repository"].map((x) => BoardIdRepository.fromJson(x))),
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        createdBy: json["createdBy"],
        v: json["__v"],
        sequenceNumber: json["sequence_number"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "createdBy": createdBy,
        "__v": v,
        "sequence_number": sequenceNumber,
      };
}

class SubjectId {
  SubjectId({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.repository,
    this.createdBy,
    this.updatedBy,
    this.v,
  });

  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  List<SubjectIdRepository> repository;
  String createdBy;
  String updatedBy;
  int v;

  factory SubjectId.fromJson(Map<String, dynamic> json) => SubjectId(
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        repository: List<SubjectIdRepository>.from(
            json["repository"].map((x) => SubjectIdRepository.fromJson(x))),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "__v": v,
      };
}

class SubjectIdRepository {
  SubjectIdRepository({
    this.id,
    this.repositoryType,
    this.mapDetails,
  });

  String id;
  String repositoryType;
  List<FluffyMapDetail> mapDetails;

  factory SubjectIdRepository.fromJson(Map<String, dynamic> json) =>
      SubjectIdRepository(
        id: json["id"],
        repositoryType: json["repository_type"],
        mapDetails: List<FluffyMapDetail>.from(
            json["mapDetails"].map((x) => FluffyMapDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "repository_type": repositoryType,
        "mapDetails": List<dynamic>.from(mapDetails.map((x) => x.toJson())),
      };
}

class FluffyMapDetail {
  FluffyMapDetail({
    this.id,
    this.syllabuseId,
    this.boardId,
    this.classId,
  });

  String id;
  String syllabuseId;
  String boardId;
  String classId;

  factory FluffyMapDetail.fromJson(Map<String, dynamic> json) =>
      FluffyMapDetail(
        id: json["_id"],
        syllabuseId: json["syllabuseId"] == null ? null : json["syllabuseId"],
        boardId: json["boardId"],
        classId: json["classId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "syllabuseId": syllabuseId == null ? null : syllabuseId,
        "boardId": boardId,
        "classId": classId,
      };
}

class SyllabusId {
  SyllabusId({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.repository,
    this.createdBy,
    this.v,
  });

  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  List<BoardIdRepository> repository;
  String createdBy;
  int v;

  factory SyllabusId.fromJson(Map<String, dynamic> json) => SyllabusId(
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        repository: List<BoardIdRepository>.from(
            json["repository"].map((x) => BoardIdRepository.fromJson(x))),
        createdBy: json["createdBy"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "createdBy": createdBy,
        "__v": v,
      };
}
