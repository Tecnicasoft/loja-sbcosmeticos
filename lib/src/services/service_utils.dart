import 'dart:math';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UtilsServices {
  String _formatCurrency(double valor) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return numberFormat.format(valor);
  }

  String formatDecimalToIntWhitPorcentagemString(double valor) {
    NumberFormat numberFormat = NumberFormat.decimalPattern();
    return '${numberFormat.format(valor)}% OFF';
  }

  String formatDecimalToIntWhitPorcentagemPrimeiraCompraString(double valor) {
    NumberFormat numberFormat = NumberFormat.decimalPattern();
    return '${numberFormat.format(valor)}% OFF na Primeira Compra';
  }

  String formatDate(DateTime dateTime) {
    initializeDateFormatting();
    DateFormat dateFormat = DateFormat.yMd('pt_BR').add_Hm();
    return dateFormat.format(dateTime);
  }

  String toFixed(String value, [int decimalPlace = 2]) {
    try {
      String originalNumber = value.toString();
      List<String> formattedNumber = originalNumber.split('.');
      return _formatCurrency(
          double.parse("${formattedNumber[0]}.${formattedNumber[1]}"));
    } catch (_) {}
    if (value == "0.0" || value == "0" || value == "0.00") {
      return "R\$ 0,00";
    }
    return value.toString();
  }

  // String toFixed(String value, [int decimalPlace = 2]) {
  //   try {
  //     String originalNumber = value.toString();
  //     List<String> formattedNumber = originalNumber.split('.');
  //     return _formatCurrency(double.parse(
  //         "${formattedNumber[0]}.${formattedNumber[1].substring(0, decimalPlace)}"));
  //   } catch (_) {}
  //   if (value == "0.0" || value == "0" || value == "0.00") {
  //     return "R\$ 0,00";
  //   }
  //   return value.toString();
  // }

  String toFixedNotCurrency(String value, [int decimalPlace = 1]) {
    try {
      String originalNumber = value.toString();
      List<String> formattedNumber = originalNumber.split('.');
      return "${formattedNumber[0]}.${formattedNumber[1].substring(0, decimalPlace)}";
    } catch (_) {}
    return value.toString();
  }

  double roundDouble(double value, int places) {
    var mod = pow(value, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
