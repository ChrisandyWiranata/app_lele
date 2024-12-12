import 'package:intl/intl.dart';

class CurrencyFormat {
  static format(dynamic value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(double.parse(value.toString()));
  }
}