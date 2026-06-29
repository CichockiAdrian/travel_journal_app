import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/photo_gallery_photo.dart';
import '../data/photo_gallery_repository.dart';
import '../logic/photo_gallery_cubit.dart';
import '../logic/photo_gallery_state.dart';
import 'photo_preview_page.dart';

class PhotoGalleryPage extends StatelessWidget {
  const PhotoGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoGalleryCubit(
        photoGalleryRepository: getIt<PhotoGalleryRepository>(),
      )..loadPhotos(),
      child: const _PhotoGalleryView(),
    );
  }
}

class _PhotoGalleryView extends StatelessWidget {
  const _PhotoGalleryView();

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(translations.photos)),
      body: BlocBuilder<PhotoGalleryCubit, PhotoGalleryState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (photos) {
              if (photos.isEmpty) {
                return _EmptyGalleryView(
                  title: translations.noPhotosYet,
                  subtitle: translations.takeFirstPhotoHint,
                );
              }

              return _PhotoGrid(photos: photos);
            },
            error: () => Center(child: Text(translations.cannotLoadPhotos)),
          );
        },
      ),
    );
  }
}

class _EmptyGalleryView extends StatelessWidget {
  const _EmptyGalleryView({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.photos});

  final List<PhotoGalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final crossAxisCount = screenWidth >= 700 ? 4 : 3;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];

        return _PhotoGridItem(photo: photo);
      },
    );
  }
}

class _PhotoGridItem extends StatelessWidget {
  const _PhotoGridItem({required this.photo});

  final PhotoGalleryPhoto photo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cubit = context.read<PhotoGalleryCubit>();

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: PhotoPreviewPage(photo: photo),
            ),
          ),
        );
      },
      child: Hero(
        tag: photo.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(photo.filePath),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return const ColoredBox(
                color: Colors.black12,
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),
        ),
      ),
    );
  }
}
