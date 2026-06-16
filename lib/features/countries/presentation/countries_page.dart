import 'dart:async';

import 'package:flutter/material.dart';

import '../data/countries_api_service.dart';
import '../data/country_model.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final CountriesApiService apiService = CountriesApiService();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  static const int pageSize = 20;

  List<CountryModel> allCountries = [];
  List<CountryModel> visibleCountries = [];

  bool isLoading = false;
  bool hasMore = false;
  String? errorMessage;
  int currentPage = 1;
  Timer? searchDebounce;

  @override
  void initState() {
    super.initState();

    loadAllCountries();

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent - 250) {
        loadMore();
      }
    });
  }

  Future<void> loadAllCountries() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      currentPage = 1;
    });

    try {
      final countries = await apiService.getAllCountries();

      countries.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        allCountries = countries;
        visibleCountries = countries.take(pageSize).toList();
        hasMore = countries.length > pageSize;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        allCountries = [];
        visibleCountries = [];
        hasMore = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onSearchChanged(String value) {
    searchDebounce?.cancel();

    searchDebounce = Timer(const Duration(milliseconds: 500), () {
      final query = value.trim();

      if (query.isEmpty) {
        setState(() {
          currentPage = 1;
          visibleCountries = allCountries.take(pageSize).toList();
          errorMessage = null;
        });
        return;
      }

      searchCountriesLocally(query);
    });
  }

  void searchCountriesLocally(String query) {
    final lowerQuery = query.toLowerCase();

    final filtered = allCountries.where((country) {
      final name = country.name.toLowerCase();
      final capital = country.capital?.toLowerCase() ?? '';
      final region = country.region.toLowerCase();

      return name.contains(lowerQuery) ||
          capital.contains(lowerQuery) ||
          region.contains(lowerQuery);
    }).toList();

    setState(() {
      currentPage = 1;
      visibleCountries = filtered.take(pageSize).toList();
      hasMore = filtered.length > pageSize;
    });
  }

  void loadMore() {
    if (!hasMore || isLoading) return;

    final nextPage = currentPage + 1;
    final nextItems = allCountries.take(nextPage * pageSize).toList();

    setState(() {
      currentPage = nextPage;
      visibleCountries = nextItems;
      hasMore = nextItems.length < allCountries.length;
    });
  }

  void showCountryDetails(CountryModel country) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (country.flagUrl != null && country.flagUrl!.isNotEmpty)
                Image.network(
                  country.flagUrl!,
                  width: 80,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const Icon(Icons.flag, size: 54);
                  },
                )
              else
                const Icon(Icons.flag, size: 54),

              const SizedBox(height: 12),

              Text(
                country.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              _InfoRow(
                label: 'Stolica',
                value: country.capital ?? 'Brak danych',
              ),
              _InfoRow(label: 'Region', value: country.region),
              _InfoRow(
                label: 'Populacja',
                value: country.population?.toString() ?? 'Brak danych',
              ),
              _InfoRow(
                label: 'Współrzędne',
                value: country.latitude != null && country.longitude != null
                    ? '${country.latitude}, ${country.longitude}'
                    : 'Brak danych',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    debugPrint('Oznaczono jako odwiedzony: ${country.name}');
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Oznaczono jako odwiedzony: ${country.name}',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Oznacz jako odwiedzony'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showInitialLoader = isLoading && visibleCountries.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Kraje')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Szukaj kraju, np. Poland, Canada...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (showInitialLoader)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Nie udało się pobrać krajów.\n\nSprawdź token API, internet albo endpoint.\n\nSzczegóły:\n$errorMessage',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (visibleCountries.isEmpty)
            const Expanded(
              child: Center(child: Text('Brak wyników. Wpisz nazwę kraju.')),
            )
          else
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: visibleCountries.length + 1,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index == visibleCountries.length) {
                    if (!hasMore) {
                      return const SizedBox(height: 24);
                    }

                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final country = visibleCountries[index];

                  return ListTile(
                    leading:
                        country.flagUrl != null && country.flagUrl!.isNotEmpty
                        ? Image.network(
                            country.flagUrl!,
                            width: 42,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return const Icon(Icons.flag);
                            },
                          )
                        : const Icon(Icons.flag),
                    title: Text(country.name),
                    subtitle: Text(country.capital ?? 'Brak stolicy'),
                    trailing: Text(country.region),
                    onTap: () => showCountryDetails(country),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
