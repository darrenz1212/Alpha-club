import 'package:intl/intl.dart';

String formatPublishedDate(String dateTime) {
  try {
    // Parse string menjadi objek DateTime
    DateTime parsedDate = DateTime.parse(dateTime);

    // Format menjadi "November 28"
    return DateFormat('MMMM d').format(parsedDate);
  } catch (e) {
    // Kembalikan error friendly jika parsing gagal
    return 'Invalid date';
  }
}
