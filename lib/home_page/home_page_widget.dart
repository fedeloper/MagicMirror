import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import 'dart:developer' as developer;
import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror_widget.dart';
import '../magicmirror/magicmirror2_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class placeHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Page under construction!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.construction,
            ),
          ),
        ]),
      ),
    );
  }
}

class ImageTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider image;
  final double imageHeight;
  final double radius;
  final Widget text;

  ImageTextButton({
    @required this.onPressed,
    @required this.image,
    this.imageHeight = 120,
    this.radius = 150,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2),
            Ink.image(
              image: image,
              height: imageHeight,
              width: 130,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Book> books = [];

  void tt() async {
    Repository rep = new Repository();

    //this.books= ;
    List<Book> bs = await rep.topBooks(3);

    addItemToList(bs);
    // list.forEach((Book b) {  addItemToList(b);});
  }

  void addItemToList(List<Book> list) {
    setState(() {
      this.books = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    tt();
    return Scaffold(
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
              child: Container(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: MediaQuery.of(context).size.height - 50,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Color(0x52EEEEEE),
                            ),
                            child: MadoWidget(),
                          ),
                          Container(
                            child: Text(
                              "Suggested Stories",
                              style: GoogleFonts.cutiveMono(fontSize: 25, fontWeight: FontWeight.bold),
                            ) ,
                          ),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                books.isEmpty
                                    ? Center(
                                        child: SpinKitFoldingCube(
                                            color: Colors.blue, size: 50.0))
                                    : PageView.builder(
                                        controller: pageViewController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: books.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            child: Container(
                                              height: 500,
                                              child: Card(
                                                margin: EdgeInsets.all(4.0),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color: Color(0xFFF5F5F5),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Image.network(
                                                      "https://archive.org/download/" +
                                                          books[index].id +
                                                          '/__ia_thumb.jpg',
                                                      width: double.infinity,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 15, 15, 25),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 10, 0, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (() {
                                                                    if (books[index]
                                                                            .title
                                                                            .length >
                                                                        30) {
                                                                      return books[index]
                                                                              .title
                                                                              .substring(0,
                                                                                  30) +
                                                                          "...";
                                                                    }
                                                                    return books[
                                                                            index]
                                                                        .title;
                                                                  }()),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  books[index]
                                                                      .author,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme
                                                                        .secondaryColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 8, 0, 0),
                                                            child: Text(
                                                              books[index]
                                                                  .description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 4,
                                                              style:
                                                                  FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TellingV2(
                                                          book: books[index]),
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                Align(
                                  alignment: Alignment(0, 0.95),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: SmoothPageIndicator(
                                      controller: pageViewController,
                                      count: 3,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) {
                                        pageViewController.animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      effect: ExpandingDotsEffect(
                                        expansionFactor: 2,
                                        spacing: 8,
                                        radius: 16,
                                        dotWidth: 16,
                                        dotHeight: 16,
                                        dotColor: Color(0xFF9E9E9E),
                                        activeDotColor: Color(0xFF3F51B5),
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        //Divider(),
                          ImageTextButton(
                            imageHeight: 170,
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MagicMirror2Widget(),
                                  ),
                                );
                              },
                              image: Image.network(
                                  'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.2,
                              ).image,
                              text: Text("")
                          ),
                    /*
                    Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFF5F5F5),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(0, 0),
                                child: Image.network(
                                  'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    placeHolder(),
    Home(),
    placeHolder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /*
  final pageViewController = PageController();

  List<Book> books = [];

  void tt() async {
    Repository rep = new Repository();

    //this.books= ;
    List<Book> bs = await rep.topBooks(3);

    addItemToList(bs);
    // list.forEach((Book b) {  addItemToList(b);});
  }

  void addItemToList(List<Book> list) {
    setState(() {
      this.books = list;
    });
  }

   */

  @override
  Widget build(BuildContext context) {
    //tt();
    return Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.construction), label: "?"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[700],
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        )
        /*
        SafeArea(
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
                child: Container(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: MediaQuery.of(context).size.height - 50,
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
                              child: Stack(
                                children: [
                                  books.isEmpty
                                      ? Center(
                                          child: SpinKitFoldingCube(
                                              color: Colors.blue, size: 50.0))
                                      : PageView.builder(
                                          controller: pageViewController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: books.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color: Color(0xFFF5F5F5),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.network(
                                                      "https://archive.org/download/" +
                                                          books[index].id +
                                                          '/__ia_thumb.jpg',
                                                      width: double.infinity,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 15, 15, 25),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (() {
                                                                    if (books[index]
                                                                            .title
                                                                            .length >
                                                                        30) {
                                                                      return books[index].title.substring(
                                                                              0,
                                                                              30) +
                                                                          "...";
                                                                    }
                                                                    return books[
                                                                            index]
                                                                        .title;
                                                                  }()),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  books[index]
                                                                      .author,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme
                                                                        .secondaryColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 8, 0, 0),
                                                            child: Text(
                                                              books[index]
                                                                  .description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 4,
                                                              style:
                                                                  FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TellingV2(
                                                            book: books[index]),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                  Align(
                                    alignment: Alignment(0, 0.95),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: SmoothPageIndicator(
                                        controller: pageViewController,
                                        count: 3,
                                        axisDirection: Axis.horizontal,
                                        onDotClicked: (i) {
                                          pageViewController.animateToPage(
                                            i,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease,
                                          );
                                        },
                                        effect: ExpandingDotsEffect(
                                          expansionFactor: 2,
                                          spacing: 8,
                                          radius: 16,
                                          dotWidth: 16,
                                          dotHeight: 16,
                                          dotColor: Color(0xFF9E9E9E),
                                          activeDotColor: Color(0xFF3F51B5),
                                          paintStyle: PaintingStyle.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xFFF5F5F5),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment(0, 0),
                                  child: Image.network(
                                    'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              ],
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MagicMirror2Widget(),
                                ),
                              );
                            },
                            text: 'Try the MagicMirror',
                            options: FFButtonOptions(
                              width: 180,
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
                          )
                        ],
                      ),
                    ),
                  ),
                ))) */
        );
  }
}
