class TestTopicModel {
  TestTopicModel({
    this.id,
    this.name,
    this.filesUpload,
    this.description,
  });

  String id;
  String name;
  List<dynamic> filesUpload;
  String description;

  factory TestTopicModel.fromJson(Map<String, dynamic> json) => TestTopicModel(
        id: json["_id"],
        name: json["name"],
        filesUpload: List<dynamic>.from(json["files_upload"].map((x) => x)),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "files_upload": List<dynamic>.from(filesUpload.map((x) => x)),
        "description": description,
      };
}
