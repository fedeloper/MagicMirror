import 'dart:io';
import 'package:flutter/services.dart';
import 'package:magic_mirror/magicmirror/cropper.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/books_db_provider.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer' as developer;
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
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;

import 'checkPhoto.dart';

class MagicMirror2Widget extends StatefulWidget {
  @override
  _MagicMirror2Widget createState() => _MagicMirror2Widget();
}
final scaffoldKey = GlobalKey<ScaffoldState>();

class _MagicMirror2Widget extends State<MagicMirror2Widget> {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  Map<String, List<String>> emotion_corrispondece =
  {"Angry": ["The Man Who Knew Too Much"],
    "Disgust": ["Dr. Nikola’s Experiment"],
    "Fear": ["Has a Frog a Soul"],
    "Happy": ["Christmas Carol Collection 2009"],
    "Sad": ["Ghost Stories of an Antiquary"],
    "Surprise": ["The Secret Agent, by Joseph Conrad"],
    "Neutral": [
      "A Personal Anthology of Shakespeare, compiled by Martin Clifton"
    ]};
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  String _url;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      print(cameras);
      // setState(() {});
      controller = CameraController(cameras[1], ResolutionPreset.medium);
      controller.initialize().then((value) => {
        setState(() {
          _isInited = true;
        })
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.network(
                '',
              ).image,
            ),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: Color(0x52EEEEEE),
                ),
                child: MadoWidget(),
              ),
              Divider(),
              Expanded(
                child: Container(
                    width: double.infinity,
                    child: _isInited
                        ? ClipRect(
                      child: Container(
                        child: Transform.scale(
                          scale: controller.value.aspectRatio / MediaQuery.of(context).size.aspectRatio,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: CameraPreview(controller),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container()
                ),
              ),
              Container(
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: _url != null
                          ? Image.file(
                        File(_url),
                        height: 120,
                        width: 120,
                      )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Divider(),
              FloatingActionButton(
                child: Icon(Icons.camera),
                onPressed: () async {


                  final path = join(
                      (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

                  await controller.takePicture(path);

                  // Provo a modificare qui la foto
                  var newpath = await crop(path);
                  //

                  //var book = await getBook(path);
                  //developer.log(book.toString());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(imagePath: newpath),
                    ),
                  );

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> crop(path) async {

    final newpath = join(
        (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

    //final inputImage = Image.file(File(path));
    //File f = new File(path);

    //InputImageData i = new InputImageData(size: size, imageRotation: imageRotation, inputImageFormat: inputImageFormat, planeData: planeData)
    //var fimg =  FileImage(f);
    //var conf = ImageConfiguration();
   // var bts = fimg.createStream(conf).;
    //developer.log("canaglia");

    InputImage inputImage = new InputImage.fromFilePath(path);

    //developer.log("la larghezza è"+inputImage.inputImageData.getMetaData().toString() );
    //bool exist = await f.exists();
    //if (isBusy) return null;

    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    print("bytes:");


    Map<String,int> faceMap = faceDetectorCrop(faces)[0]; //for the moment consider 1 face
    img.Image originalImage = img.decodeImage(File(path).readAsBytesSync());
    img.Image faceCrop = img.copyCrop(img.copyRotate(originalImage, -90), faceMap['x'], faceMap['y'], faceMap['w'], faceMap['h']);
    File(newpath).writeAsBytesSync(img.encodePng(faceCrop));

    return newpath;
  }

  Future classifyImage(path) async {

    final inputImage = InputImage.fromFilePath(path);

    final faces = await faceDetector.processImage(inputImage);

      Map<String,int> faceMap = faceDetectorCrop(faces)[0]; //for the moment consider 1 face
      img.Image originalImage = img.decodeImage(File(path).readAsBytesSync());
      img.Image faceCrop = img.copyCrop(originalImage, faceMap['x'], faceMap['y'], faceMap['w'], faceMap['h']);
      File(path).writeAsBytesSync(img.encodePng(faceCrop));





    await Tflite.loadModel(model: "assets/models/model.tflite",labels: "assets/models/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);


    //final snackBar = SnackBar(content: Text());
    return output[0]["label"].toString();
    //ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

  }

  Future<Book> getBook(path) async
  {
    var emotion = await classifyImage(path);
    final snackBar = SnackBar(content: Text(emotion.toString()));
    final String id = emotion_corrispondece[emotion][0];

    developer.log(id);
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

    Repository rep = new Repository();

    return await rep.getBook(id);
  }

}


