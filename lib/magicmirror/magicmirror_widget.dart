import 'dart:io';
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
class MagicmirrorWidget extends StatefulWidget {
  @override
  _MagicmirrorWidget createState() => _MagicmirrorWidget();
}
final scaffoldKey = GlobalKey<ScaffoldState>();
class _MagicmirrorWidget extends State<MagicmirrorWidget> {
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  String _url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      print(cameras);
      // setState(() {});
      controller = CameraController(cameras[0], ResolutionPreset.medium);
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
                        ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    )
                        : Container()
                  ),
                ),
                Container(
                  height: 152,
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
                    await controller.takePicture().then((res) => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => TellingthestoryWidget(path),
                    ),
                    )
                    });
                  },
                ),

              ],
            ),
          ),
        ),
      );


  }
}