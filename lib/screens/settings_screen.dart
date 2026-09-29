import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
        text: Provider.of<AppProvider>(context, listen: false).mohammedEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات البريد والمالك'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إيميل محمد ضهير لاستقبال تفاصيل الشركات:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                const SizedBox(height: 8),
                const Text(
                  'هذا البريد سيتم استخدامه لإرسال تقارير الشركات التي لا تمتلك موقعاً أو تطبيقاً.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('حفظ البريد الإلكتروني'),
                  onPressed: () {
                    provider.setMohammedEmail(_emailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم حفظ الإيميل بنجاح!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                const Divider(height: 40),
                const Text(
                  'حول التطبيق',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                const SizedBox(height: 8),
                const Text(
                  'مخصص للمطور محمد ضهير (MohammedDhair1)\nالبحث في السوق الخليجي عن الشركات التي ليس لديها موقع إلكتروني أو تطبيق كامل، التواصل معهم، وعرض خدمات التطوير البرمجي بنجاح.',
                  style: TextStyle(height: 1.5),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}