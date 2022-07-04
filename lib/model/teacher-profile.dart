class TeacherAchievements {
  String title;
  String teacherId;
  String classId;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  TeacherAchievements({
    this.classId,
    this.createdAt,
    this.description,
    this.id,
    this.teacherId,
    this.title,
    this.updatedAt,
  });

  factory TeacherAchievements.fromJson(Map<String, dynamic> data) {
    return TeacherAchievements(
      id: data['_id'],
      title: data['title'],
      classId: data['class_id'],
      teacherId: data['teacher_id'],
      description: data['description'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "class_id": classId,
      "teacher_id": teacherId,
      "description": description
    };
  }
}

class TeacherAchievementsResponse {
  String message;
  List<TeacherAchievements> data;
  int status;

  TeacherAchievementsResponse({this.data, this.message, this.status});
  factory TeacherAchievementsResponse.fromJson(Map<String, dynamic> data) {
    return TeacherAchievementsResponse(
      data: List<TeacherAchievements>.from(
        data['data'].map((e) => TeacherAchievements.fromJson(e)),
      ),
      status: data['status'],
      message: data['message'],
    );
  }
}

class TeacherSkills {
  List<String> skills;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String classId;
  String teacherId;

  TeacherSkills({
    this.classId,
    this.createdAt,
    this.id,
    this.skills,
    this.teacherId,
    this.updatedAt,
  });
  factory TeacherSkills.fromJson(Map<String, dynamic> data) => TeacherSkills(
        classId: data['class_id'],
        teacherId: data['teacher_id'],
        skills: List<String>.from(data['skill'].map((e) => e)),
        createdAt: DateTime.parse(data['createdAt']),
        updatedAt: DateTime.parse(data['updatedAt']),
      );

  Map<String, dynamic> toJson() {
    return {
      "class_id": classId,
      "teacher_id": teacherId,
      "skill": List<dynamic>.from(skills.map((e) => e)),
    };
  }
}

class TeacherSkillsResponse {
  String message;
  List<TeacherSkills> data;
  int status;

  TeacherSkillsResponse({this.data, this.message, this.status});
  factory TeacherSkillsResponse.fromJson(Map<String, dynamic> data) {
    return TeacherSkillsResponse(
      data: List<TeacherSkills>.from(
        data['data'].map((e) => TeacherSkills.fromJson(e)),
      ),
      status: data['status'],
      message: data['message'],
    );
  }
}
