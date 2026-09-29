import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/lead_card.dart';

class SavedLeadsScreen extends StatelessWidget {
  const SavedLeadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final saved = provider.savedLeads;

        return Scaffold(
          appBar: AppBar(
            title: const Text('الشركات المحفوظة والمرشحة'),
            actions: [
              if (saved.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  tooltip: 'إرسال الكل إلى إيميل محمد ضهير',
                  onPressed: () async {
                    bool success = await provider.sendAllDetailsToEmail();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'تم فتح تطبيق البريد لإرسال التقرير بنجاح'
                              : 'تعذر فتح البريد، تأكد من إعدادات الجهاز'),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          body: saved.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border_rounded,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'لا توجد شركات محفوظة حتى الآن',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'قم ببحث السوق وافظ الشركات التي ليس لديها موقع أو تطبيق لترسلها إلى بريدك الإلكتروني',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.indigo.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Colors.indigo),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'لديك ${saved.length} شركة محفوظة جاهزة للإرسال إلى إيميل: ${provider.mohammedEmail}',
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: saved.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          return LeadCard(
                            lead: saved[index],
                            isSavedView: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: saved.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'ابعتلي هذا كله على الايميل الخاص بي',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      bool success = await provider.sendAllDetailsToEmail();
                      if (context.mounted && !success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تعذر إرسال الإيميل، تحقق من التطبيقات المثبتة'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                )
              : null,
        );
      },
    );
  }
}