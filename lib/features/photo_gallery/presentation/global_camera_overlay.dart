import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/navigation/app_navigator_key.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/photo_gallery_repository.dart';
import '../logic/photo_gallery_cubit.dart';
import 'global_camera_visibility_controller.dart';

class GlobalCameraOverlay extends StatelessWidget {
  const GlobalCameraOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoGalleryCubit(
        photoGalleryRepository: getIt<PhotoGalleryRepository>(),
      ),
      child: Stack(
        children: [
          child,
          ValueListenableBuilder<int>(
            valueListenable: GlobalCameraVisibilityController.hiddenRequests,
            builder: (context, hiddenRequests, _) {
              if (hiddenRequests > 0) {
                return const SizedBox.shrink();
              }

              return const _GlobalCameraButton();
            },
          ),
        ],
      ),
    );
  }
}

class _GlobalCameraButton extends StatelessWidget {
  const _GlobalCameraButton();

  @override
  Widget build(BuildContext context) {
    final bottomOffset =
        MediaQuery.paddingOf(context).bottom + kBottomNavigationBarHeight + 24;

    return Positioned(
      right: 16,
      bottom: bottomOffset,
      child: FloatingActionButton(
        heroTag: 'global_camera_button',
        onPressed: () => _takePhoto(context),
        child: const Icon(Icons.photo_camera_outlined),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    final translations = AppLocalizations.of(context);
    final saved = await context.read<PhotoGalleryCubit>().takePhoto();

    if (!saved) {
      return;
    }

    final scaffoldContext = appNavigatorKey.currentContext ?? context;

    if (!scaffoldContext.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      scaffoldContext,
    ).showSnackBar(SnackBar(content: Text(translations.photoSaved)));
  }
}
