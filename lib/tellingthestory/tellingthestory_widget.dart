import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_video_player.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class TellingthestoryWidget extends StatefulWidget {
  final String path_photo;
  TellingthestoryWidget(String path, {Key key,this.path_photo}) : super(key: key);

  @override
  _TellingthestoryWidgetState createState() => _TellingthestoryWidgetState();
}

class _TellingthestoryWidgetState  extends State<TellingthestoryWidget> {
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: MadoWidget(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.82, 0.86),
                    child: Container(
                        width: 76,
                        child: _isInited
                            ? AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: CameraPreview(controller),
                        )
                            : Container()
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.59, 0.77),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MagicmirrorWidget(),
                          ),
                        );
                      },
                      text: 'Re-Magic',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.primaryColor,
                        textStyle: FlutterFlowTheme.subtitle2.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 12,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.11, -0.19),
                    child: Text(
                      'Story telling',
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.81, -0.94),
                    child: Text(
                      'title',
                      style: FlutterFlowTheme.title1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.72, -0.82),
                    child: Text(
                      'capther',
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );


  }
}