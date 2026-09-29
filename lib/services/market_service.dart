import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lead_model.dart';

class MarketService {
  static const String _storageKey = 'saved_leads_mohammed_dhair';

  // Simulated Gulf Market Scan focusing on businesses lacking a website or mobile app
  final List<LeadModel> _mockGulfMarketPool = [
    (
      id: 'g1',
      companyName: 'الرياض للمقاولات والتوريدات',
      country: 'المملكة العربية السعودية',
      category: 'مقاولات',
      email: 'riyadh.contracting.info@gmail.com',
      phone: '+966501234567',
      hasWebsite: false,
      hasApp: false,
      notes: 'شركة نشطة جداً في الرياض بدون موقع رسمي ولا تطبيق'
    ),
    (
      id: 'g2',
      companyName: 'مفروشات الواحة دبي',
      country: 'الإمارات العربية المتحدة',
      category: 'أثاث ومفروشات',
      email: 'oasis.furniture.dxb@yahoo.com',
      phone: '+971559876543',
      hasWebsite: false,
      hasApp: false,
      notes: 'معرض كبير في دبي يعتمد فقط على انستجرام'
    ),
    (
      id: 'g3',
      companyName: 'حلويات عُمان الطازجة',
      country: 'سلطنة عُمان',
      category: 'أغذية ومطاعم',
      email: 'oman.sweets.orders@gmail.com',
      phone: '+96891234567',
      hasWebsite: false,
      hasApp: false,
      notes: 'فروع متعددة بمسقط بدون نظام طلبات إلكتروني'
    ),
    (
      id: 'g4',
      companyName: 'مكتب المحامي خالد الكواري',
      country: 'دولة قطر',
      category: 'خدمات قانونية',
      email: 'alkuwari.law.qa@hotmail.com',
      phone: '+97455112233',
      hasWebsite: false,
      hasApp: false,
      notes: 'مكتب محاماة مرموق بحاجة واجهة رقمية تعريفية'
    ),
    (
      id: 'g5',
      companyName: 'مطعم بحر الخليج للمأكولات البحرية',
      country: 'مملكة البحرين',
      category: 'مطاعم',
      email: 'gulf.sea.food.bh@gmail.com',
      phone: '+97339887766',
      hasWebsite: false,
      hasApp: false,
      notes: 'مشهور بالمنامة ولكن ليس لديه تطبيق توصيل خاصة به'
    ),
    (
      id: 'g6',
      companyName: 'سوبرماركت البركة الكويتي',
      country: 'دولة الكويت',
      category: 'تجارة تجزئة',
      email: 'baraka.market.kwt@gmail.com',
      phone: '+96599881122',
      hasWebsite: false,
      hasApp: false,
      notes: 'سوق محلي ضخم بدون متجر إلكتروني'
    ),
  ].map((item) => LeadModel(
        id: item.id,
        companyName: item.companyName,
        country: item.country,
        category: item.category,
        contactEmail: item.email,
        phoneNumber: item.phone,
        hasWebsite: item.hasWebsite,
        hasApp: item.hasApp,
        notes: item.notes,
        discoveredAt: DateTime.now().subtract(Duration(hours: int.parse(item.id.replaceAll('g', '')) * 3)),
      )).toList();

  Future<List<LeadModel>> searchGulfMarket({String? countryFilter}) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 2));
    
    List<LeadModel> results = _mockGulfMarketPool;
    if (countryFilter != null && countryFilter != 'الكل') {
      results = results.where((l) => l.country == countryFilter).toList();
    }
    
    return results;
  }

  Future<List<LeadModel>> loadSavedLeads() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    
    List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => LeadModel.fromJson(item)).toList();
  }

  Future<void> saveLead(LeadModel lead) async {
    final leads = await loadSavedLeads();
    if (!leads.any((l) => l.id == lead.id)) {
      leads.add(lead);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(leads.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> removeLead(String id) async {
    final leads = await loadSavedLeads();
    leads.removeWhere((l) => l.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(leads.map((e) => e.toJson()).toList()));
  }
}
