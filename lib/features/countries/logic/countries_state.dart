import '../data/country_model.dart';

enum CountriesStatus { initial, loading, success, failure }

class CountriesState {
  final CountriesStatus status;
  final List<CountryModel> allCountries;
  final List<CountryModel> filteredCountries;
  final List<CountryModel> visibleCountries;
  final String? errorMessage;
  final bool hasMore;
  final int currentPage;

  const CountriesState({
    required this.status,
    required this.allCountries,
    required this.filteredCountries,
    required this.visibleCountries,
    required this.errorMessage,
    required this.hasMore,
    required this.currentPage,
  });

  const CountriesState.initial()
    : status = CountriesStatus.initial,
      allCountries = const [],
      filteredCountries = const [],
      visibleCountries = const [],
      errorMessage = null,
      hasMore = false,
      currentPage = 1;

  bool get isLoading => status == CountriesStatus.loading;

  CountriesState copyWith({
    CountriesStatus? status,
    List<CountryModel>? allCountries,
    List<CountryModel>? filteredCountries,
    List<CountryModel>? visibleCountries,
    String? errorMessage,
    bool? hasMore,
    int? currentPage,
  }) {
    return CountriesState(
      status: status ?? this.status,
      allCountries: allCountries ?? this.allCountries,
      filteredCountries: filteredCountries ?? this.filteredCountries,
      visibleCountries: visibleCountries ?? this.visibleCountries,
      errorMessage: errorMessage,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
