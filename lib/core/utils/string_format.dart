import 'package:intl/intl.dart';

class StringFormat {
  static String formatDateHeader(DateTime date) {
    final formatter = DateFormat('d MMM', 'es');
    return formatter.format(date);
  }
  
  static String formatScheduledDate(DateTime date) {
    final formatter = DateFormat('d \'de\' MMMM, yyyy', 'es');
    return formatter.format(date);
  }
} 