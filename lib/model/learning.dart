import '/model/activity.dart';
import '../model/user.dart';

class LearningDetailsResponse {
  int status;
  int result;
  List<Learnings> details;
  LearningDetailsResponse({
    this.details,
    this.result,
    this.status,
  });

  factory LearningDetailsResponse.fromJson(Map<String, dynamic> data) {
    return LearningDetailsResponse(
      status: data['status'],
      result: data['result'],
      details: List<Learnings>.from(
        data['data'].map((e) => Learnings.fromJson(e)),
      ),
    );
  }
}

class Learnings {
  List<String> tags;
  String id;
  String name;
  List<Repository> repository;
  List<LearningFiles> filesUpload;
  String classId;
  String boardId;
  String chapterId;
  String subjectId;
  String syllabusId;
  String fileName;
  String createdTag;
  int chapterCount;
  String createdBy;
  UploadedFiles uploadingFile;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic topicImage;
  String description;
  Learnings({
    this.boardId,
    this.chapterId,
    this.classId,
    this.chapterCount,
    this.createdAt,
    this.createdBy,
    this.filesUpload,
    this.id,
    this.name,
    this.description,
    this.subjectId,
    this.syllabusId,
    this.tags,
    this.topicImage,
    this.updatedAt,
    this.repository,
  });
  factory Learnings.fromJson(Map<String, dynamic> data) {
    return Learnings(
      boardId: data['board_id'],
      chapterId: data['chapter_id'],
      description: data['description'] ?? '',
      repository: data['repository'] == null
          ? []
          : List<Repository>.from(
              data['repository'].map((e) => Repository.fromJson(e))),
      classId: data['class_id'],
      createdBy: data['created_by'],
      filesUpload: data['files_upload'] != null
          ? List<LearningFiles>.from(
              data['files_upload'].map((e) => LearningFiles.fromJson(e)),
            )
          : null,
      id: data['_id'],
      name: data['name'],
      chapterCount: data['chapterCount'],
      subjectId: data['subject_id'],
      syllabusId: data['syllabus_id'],
      tags: data['tags'] != null
          ? List<String>.from(data['tags'].map((e) => e))
          : [],
      topicImage: data['topic_image'],
    );
  }
  Map<String, dynamic> toJson(bool chapter) {
    return {
      "name": name,
      "about_file": fileName,
      "class_id": classId,
      "subject_id": subjectId,
      "chapter_id": chapterId,
      "tags": createdTag,
      "files_upload": uploadingFile.toJson(chapter)
    };
  }
}

// class LearningGrouped {
//   // String subjectName;
//   // String subjectId;
//   // String chapterName;
//   // String chapterId;
//   // List<UploadedFiles> subjectFiles;
//   LearningDetails subjectDetails;
//   LearningDetails chapterDetails;
//   // Learnings topicDetails;
//   List<LearningGrouped> chapters;
//   List<Learnings> topics;
//   // List<Learnings> chapters;
//   // List<Learnings> topics;

//   LearningGrouped({
//     // this.chapters,
//     // this.subjectFiles,
//     // this.subjectId,
//     // this.subjectName,
//     // this.chapterId,
//     // this.chapterName,
//     // this.topics,
//     this.subjectDetails,
//     this.chapterDetails,
//     // this.topicDetails,
//     this.chapters,
//     this.topics,
//   });

//   @override
//   String toString() {
//     return 'Grouped: ';
//   }
// }

class LearningDetails {
  String id;
  String name;
  List<LearningFiles> filesUploaded;
  LearningDetails({
    this.filesUploaded,
    this.id,
    this.name,
  });

  factory LearningDetails.fromJson(Map<String, dynamic> data) {
    return LearningDetails(
      id: data['_id'],
      filesUploaded: List<LearningFiles>.from(
        data['files_upload'].map((e) => LearningFiles.fromJson(e)),
      ),
      name: data['name'],
    );
  }
}

class UploadedFiles {
  List<LearningFiles> files;
  UploadedFiles({
    this.files,
  });
  factory UploadedFiles.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return UploadedFiles();
    }
    return UploadedFiles(
      files: List<LearningFiles>.from(
        data['files_upload'].map((e) => LearningFiles.fromJson(e)),
      ),
    );
  }
  toJson(bool chapter) {
    if (!chapter) {
      return List<dynamic>.from(files.map((e) => e.toJson()));
    }
    return {"files_upload": List<dynamic>.from(files.map((e) => e.toJson()))};
  }
}

class LearningFiles {
  String file;
  String fileName;
  String id;
  LearningFiles({
    this.file,
    this.id,
    this.fileName,
  });
  factory LearningFiles.fromJson(Map<String, dynamic> data) {
    return LearningFiles(
        file: data['file'], fileName: data['file_name'], id: data['_id']);
  }
  Map<String, dynamic> toJson() {
    return {
      "file_name": fileName,
      "file": '$file',
    };
  }
}

class LearningClassResponse {
  int status;
  List<LearningClassDetails> classData;
  LearningClassResponse({this.classData, this.status});
  factory LearningClassResponse.fromJson(Map<String, dynamic> data) {
    return LearningClassResponse(
      status: data['status'],
      classData: List<LearningClassDetails>.from(
        data['classData'].map((e) => LearningClassDetails.fromJson(e)),
      ),
    );
  }
}

class LearningStudentResponse {
  String status;
  List<StudentInfo> students;
  LearningStudentResponse({this.students, this.status});
  factory LearningStudentResponse.fromJson(Map<String, dynamic> data) {
    return LearningStudentResponse(
      status: data['status'],
      students: List<StudentInfo>.from(
        data['data'].map((e) => StudentInfo.fromJson(e)),
      ),
    );
  }
}

class LearningClassDetails {
  String id;
  String name;
  List repository;
  DateTime createdAt;
  DateTime updatedAt;
  LearningClassDetails({
    this.id,
    this.createdAt,
    this.name,
    this.repository,
    this.updatedAt,
  });
  factory LearningClassDetails.fromJson(Map<String, dynamic> data) {
    return LearningClassDetails(
      id: data['_id'],
      name: data['name'],
      repository: data['repository'] ?? [],
      createdAt:
          data['createdAt'] == null ? null : DateTime.parse(data['createdAt']),
      updatedAt:
          data['updatedAt'] == null ? null : DateTime.parse(data['createdAt']),
    );
  }
}
