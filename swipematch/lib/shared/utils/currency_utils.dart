import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

  static String format(int amount, {String? currencyCode}) {
    final code = currencyCode ?? _deviceCurrency();
    final formatter = NumberFormat.compactSimpleCurrency(name: code);
    return formatter.format(amount);
  }

  static String formatRange(int min, int max, {String? currencyCode}) {
    return '${format(min, currencyCode: currencyCode)} – ${format(max, currencyCode: currencyCode)}';
  }

  static String _deviceCurrency() {
    try {
      final locale = Intl.getCurrentLocale();
      final format = NumberFormat.simpleCurrency(locale: locale);
      return format.currencyName ?? 'USD';
    } catch (_) {
      return 'USD';
    }
  }
}
