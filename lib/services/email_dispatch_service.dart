Filename: email_dispatch_service.dart

import 'package:url_launcher/url_launcher.dart';
import '../models/lead_model.dart';

class EmailDispatchService {
  /// Sends all collected details to MohammedDhair1's email
  static Future<bool> sendReportToMohammed({
    required String mohammedEmail,
    required List<LeadModel> leads,
  })
  async {
    final buffer = StringBuffer();
    buffer.writeln('السلام عليكم محمد ضهير،\
');
    buffer.writeln('إليك تقرير الشركات المستهدفة في السوق الخليجي التي ليس لديها موقع إلكتروني أو تطبيق:\
');
    buffer.writeln('=' * 40);
    
    for (var i = 0; i < leads.length; i++) {
      final lead = leads[i];
      buffer.writeln('\
[${i + 1}] شركة: ${lead.companyName}');
      buffer.writeln('الدولة: ${lead.country}');
      buffer.writeln('التصنيف: ${lead.category}');
      buffer.writeln('البريد للتواصل: ${lead.contactEmail}');
      buffer.writeln('رقم الهاتف: ${lead.phoneNumber}');
      buffer.writeln('موقع إلكتروني: ${lead.hasWebsite ? "يوجد" : "لا يوجد ❌"}');
      buffer.writeln('تطبيق جوال: ${lead.hasApp ? "يوجد" : "لا يوجد ❌"}');
      buffer.writeln('ملاحظات: ${lead.notes}');
      buffer.writeln('-' * 30);
    }
    
    buffer.writeln('\
نتمنى لك التوفيق في التواصل معهم وعرض خدمات التطوير البرمجي.\
');
    buffer.writeln('تم التصدير عبر تطبيق MohammedDhair1 الخاص.');

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: mohammedEmail,
      queryParameters: {
        'subject': 'تقرير فرص السوق الخليجي - شركات بدون مواقع أو تطبيقات',
        'body': buffer.toString(),
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
      return true;
    } else {
      return false;
    }
  }

  /// Sends a direct pitch email TO the target company from Mohammed
  static Future<bool> pitchCompany(LeadModel lead) async {
    final String pitchBody = '''
السلام عليكم ورحمة الله وبركاته،

لاحظنا في 