import 'package:flutter/material.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({super.key});

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  final searchController = TextEditingController();

  final countries = const [
    {
      'name': 'Poland',
      'capital': 'Warsaw',
      'region': 'Europe',
      'flag': '🇵🇱',
      'population': '37 600 000',
    },
    {
      'name': 'Germany',
      'capital': 'Berlin',
      'region': 'Europe',
      'flag': '🇩🇪',
      'population': '83 000 000',
    },
    {
      'name': 'Japan',
      'capital': 'Tokyo',
      'region': 'Asia',
      'flag': '🇯🇵',
      'population': '125 000 000',
    },
    {
      'name': 'Canada',
      'capital': 'Ottawa',
      'region': 'North America',
      'flag': '🇨🇦',
      'population': '39 000 000',
    },
    {
      'name': 'Brazil',
      'capital': 'Brasília',
      'region': 'South America',
      'flag': '🇧🇷',
      'population': '203 000 000',
    },
  ];

  List<Map<String, String>> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = List<Map<String, String>>.from(countries);
  }

  void searchCountry(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredCountries = countries.where((country) {
        final name = country['name']!.toLowerCase();
        final capital = country['capital']!.toLowerCase();
        final region = country['region']!.toLowerCase();

        return name.contains(lowerQuery) ||
            capital.contains(lowerQuery) ||
            region.contains(lowerQuery);
      }).toList();
    });
  }

  void showCountryDetails(Map<String, String> country) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(country['flag']!, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(
                country['name']!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(label: 'Stolica', value: country['capital']!),
              _InfoRow(label: 'Region', value: country['region']!),
              _InfoRow(label: 'Populacja', value: country['population']!),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    debugPrint('Oznaczono jako odwiedzony: ${country['name']}');
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Oznaczono jako odwiedzony: ${country['name']}',
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
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kraje')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: searchCountry,
              decoration: const InputDecoration(
                hintText: 'Szukaj kraju, stolicy lub regionu...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredCountries.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final country = filteredCountries[index];

                return ListTile(
                  leading: Text(
                    country['flag']!,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(country['name']!),
                  subtitle: Text(country['capital']!),
                  trailing: Text(country['region']!),
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
