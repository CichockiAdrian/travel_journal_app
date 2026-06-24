import 'dart:io';

import 'package:flutter/material.dart';

class TripDiaryPhotoCarouselPage extends StatefulWidget {
  final List<String> photoPaths;
  final int initialIndex;

  const TripDiaryPhotoCarouselPage({
    super.key,
    required this.photoPaths,
    required this.initialIndex,
  });

  @override
  State<TripDiaryPhotoCarouselPage> createState() =>
      _TripDiaryPhotoCarouselPageState();
}

class _TripDiaryPhotoCarouselPageState
    extends State<TripDiaryPhotoCarouselPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photosCount = widget.photoPaths.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / $photosCount'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: photosCount,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final photoPath = widget.photoPaths[index];

          return Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.file(
                File(photoPath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 64,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
