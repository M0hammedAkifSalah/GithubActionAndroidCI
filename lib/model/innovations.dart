import '../model/user.dart';

class InnovationList {
  List<Innovation> innovations;
  InnovationList({this.innovations});

  factory InnovationList.fromJson(Map<String, dynamic> data) {
    return InnovationList(
      innovations: List<Innovation>.from(
        data['data'].map((e) => Innovation.fromJson(e)),
      ),
    );
  }
}

class Innovation {
  String id;
  List<String> likeBy;
  List<String> viewBy;
  List<String> categoryList;
  DateTime createdBy;
  StudentInfo submittedBy;
  String title;
  String about;
  List<String> tags;
  List<String> files;
  String category;
  bool liked;
  int like;
  int view;
  List<String> teacherId;
  String publishedWith;
  String published;
  String teacherNote;
  int coin;
  int v;
  Innovation({
    this.id,
    this.about,
    this.category,
    this.categoryList,
    this.createdBy,
    this.files,
    this.likeBy,
    this.published,
    this.publishedWith = '',
    this.submittedBy,
    this.tags,
    this.like,
    this.view,
    this.teacherId,
    this.liked,
    this.title,
    this.v,
    this.viewBy,
    this.coin,
    this.teacherNote,
  });

  factory Innovation.fromJson(Map<String, dynamic> data) => Innovation(
        files: List<String>.from(
          data['files'].map((e) => e),
        ),
        likeBy: List<String>.from(
          data['like_by'].map((e) => e),
        ),
        viewBy: List<String>.from(
          data['view_by'].map((e) => e),
        ),
        categoryList: data['category'] != null
            ? List<String>.from(
                data['category'].map((e) => e),
              )
            : [],
        about: data['about'],
        createdBy: DateTime.parse(data['created_by']),
        id: data['_id'],
        published: data['published'],
        submittedBy: data['submitted_by'] != null
            ? StudentInfo.fromJson(data['submitted_by'])
            : data['submitted_by'],
        tags: List<String>.from(
          data['tags'].map((e) => e),
        ),
        teacherId: List<String>.from(data['teacher_id'].map((e)=>e)),
        title: data['title'],
        coin: data['coin'],
        like: data['like'] ?? 0,
        view: data['view'] ?? 0,
        teacherNote: data['teacher_note'],
        v: data['__v'],
      );

  Map<String, dynamic> toJson() {
    return {
      "teacher_note": teacherNote,
      "coin": coin,
      "published": published,
      "published_with": "School",
    };
  }
}
