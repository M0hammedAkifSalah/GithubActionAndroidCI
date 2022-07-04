class ActivityProgress {
  int completed;
  double average;
  int pending;
  int total;
  int reassign;
  int delayedSubmission;

  ActivityProgress(
      {this.completed,
      this.average,
      this.pending,
      this.total,
      this.reassign = 0,
      this.delayedSubmission});

  @override
  String toString() {
    return 'average : $average';
  }

  factory ActivityProgress.fromJson(Map<String, dynamic> progress) {
    int pending = progress['total'] - progress['completed'];
    return ActivityProgress(
      average: progress['average'].toDouble(),
      completed: progress['completed'],
      total: progress['total'],
      pending: progress['pending'] ?? pending,
      reassign: progress['reAssign'],
      delayedSubmission: progress['delayedSubmission'],
    );
  }
}

class AttendanceDetails {
  AttendanceDetails({
    this.attendClass,
    this.total,
    this.average,
  });

  int attendClass;
  int total;
  double average;

  factory AttendanceDetails.fromJson(Map<String, dynamic> json) =>
      AttendanceDetails(
        attendClass: json["AttendClass"],
        total: json["total"],
        average: json['average'] != null ? json["average"].toDouble() : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "AttendClass": attendClass,
        "total": total,
        "average": average,
      };
}

class TotalActivityProgress {
  final int status;
  final int activity;
  final int pendingData;
  final double average;
  TotalActivityProgress({
    this.status = 0,
    this.activity = 0,
    this.pendingData = 0,
    this.average = 0,
  });
  @override
  String toString() {
    return 'pending: $pendingData, average: $average';
  }

  factory TotalActivityProgress.fromJson(Map<dynamic, dynamic> data) {
    return TotalActivityProgress(
      status: data['status'],
      activity: data['actvivity'],
      pendingData: data['pending_data'],
      average: double.parse(data['avg'] ?? 0),
    );
  }
}
