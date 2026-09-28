import 'package:flutter/material.dart';

enum UserRole { student, instructor, employee }
enum RequestStatus { draft, submitted, review, needsEdit, approved, completed, rejected }

enum TicketStatus { open, processing, closed }

extension RoleLabel on UserRole {
  String get label => switch (this) {
        UserRole.student => 'طالب',
        UserRole.instructor => 'عضو هيئة تدريس',
        UserRole.employee => 'موظف',
      };
}

extension RequestStatusX on RequestStatus {
  String get label => switch (this) {
        RequestStatus.draft => 'مسودة',
        RequestStatus.submitted => 'مرسل',
        RequestStatus.review => 'قيد المراجعة',
        RequestStatus.needsEdit => 'يحتاج تعديل',
        RequestStatus.approved => 'معتمد',
        RequestStatus.completed => 'مكتمل',
        RequestStatus.rejected => 'مرفوض',
      };
  Color get color => switch (this) {
        RequestStatus.draft => Colors.grey,
        RequestStatus.submitted => Colors.blue,
        RequestStatus.review => Colors.orange,
        RequestStatus.needsEdit => Colors.deepOrange,
        RequestStatus.approved => Colors.green,
        RequestStatus.completed => Colors.teal,
        RequestStatus.rejected => Colors.red,
      };
}

class ServiceItem {
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final Color tint;
  const ServiceItem(this.title, this.subtitle, this.category, this.icon, this.tint);
}

class RequestItem {
  final String id;
  final String title;
  final String category;
  final String date;
  final String notes;
  RequestStatus status;
  RequestItem({required this.id, required this.title, required this.category, required this.status, required this.date, this.notes = ''});
}

class CourseItem {
  final String code;
  final String name;
  final String instructor;
  final String room;
  final String time;
  final int students;
  final double attendance;
  final double grade;
  const CourseItem({required this.code, required this.name, required this.instructor, required this.room, required this.time, this.students = 35, this.attendance = 90, this.grade = 0});
}

class AnnouncementItem {
  final String title;
  final String body;
  final String source;
  final String date;
  const AnnouncementItem(this.title, this.body, this.source, this.date);
}

class NotificationItem {
  final String title;
  final String body;
  final IconData icon;
  final String time;
  bool read;
  NotificationItem(this.title, this.body, this.icon, this.time, {this.read = false});
}

class AppointmentItem {
  final String department;
  final String date;
  final String time;
  final String reason;
  AppointmentItem(this.department, this.date, this.time, this.reason);
}

class TicketItem {
  final String id;
  final String title;
  final String department;
  TicketStatus status;
  TicketItem(this.id, this.title, this.department, this.status);
}

class TaskItem {
  final String title;
  final String priority;
  bool done;
  TaskItem(this.title, this.priority, {this.done = false});
}
