import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  return formatter.format(amount);
}

String formatDateString(String dateString) {
  // Parse the date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Create a formatter with the desired format
  final formatter = DateFormat('dd-MM-yyyy (HH:mm)');

  // Format the DateTime object to a string
  return formatter.format(dateTime);
}
