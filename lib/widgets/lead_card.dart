import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lead_model.dart';
import '../providers/app_provider.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  final bool isSavedView;

  const LeadCard({super.key, required this.lead, this.isSavedView = false});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isSaved = provider.isLeadSaved(lead);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    lead.companyName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ),
                Chip(
                  label: Text(lead.country),
                  backgroundColor: Colors.amber.shade100,
                  labelStyle: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'التصنيف: ${lead.category}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const Divider(height: 16),
            Row(
              children: [
                _buildStatusBadge(
                    'موقع إلكتروني',
                    lead.hasWebsite,
                    Icons.web),
                const SizedBox(width: 12),
                _buildStatusBadge(
                    'تطبيق جوال',
                    lead.hasApp,
                    Icons.phone_android),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    lead.contactEmail,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  lead.phoneNumber,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (lead.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ملاحظات: ${lead.notes}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.teal),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('تواصل وعرض الموقع'),
                  onPressed: () async {
                    bool success = await provider.pitchCompanyDirectly(lead);
                    if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('تعذر فتح تطبيق البريد للتواصل')),
                      );
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSaved ? Colors.red.shade50 : Colors.indigo.shade50,
                    foregroundColor: isSaved ? Colors.red : Colors.indigo,
                    elevation: 0,
                  ),
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_add_outlined),
                  label: Text(isSaved ? 'إزالة من المحفوظات' : 'حفظ وإرسال لاحقاً'),
                  onPressed: () => provider.toggleSaveLead(lead),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String title, bool status, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: status ? Colors.green : Colors.red),
        const SizedBox(width: 4),
        Text(
          '$title: ${status ? "متوفر" : "غير متوفر ❌"}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: status ? Colors.green.shade800 : Colors.red.shade800,
          ),
        ),
      ],
    );
  }
}