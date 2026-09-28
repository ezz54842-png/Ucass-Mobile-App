import 'package:flutter/material.dart';
import 'models.dart';

const services = <ServiceItem>[
  ServiceItem('إفادة طالب', 'إصدار إفادة إلكترونية ومتابعة الطلب', 'القبول والتسجيل', Icons.description_rounded, Color(0xFFEAF4FF)),
  ServiceItem('كشف درجات', 'طلب كشف درجات رسمي أو غير رسمي', 'القبول والتسجيل', Icons.fact_check_rounded, Color(0xFFEAF4FF)),
  ServiceItem('إضافة / سحب مساق', 'تعديل التسجيل ضمن الفترة المتاحة', 'الخدمات الأكاديمية', Icons.edit_calendar_rounded, Color(0xFFEAF4FF)),
  ServiceItem('تغيير شعبة', 'طلب تغيير شعبة لمساق مسجل', 'الخدمات الأكاديمية', Icons.swap_horiz_rounded, Color(0xFFEAF4FF)),
  ServiceItem('مراجعة علامة', 'إرسال اعتراض ومتابعة قرار القسم', 'الخدمات الأكاديمية', Icons.school_rounded, Color(0xFFEAF4FF)),
  ServiceItem('طلب استثناء', 'طلب استثناء أكاديمي مع مرفقات', 'الخدمات الأكاديمية', Icons.rule_rounded, Color(0xFFEAF4FF)),
  ServiceItem('تأجيل فصل', 'تقديم طلب تأجيل فصل دراسي', 'الخدمات الأكاديمية', Icons.pause_circle_rounded, Color(0xFFEAF4FF)),
  ServiceItem('طلب تخرج', 'بدء إجراءات التخرج والمتابعة', 'الخدمات الأكاديمية', Icons.workspace_premium_rounded, Color(0xFFEAF4FF)),
  ServiceItem('كشف حساب مالي', 'عرض الرسوم والحركات المالية', 'الخدمات المالية', Icons.account_balance_wallet_rounded, Color(0xFFECF8E8)),
  ServiceItem('طلب تقسيط', 'إرسال طلب تقسيط للرسوم المستحقة', 'الخدمات المالية', Icons.payments_rounded, Color(0xFFECF8E8)),
  ServiceItem('طلب منحة / مساعدة', 'التقديم للمساعدات والمنح المتاحة', 'الخدمات المالية', Icons.volunteer_activism_rounded, Color(0xFFECF8E8)),
  ServiceItem('حجز موعد', 'حجز موعد مع قسم أو دائرة', 'الحجوزات', Icons.event_available_rounded, Color(0xFFFFF2E7)),
  ServiceItem('حجز قاعة أو مختبر', 'حجز مرفق حسب الصلاحية', 'الحجوزات', Icons.meeting_room_rounded, Color(0xFFFFF2E7)),
  ServiceItem('دعم فني', 'فتح تذكرة دعم ومتابعتها', 'الدعم الفني', Icons.support_agent_rounded, Color(0xFFE8F6FF)),
  ServiceItem('شكوى أو اقتراح', 'إرسال ملاحظة للجهة المختصة', 'شؤون الطلبة', Icons.forum_rounded, Color(0xFFF2ECFF)),
  ServiceItem('نشاط طلابي', 'الاطلاع والتسجيل في الأنشطة', 'شؤون الطلبة', Icons.groups_rounded, Color(0xFFF2ECFF)),
];

const studentCourses = <CourseItem>[
  CourseItem(code: 'IT402', name: 'تصميم تجربة وواجهة المستخدم', instructor: 'د. محمد أحمد', room: 'A101', time: '09:00 - 10:30', attendance: 92, grade: 87),
  CourseItem(code: 'IT405', name: 'قواعد البيانات', instructor: 'د. أحمد سالم', room: 'B205', time: '11:00 - 12:30', attendance: 88, grade: 91),
  CourseItem(code: 'IT410', name: 'الذكاء الاصطناعي', instructor: 'م. سارة علي', room: 'LAB 3', time: '13:00 - 14:30', attendance: 95, grade: 88),
];

const instructorCourses = <CourseItem>[
  CourseItem(code: 'UX301', name: 'مقدمة في UX/UI', instructor: 'أنت', room: 'B203', time: '09:00 - 10:30', students: 35),
  CourseItem(code: 'WEB202', name: 'تصميم الويب', instructor: 'أنت', room: 'LAB 2', time: '11:00 - 12:30', students: 31),
  CourseItem(code: 'AI101', name: 'مقدمة في الذكاء الاصطناعي', instructor: 'أنت', room: 'A110', time: '13:00 - 14:30', students: 42),
];

const announcementsSeed = <AnnouncementItem>[
  AnnouncementItem('تعديل موعد امتحان UX/UI', 'تم نقل الامتحان إلى يوم الخميس الساعة 10:00 صباحاً.', 'القسم الأكاديمي', '28/09/2026'),
  AnnouncementItem('فتح باب التسجيل للأنشطة', 'يمكن للطلبة التسجيل في الأنشطة الطلابية من خلال التطبيق.', 'شؤون الطلبة', '27/09/2026'),
  AnnouncementItem('تنبيه مالي', 'يرجى مراجعة الرصيد المالي قبل بدء التسجيل للفصل القادم.', 'الدائرة المالية', '26/09/2026'),
];
