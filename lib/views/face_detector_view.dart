import 'package:camera/camera.dart';
import 'package:elite_soft/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:elite_soft/models/face_model.dart';

import 'success_screen.dart';
import '../constants/sizes.dart';
import '../constants/string_app_constants.dart';
import 'detector_view.dart';
import 'widgets/face_detector_painter.dart';

class FaceDetectorView extends StatefulWidget {
  FaceDetectorView({required this.listFace});

  final List<FaceModel> listFace;

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.front;
  Color _circleColor = Colors.black26;

  FaceModel? faceModel;
  int indexFace = 0;

  @override
  void initState() {
    super.initState();
    faceModel = widget.listFace[0];
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetectorView(
         title: "",
        circleColor: _circleColor,
        customPaint: _customPaint,
        instructionText: faceModel!.faceAction,
        onImage: _processImage,
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      ),
    );
  }

  void changeFace() {
    if (indexFace < widget.listFace.length - 1) {
      setState(() {
        indexFace += 1;
        faceModel = widget.listFace[indexFace];
      });
    } else {


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),


      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          content: Center(
              child: Text(
                AppConstants.verifiedSuccessfully,
                style: TextStyle(
                  fontSize: Sizes.space14,
                  color: ColorName.secondaryLight,
                ),
              )),
          backgroundColor: ColorName.successColor6,
        ),
      );

    }
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;

    _isBusy = true;
    try {
      final faces = await _faceDetector.processImage(inputImage);

      if (!mounted) return;

      for (Face face in faces) {
        processLiveness(face);
      }

      if (mounted) {
        setState(() {
          _customPaint = faces.isNotEmpty
              ? CustomPaint(painter: FaceDetectorPainter(faces, inputImage.metadata!.size, inputImage.metadata!.rotation, _cameraLensDirection))
              : null;
        });
      }
    } catch (e) {
      print("Error processing image: $e");
    } finally {
      _isBusy = false;
    }
  }

  void processLiveness(Face face) {
    final double? rotX = face.headEulerAngleX;
    final double? rotY = face.headEulerAngleY;
    final double? rotZ = face.headEulerAngleZ;

    final FaceLandmark? earL = face.landmarks[FaceLandmarkType.leftEar];
    final FaceLandmark? earR = face.landmarks[FaceLandmarkType.rightEar];
    final FaceLandmark? mouthL = face.landmarks[FaceLandmarkType.leftMouth];
    final FaceLandmark? mouthR = face.landmarks[FaceLandmarkType.rightMouth];
    final FaceLandmark? eyeL = face.landmarks[FaceLandmarkType.leftEye];
    final FaceLandmark? eyeR = face.landmarks[FaceLandmarkType.rightEye];

    if (earL != null && earR != null && mouthL != null && mouthR != null && eyeL != null && eyeR != null) {
      bool isActionMatched = false;
      switch (faceModel!.faceEnum) {
        case FaceEnum.turnLeft:
          if (rotY! > 30) isActionMatched = true;
          break;
        case FaceEnum.turnRight:
          if (rotY! < -30) isActionMatched = true;
          break;
        case FaceEnum.blink:
          final double? leftEyeOpenProb = face.leftEyeOpenProbability;
          final double? rightEyeOpenProb = face.rightEyeOpenProbability;
          if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
            if (leftEyeOpenProb < 0.2 && rightEyeOpenProb < 0.2) isActionMatched = true;
          }
          break;
        case FaceEnum.smile:
          final double? smileProb = face.smilingProbability;
          if (smileProb! >= 0.9) isActionMatched = true;
          break;
        default:
          break;
      }

      if (isActionMatched && mounted) {
        setState(() {
          _circleColor = ColorName.successColor6;
        });
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _circleColor = ColorName.brandPrimary;
            });
            changeFace();
          }
        });
      }
    } else {
      print("No human detected");
    }
  }
}
