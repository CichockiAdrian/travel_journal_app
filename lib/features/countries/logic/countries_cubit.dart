import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/countries_repository.dart';
import 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  final CountriesRepository countriesRepository;

  static const int pageSize = 20;

  CountriesCubit({required this.countriesRepository})
    : super(const CountriesState.initial());

  Future<void> loadAllCountries() async {
    emit(
      state.copyWith(
        status: CountriesStatus.loading,
        errorMessage: null,
        currentPage: 1,
      ),
    );

    try {
      final countries = await countriesRepository.getAllCountries();

      countries.sort((a, b) => a.name.compareTo(b.name));

      emit(
        state.copyWith(
          status: CountriesStatus.success,
          allCountries: countries,
          filteredCountries: countries,
          visibleCountries: countries.take(pageSize).toList(),
          hasMore: countries.length > pageSize,
          currentPage: 1,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CountriesStatus.failure,
          allCountries: [],
          filteredCountries: [],
          visibleCountries: [],
          hasMore: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void searchCountries(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(
        state.copyWith(
          status: CountriesStatus.success,
          filteredCountries: state.allCountries,
          visibleCountries: state.allCountries.take(pageSize).toList(),
          hasMore: state.allCountries.length > pageSize,
          currentPage: 1,
          errorMessage: null,
        ),
      );
      return;
    }

    final lowerQuery = trimmedQuery.toLowerCase();

    final filtered = state.allCountries.where((country) {
      final name = country.name.toLowerCase();
      final capital = country.capital?.toLowerCase() ?? '';
      final region = country.region.toLowerCase();

      return name.contains(lowerQuery) ||
          capital.contains(lowerQuery) ||
          region.contains(lowerQuery);
    }).toList();

    emit(
      state.copyWith(
        status: CountriesStatus.success,
        filteredCountries: filtered,
        visibleCountries: filtered.take(pageSize).toList(),
        hasMore: filtered.length > pageSize,
        currentPage: 1,
        errorMessage: null,
      ),
    );
  }

  void loadMore() {
    if (!state.hasMore || state.isLoading) return;

    final nextPage = state.currentPage + 1;
    final nextItems = state.filteredCountries
        .take(nextPage * pageSize)
        .toList();

    emit(
      state.copyWith(
        visibleCountries: nextItems,
        currentPage: nextPage,
        hasMore: nextItems.length < state.filteredCountries.length,
      ),
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
