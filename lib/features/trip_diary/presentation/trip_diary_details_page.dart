import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/trip_diary_entry.dart';
import '../data/trip_diary_local_photo_storage.dart';
import '../data/trip_diary_photo.dart';
import '../logic/trip_diary_cubit.dart';
import 'trip_diary_photo_carousel_page.dart';

class TripDiaryDetailsPage extends StatelessWidget {
  final TripDiaryEntry entry;

  const TripDiaryDetailsPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    final title = _displayText(entry.title, translations.noData);
    final description = _displayText(entry.description, translations.noData);
    final countryLabel = _displayText(
      entry.countryName,
      _displayText(entry.countryCode, translations.noData),
    );
    final flagUrl = entry.countryFlagUrl?.trim();

    final date = entry.travelDate == null
        ? translations.noData
        : DateFormat.yMMMd(locale).format(entry.travelDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.tripDiaryDetails),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(date),
          const SizedBox(height: 16),
          Wrap(
            children: [
              Chip(
                avatar: _CountryFlagAvatar(flagUrl: flagUrl),
                label: Text(countryLabel),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TripDiaryPhotosSection(entryId: entry.id),
          const SizedBox(height: 16),
          Text(description),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final translations = AppLocalizations.of(context);
    final tripDiaryCubit = context.read<TripDiaryCubit>();
    final navigator = Navigator.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(translations.deleteTripDiaryEntry),
          content: Text(translations.deleteTripDiaryEntryConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(translations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(translations.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await tripDiaryCubit.deleteEntry(entry.id);

    navigator.pop();
  }

  String _displayText(String? value, String fallback) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return fallback;
    }

    return trimmedValue;
  }
}

class _TripDiaryPhotosSection extends StatefulWidget {
  final String entryId;

  const _TripDiaryPhotosSection({required this.entryId});

  @override
  State<_TripDiaryPhotosSection> createState() =>
      _TripDiaryPhotosSectionState();
}

class _TripDiaryPhotosSectionState extends State<_TripDiaryPhotosSection> {
  late final Stream<List<TripDiaryPhoto>> _photosStream;

  @override
  void initState() {
    super.initState();
    _photosStream = context.read<TripDiaryCubit>().watchPhotosForEntry(
      widget.entryId,
    );
  }

  Future<List<File>> _loadLocalFiles(List<TripDiaryPhoto> photos) async {
    final storage = getIt<TripDiaryLocalPhotoStorage>();

    final files = await Future.wait(
      photos.map((photo) {
        return storage.findPhoto(photo.localFileName);
      }),
    );

    return files.whereType<File>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return StreamBuilder<List<TripDiaryPhoto>>(
      stream: _photosStream,
      builder: (context, snapshot) {
        final photos = snapshot.data ?? const <TripDiaryPhoto>[];

        if (photos.isEmpty) {
          return const SizedBox.shrink();
        }

        return FutureBuilder<List<File>>(
          future: _loadLocalFiles(photos),
          builder: (context, filesSnapshot) {
            final files = filesSnapshot.data ?? const <File>[];

            if (filesSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (files.isEmpty) {
              return const _MissingLocalPhotoTile(height: 220);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translations.tripDiaryPhotos,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _TripDiaryPostPhotos(files: files),
              ],
            );
          },
        );
      },
    );
  }
}

class _TripDiaryPostPhotos extends StatefulWidget {
  final List<File> files;

  const _TripDiaryPostPhotos({required this.files});

  @override
  State<_TripDiaryPostPhotos> createState() => _TripDiaryPostPhotosState();
}

class _TripDiaryPostPhotosState extends State<_TripDiaryPostPhotos> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant _TripDiaryPostPhotos oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_selectedIndex >= widget.files.length) {
      _selectedIndex = 0;
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreenCarousel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TripDiaryPhotoCarouselPage(
          photoPaths: widget.files.map((file) => file.path).toList(),
          initialIndex: _selectedIndex,
        ),
      ),
    );
  }

  void _selectPhoto(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final files = widget.files;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openFullscreenCarousel,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: files.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.file(
                        files[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const _MissingLocalPhotoTile();
                        },
                      );
                    },
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          '${_selectedIndex + 1}/${files.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.open_in_full,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (files.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => _selectPhoto(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        files[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const _MissingLocalPhotoTile();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _MissingLocalPhotoTile extends StatelessWidget {
  final double? height;

  const _MissingLocalPhotoTile({this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _CountryFlagAvatar extends StatelessWidget {
  final String? flagUrl;

  const _CountryFlagAvatar({required this.flagUrl});

  @override
  Widget build(BuildContext context) {
    final url = flagUrl?.trim();

    if (url == null || url.isEmpty) {
      return const Icon(Icons.public, size: 18);
    }

    return ClipOval(
      child: Image.network(
        url,
        width: 22,
        height: 22,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Icon(Icons.public, size: 18);
        },
      ),
    );
  }
}
