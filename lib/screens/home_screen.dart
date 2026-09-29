import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/lead_card.dart';
import 'saved_leads_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _countries = [
    'الكل',
    'المملكة العربية السعودية',
    'الإمارات العربية المتحدة',
    'سلطنة عُمان',
    'دولة قطر',
    'مملكة البحرين',
    'دولة الكويت'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MohammedDhair1 - كاشف فرص الخليج'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_added),
            tooltip: 'الشركات المحفوظة',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedLeadsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.indigo.shade800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'البحث في السوق الخليجي عن الشركات بدون موقع أو تطبيق',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ابحث، تواصل، اقترح بناء موقع وتطبيق، وابعث كل التفاصيل لإيميلك الخاص.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'الدولة:',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: provider.selectedCountry,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: _countries.map((c) {
                                return DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  provider.setCountryFilter(val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: provider.isScanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          provider.isScanning
                              ? 'جاري فحص السوق الخليجي...'
                              : 'ابحث في السوق الآن',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: provider.isScanning
                            ? null
                            : () => provider.scanGulfMarket(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.isScanning
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'جاري فحص السوق الخليجي والبحث عن شركات بدون مواقع أو تطبيقات...', 
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    : provider.discoveredLeads.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.radar,
                                      size: 80, color: Colors.indigo.shade200),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'اضغط على زر "ابحث في السوق الآن" لبدء الكشف',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: provider.discoveredLeads.length,
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              return LeadCard(
                                lead: provider.discoveredLeads[index],
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}