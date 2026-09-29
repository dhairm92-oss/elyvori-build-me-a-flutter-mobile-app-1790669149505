import 'package:flutter/foundation.dart';
import '../models/lead_model.dart';
import '../services/market_service.dart';
import '../services/email_dispatch_service.dart';

class AppProvider with ChangeNotifier {
  final MarketService _marketService = MarketService();

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  List<LeadModel> _discoveredLeads = [];
  List<LeadModel> get discoveredLeads => _discoveredLeads;

  List<LeadModel> _savedLeads = [];
  List<LeadModel> get savedLeads => _savedLeads;

  String _selectedCountry = 'الكل';
  String get selectedCountry => _selectedCountry;

  String _mohammedEmail = 'mohammed.dhair@example.com';
  String get mohammedEmail => _mohammedEmail;

  AppProvider() {
    loadSaved();
  }

  void setCountryFilter(String country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void setMohammedEmail(String email) {
    _mohammedEmail = email;
    notifyListeners();
  }

  Future<void> scanGulfMarket() async {
    _isScanning = true;
    notifyListeners();

    try {
      _discoveredLeads = await _marketService.searchGulfMarket(countryFilter: _selectedCountry);
    } catch (e) {
      debugPrint('Scan error: $e');
    }

    _isScanning = false;
    notifyListeners();
  }

  Future<void> loadSaved() async {
    _savedLeads = await _marketService.loadSavedLeads();
    notifyListeners();
  }

  Future<void> toggleSaveLead(LeadModel lead) async {
    bool isAlreadySaved = _savedLeads.any((l) => l.id == lead.id);
    if (isAlreadySaved) {
      await _marketService.removeLead(lead.id);
    } else {
      await _marketService.saveLead(lead);
    }
    await loadSaved();
  }

  bool isLeadSaved(LeadModel lead) {
    return _savedLeads.any((l) => l.id == lead.id);
  }

  Future<bool> sendAllDetailsToEmail() async {
    if (_savedLeads.isEmpty) return false;
    return await EmailDispatchService.sendReportToMohammed(
      mohammedEmail: _mohammedEmail,
      leads: _savedLeads,
    );
  }

  Future<bool> pitchCompanyDirectly(LeadModel lead) async {
    return await EmailDispatchService.pitchCompany(lead);
  }
}
