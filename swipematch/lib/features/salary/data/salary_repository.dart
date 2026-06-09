import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/salary_report_model.dart';
import '../../../shared/constants/supabase_constants.dart';

class SalaryRepository {
  SalaryRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Aggregates salary reports for a (company, role) pair. Case-insensitive
  /// substring search on both fields. Returns null if no reports match.
  Future<SalaryAggregate?> getAggregates({
    String? company,
    String? role,
    int sampleSize = 10,
  }) async {
    var query = _supabase
        .from(SupabaseConstants.salaryReports)
        .select('id, reporter_id, company_name, role_title, salary, currency, city, country, verified, created_at');

    if (company != null && company.trim().isNotEmpty) {
      query = query.ilike('company_name', '%${company.trim()}%');
    }
    if (role != null && role.trim().isNotEmpty) {
      query = query.ilike('role_title', '%${role.trim()}%');
    }

    final rows = await query.order('created_at', ascending: false) as List;

    if (rows.isEmpty) return null;

    final reports = rows
        .map((r) => SalaryReportModel.fromJson(r as Map<String, dynamic>))
        .toList();

    final salaries = reports.map((r) => r.salary).toList()..sort();
    final n = salaries.length;
    int pct(double p) =>
        salaries[(p * (n - 1)).round().clamp(0, n - 1)];

    return SalaryAggregate(
      count: n,
      min: salaries.first,
      max: salaries.last,
      median: pct(0.5),
      p25: pct(0.25),
      p75: pct(0.75),
      currency: reports.first.currency,
      sampleReports: reports.take(sampleSize).toList(),
    );
  }

  /// Returns the most-reported (company, count) pairs for the search empty state.
  Future<List<({String company, int count})>> trendingCompanies({int limit = 6}) async {
    final rows = await _supabase
        .from(SupabaseConstants.salaryReports)
        .select('company_name')
        .limit(500) as List;

    final counts = <String, int>{};
    for (final row in rows) {
      final name = (row as Map)['company_name'] as String? ?? '';
      if (name.isEmpty) continue;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(limit)
        .map((e) => (company: e.key, count: e.value))
        .toList();
  }

  Future<void> submit({
    required String reporterId,
    required String companyName,
    required String roleTitle,
    required int salary,
    String currency = 'USD',
    String? city,
    String? country,
  }) async {
    await _supabase.from(SupabaseConstants.salaryReports).insert({
      'reporter_id': reporterId,
      'company_name': companyName.trim(),
      'role_title': roleTitle.trim(),
      'salary': salary,
      'currency': currency,
      'city': city,
      'country': country,
    });
  }
}
