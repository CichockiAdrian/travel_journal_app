import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/photo_gallery_photo.dart';
import '../logic/photo_gallery_cubit.dart';
import 'hide_global_camera_overlay.dart';

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({super.key, required this.photo});

  final PhotoGalleryPhoto photo;

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context);

    return HideGlobalCameraOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations.photoPreview),
          actions: [
            if (photo.tripDiaryEntryId == null)
              IconButton(
                tooltip: translations.deletePhoto,
                onPressed: () => _deletePhoto(context),
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
        body: Center(
          child: Hero(
            tag: photo.id,
            child: InteractiveViewer(
              child: Image.file(
                File(photo.filePath),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return const Icon(Icons.broken_image_outlined);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deletePhoto(BuildContext context) async {
    final translations = AppLocalizations.of(context);

    await context.read<PhotoGalleryCubit>().deletePhoto(photo.id);

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(translations.photoDeleted)));
  }
}
