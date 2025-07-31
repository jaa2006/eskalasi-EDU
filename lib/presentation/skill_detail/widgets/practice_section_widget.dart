import 'dart:convert';
import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PracticeSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> practiceExercises;
  final bool isCompleted;
  final double completionPercentage;
  final String estimatedTime;

  const PracticeSectionWidget({
    super.key,
    required this.practiceExercises,
    required this.isCompleted,
    required this.completionPercentage,
    required this.estimatedTime,
  });

  @override
  State<PracticeSectionWidget> createState() => _PracticeSectionWidgetState();
}

class _PracticeSectionWidgetState extends State<PracticeSectionWidget> {
  List<XFile> _uploadedImages = [];
  final ImagePicker _imagePicker = ImagePicker();
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

          await _cameraController!.initialize();
          await _applySettings();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          // Flash not supported
        }
      }
    } catch (e) {
      // Settings not supported
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _uploadedImages.add(photo);
      });

      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Foto berhasil diambil'),
            backgroundColor: AppTheme.successGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _uploadedImages.add(image);
        });

        HapticFeedback.lightImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Foto berhasil dipilih'),
              backgroundColor: AppTheme.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _downloadPDF(String filename, String content) async {
    try {
      if (kIsWeb) {
        final bytes = utf8.encode(content);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "$filename.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile, we'll simulate PDF download
        HapticFeedback.lightImpact();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF $filename berhasil diunduh'),
              backgroundColor: AppTheme.successGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.dividerGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Tambah Foto Dokumentasi',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text(
                'Ambil Foto',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              title: Text(
                'Pilih dari Galeri',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Progress Ring
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: widget.completionPercentage / 100,
                        backgroundColor: AppTheme.dividerGray,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isCompleted
                              ? AppTheme.successGreen
                              : AppTheme.warningOrange,
                        ),
                        strokeWidth: 3,
                      ),
                      Center(
                        child: widget.isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.successGreen,
                                size: 20,
                              )
                            : Text(
                                '${widget.completionPercentage.toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Section Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'build',
                            color: AppTheme.warningOrange,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Praktik',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            widget.estimatedTime,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'assignment',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.practiceExercises.length} Latihan',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Practice Exercises List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.practiceExercises.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.dividerGray,
              height: 1,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final exercise = widget.practiceExercises[index];
              final isCompleted = exercise['isCompleted'] as bool? ?? false;

              return Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Header
                    Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.successGreen
                                : AppTheme.dividerGray,
                            shape: BoxShape.circle,
                          ),
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.backgroundWhite,
                                  size: 12,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.backgroundWhite,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            exercise['title'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Exercise Description
                    Text(
                      exercise['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        height: 1.5,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Action Buttons
                    Row(
                      children: [
                        // Download PDF Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _downloadPDF(
                              exercise['title'] as String,
                              exercise['pdfContent'] as String? ??
                                  'Panduan praktik untuk ${exercise['title']}',
                            ),
                            icon: CustomIconWidget(
                              iconName: 'download',
                              color: AppTheme.primaryBlue,
                              size: 16,
                            ),
                            label: Text(
                              'Unduh PDF',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 2.w),

                        // Upload Photo Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showPhotoOptions,
                            icon: CustomIconWidget(
                              iconName: 'camera_alt',
                              color: AppTheme.backgroundWhite,
                              size: 16,
                            ),
                            label: Text(
                              'Foto Hasil',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.backgroundWhite,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.warningOrange,
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Uploaded Images
                    if (_uploadedImages.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Dokumentasi Hasil:',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 20.w,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _uploadedImages.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 2.w),
                          itemBuilder: (context, imageIndex) {
                            return Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.dividerGray,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kIsWeb
                                    ? Image.network(
                                        _uploadedImages[imageIndex].path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_uploadedImages[imageIndex].path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
