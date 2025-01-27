import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  
  Future<void> saveToHistory(String data) async {
    
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    history.add(data);
    await prefs.setStringList('history', history);
  }

  
  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }
}
