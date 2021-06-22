import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:magic_mirror/tellingthestory/camera_view.dart';
import 'package:magic_mirror/tellingthestory/painters/face_detector_painter.dart';

import '../components/mado_widget.dart';
import '../tellingthestory/tellingthestory_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

class MagicMirrorWidget2 extends StatefulWidget {
  @override
  _MagicMirrorWidget2 createState() => _MagicMirrorWidget2();
}

final scaffoldKey = GlobalKey<ScaffoldState>();

class _MagicMirrorWidget2 extends State<MagicMirrorWidget2> {

  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint customPaint;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    //WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cameras = await availableCameras();
    });


  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: "Face Detector",
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    print('Found ${faces.length} faces');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData.size,
          inputImage.inputImageData.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
