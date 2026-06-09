import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/salary_repository.dart';
import 'salary_report_model.dart';

final salaryRepositoryProvider = Provider<SalaryRepository>(
  (ref) => SalaryRepository(Supabase.instance.client),
);

/// Query params for the salary truth screen.
class SalaryQuery {
  const SalaryQuery({this.company, this.role});
  final String? company;
  final String? role;

  bool get isEmpty =>
      (company?.trim().isEmpty ?? true) && (role?.trim().isEmpty ?? true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryQuery && other.company == company && other.role == role;

  @override
  int get hashCode => Object.hash(company, role);
}

final salaryQueryProvider = StateProvider<SalaryQuery>((_) => const SalaryQuery());

final salaryAggregateProvider =
    FutureProvider.autoDispose<SalaryAggregate?>((ref) async {
  final query = ref.watch(salaryQueryProvider);
  if (query.isEmpty) return null;
  final repo = ref.watch(salaryRepositoryProvider);
  return repo.getAggregates(company: query.company, role: query.role);
});

final trendingCompaniesProvider = FutureProvider.autoDispose<
    List<({String company, int count})>>((ref) async {
  final repo = ref.watch(salaryRepositoryProvider);
  return repo.trendingCompanies();
});
