import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' as Math;

import '/utils/abort-signal/_index.dart';
import '/render-objects/render-box/box/style.dart';
import '/render-objects/render-box/box/box_model.dart';
import '/render-objects/render-box/box/_index.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // () async {
    //   final jsonText = await rootBundle.loadString('test.json');

    //   final data = jsonDecode(jsonText);

    //   print(data);
    // }();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: Colors.transparent,
      builder: (context, child) {
        return DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
          ),
          child: Box(
            style: Style(
              width: 1.pr,
              height: 1.pr,
              backgroundColor: Color.fromRGBO(50, 50, 50, 1),
              padding: EdgeInsetsUnit.only(
                top: 10.px,
                left: 10.px,
                right: 10.px,
                bottom: 10.px,
              ),
              expandChildHorizontal: true,
              expandChildVertical: true,
            ),
            children: [
              SingleChildScrollView(
                child: Box(
                  style: Style(
                    width: 1.pr,
                    // height: 1.pr,
                    // padding: EdgeInsetsUnit.all(10.px),
                    backgroundColor: Colors.green,
                    gap: $box.utils.gap(vertical: 10.px),
                  ),
                  children: [
                    Box(
                      style: Style(
                        width: 200.px,
                        // width: 0.9.cq,
                        height: 80.px,
                        backgroundColor: Colors.purple,
                        margin: EdgeInsetsUnit.only(
                          top: (0).px,
                          left: (50).px,
                        ),
                        padding: EdgeInsetsUnit.only(
                          top: 5.px,
                          left: 5.px,
                          right: 5.px,
                          bottom: 5.px,
                        ),
                        flexDirection: FlexDirection.HORIZONTAL,
                        alignItems: ItemAlignment.STRETCH,
                        justifyContent: ContentAlignment.SPACE_EVENLY,
                        gap: $box.utils.gap(horizontal: 10.px),
                      ),
                      children: [
                        Box(
                          style: Style(
                            width: 20.px,
                            // height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            width: 20.px,
                            // height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            width: 20.px,
                            // height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            width: 20.px,
                            // height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        width: 80.px,
                        height: 200.px,
                        backgroundColor: Colors.purple,
                        margin: EdgeInsetsUnit.only(
                          top: (0).px,
                          left: (50).px,
                        ),
                        padding: EdgeInsetsUnit.only(
                          top: 5.px,
                          left: 5.px,
                          right: 5.px,
                          bottom: 5.px,
                        ),
                        flexDirection: FlexDirection.VERTICAL,
                        alignItems: ItemAlignment.STRETCH,
                        justifyContent: ContentAlignment.SPACE_AROUND,
                        // gap: $box.utils.gap(horizontal: 10.px),
                      ),
                      children: [
                        Box(
                          style: Style(
                            height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        Box(
                          style: Style(
                            height: 20.px,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        // width: 100.px,
                        // height: 80.px,
                        alignSelf: ItemAlignment.CENTER,
                      ),
                      children: [
                        ElevatedButton(onPressed: () {}, child: Text('SES')),
                      ],
                    ),
                    Box(
                      style: Style(
                        boxSizing: BoxSizing.CONTENT_BOX,
                        alignSelf: ItemAlignment.CENTER,
                        width: 100.px,
                        height: 100.px,
                        backgroundColor: Colors.blue,
                        // backgroundColor: Colors.blue.withAlpha(0),
                        borderRadius: BorderRadiusUnit(
                          topLeft: 30.px,
                          topRight: 50.px,
                          // bottomRight: 50.px,
                          // bottomLeft: 50.px,
                        ),
                        border: BorderEdgeInsetsUnit.only(
                          topSide: BorderSideUnit(
                            width: 30.px,
                            color: Colors.red,
                          ),
                          // leftSide: BorderSideUnit(
                          //   width: 5.px,
                          //   color: Colors.black,
                          // ),
                          // bottomSide: BorderSideUnit(
                          //   width: 5.px,
                          //   color: Colors.white,
                          // ),
                          // rightSide: BorderSideUnit(
                          //   width: 30.px,
                          //   color: Colors.yellow,
                          // ),
                        ),
                      ),
                    ),
                    Box(
                      style: Style(
                        alignSelf: ItemAlignment.STRETCH,
                        // width: 1.pr,
                        flexDirection: FlexDirection.HORIZONTAL,
                        alignItems: ItemAlignment.CENTER,
                        backgroundColor: Colors.orange,
                        gap: $box.utils.gap(horizontal: 10.px),
                        padding: EdgeInsetsUnit.all(10.px),
                        margin: EdgeInsetsUnit.symmetric(horizontal: 10.px),
                      ),
                      children: [
                        Box(
                          style: Style(
                            boxSizing: BoxSizing.CONTENT_BOX,
                            width: 80.px,
                            height: 200.px,
                            backgroundColor: Colors.purple,
                            margin: EdgeInsetsUnit.only(
                              top: (0).px,
                              // left: (50).px,
                            ),
                            padding: EdgeInsetsUnit.only(
                              top: 5.px,
                              left: 5.px,
                              right: 5.px,
                              bottom: 5.px,
                            ),
                            gap: $box.utils.gap(vertical: 5.px),
                            flexDirection: FlexDirection.VERTICAL,
                            alignItems: ItemAlignment.STRETCH,
                            justifyContent: ContentAlignment.SPACE_EVENLY,

                            borderRadius: BorderRadiusUnit.all(10.px),
                            border: BorderEdgeInsetsUnit.only(
                              // leftSide: BorderSideUnit(
                              //   style: BorderUnitStyle.SOLID,
                              //   width: 30.px,
                              //   color: Colors.white,
                              // ),
                              topSide: BorderSideUnit(
                                style: BorderUnitStyle.SOLID,
                                width: 30.px,
                                color: Colors.teal,
                              ),
                              // rightSide: BorderSideUnit(
                              //   style: BorderUnitStyle.SOLID,
                              //   width: 20.px,
                              //   color: Colors.yellow,
                              // ),
                              // bottomSide: BorderSideUnit(
                              //   style: BorderUnitStyle.SOLID,
                              //   width: 10.px,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                            ),
                            // gap: $box.utils.gap(horizontal: 10.px),
                          ),
                          children: [
                            Box(
                              style: Style(
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                flexGrow: 1,
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Box(
                          style: Style(
                            flexGrow: 1,
                            // boxSizing: BoxSizing.CONTENT_BOX,
                            // width: 160.px,
                            height: 200.px,
                            backgroundColor: Colors.purple,
                            margin: EdgeInsetsUnit.only(
                              top: (0).px,
                              // left: (50).px,
                            ),
                            padding: EdgeInsetsUnit.only(
                              top: 5.px,
                              left: 5.px,
                              right: 5.px,
                              bottom: 5.px,
                            ),
                            gap: $box.utils.gap(vertical: 5.px),
                            flexDirection: FlexDirection.VERTICAL,
                            alignItems: ItemAlignment.STRETCH,
                            justifyContent: ContentAlignment.SPACE_EVENLY,

                            // borderRadius: BorderRadiusUnit.all(10.px),
                            // overflow: Overflow.HIDDEN,

                            border: BorderEdgeInsetsUnit.only(
                              leftSide: BorderSideUnit(
                                style: BorderUnitStyle.DASHED,
                                width: 10.px,
                                color: Colors.white,
                              ),
                              topSide: BorderSideUnit(
                                style: BorderUnitStyle.DASHED,
                                width: 10.px,
                                color: Colors.teal,
                              ),
                              rightSide: BorderSideUnit(
                                style: BorderUnitStyle.DASHED,
                                width: 10.px,
                                color: Colors.yellow,
                              ),
                              bottomSide: BorderSideUnit(
                                style: BorderUnitStyle.DASHED,
                                width: 10.px,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),

                            // gap: $box.utils.gap(horizontal: 10.px),
                          ),
                          children: [
                            Box(
                              style: Style(
                                width: 1.pr,
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                flexGrow: 1,
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            Box(
                              style: Style(
                                height: 20.px,
                                backgroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        alignSelf: ItemAlignment.STRETCH,
                        // width: 20.px,
                        height: 20.px,
                        padding: EdgeInsetsUnit.only(
                          top: 20.px,
                          left: 20.px,
                          right: 20.px,
                          bottom: 20.px,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    ),
                    Box(
                      style: Style(
                        width: 100.px,
                        height: 80.px,
                        // padding: EdgeInsetsUnit.only(
                        //   top: 20.px,
                        //   left: 20.px,
                        //   right: 20.px,
                        //   bottom: 20.px,
                        // ),
                        backgroundColor: Colors.black,
                        justifyContent: ContentAlignment.CENTER,
                      ),
                      children: [
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.CENTER,
                            width: 50.px,
                            height: 130.px,
                            backgroundColor: const Color.fromARGB(255, 37, 100, 150),
                          ),
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        alignSelf: ItemAlignment.CENTER,
                        width: 220.px,
                        height: 300.px,
                        backgroundColor: Colors.blue,
                        margin: EdgeInsetsUnit.only(
                          // top: 30.px,
                          // left: 20.px,
                          // right: (40).px,
                        ),
                        padding: EdgeInsetsUnit.only(
                          top: 20.px,
                          left: 20.px,
                          right: 20.px,
                          bottom: 20.px,
                        ),
                        // border: BorderEdgeInsetsUnit.all(
                        //   BorderSideUnit(
                        //     style: BorderUnitStyle.SOLID,
                        //     width: 2.px,
                        //     color: Colors.white,
                        //   )
                        // ),
                        flexDirection: FlexDirection.VERTICAL,
                        // flexDirection: FlexDirection.VERTICAL_REVERSE,
                        justifyContent: ContentAlignment.SPACE_AROUND,
                        gap: $box.utils.gap(
                          horizontal: 10.px,
                          // vertical: 10.px,
                        ),
                        overflow: Overflow.VISIBLE,
                      ),
                      children: [
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.FLEX_END,
                            width: Unit.auto,
                            height: Unit.auto,
                            backgroundColor: Colors.orange,
                          ),
                          children: [
                            ElevatedButton(onPressed: () {}, child: Text('SES')),
                          ],
                        ),
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.STRETCH,
                            // width: 50.px,
                            height: 50.px,
                            backgroundColor: Colors.red,
                            margin: EdgeInsetsUnit.only(
                              // top: 30.px,
                              // left: 20.px,
                              // right: 40.px,
                            ),
                            padding: EdgeInsetsUnit.only(
                              top: 5.px,
                              left: 5.px,
                              right: 5.px,
                              bottom: 5.px,
                            ),
                          ),
                          children: [
                            Box(
                              style: Style(
                                alignSelf: ItemAlignment.CENTER,
                                width: 30.px,
                                height: 30.px,
                                backgroundColor: Colors.white,
                                justifyContent: ContentAlignment.CENTER,
                              ),
                              children: [
                                Box(
                                  style: Style(
                                    alignSelf: ItemAlignment.CENTER,
                                    width: 10.px,
                                    height: 10.px,
                                    backgroundColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.CENTER,
                            width: 70.px,
                            height: 70.px,
                            backgroundColor: Colors.white,
                            flexDirection: FlexDirection.HORIZONTAL,
                            justifyContent: ContentAlignment.CENTER,
                            alignItems: ItemAlignment.CENTER,
                          ),
                          children: [
                            Box(
                              style: Style(
                                width: 90.px,
                                height: 40.px,
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        alignSelf: ItemAlignment.CENTER,
                        width: 300.px,
                        height: 250.px,
                        backgroundColor: Colors.blue,
                        margin: EdgeInsetsUnit.only(
                          // top: 30.px,
                          // left: 20.px,
                          // right: (40).px,
                        ),
                        padding: EdgeInsetsUnit.only(
                          top: 20.px,
                          left: 20.px,
                          right: 20.px,
                          bottom: 20.px,
                        ),
                        // border: BorderEdgeInsetsUnit.all(
                        //   BorderSideUnit(
                        //     style: BorderUnitStyle.SOLID,
                        //     width: 2.px,
                        //     color: Colors.white,
                        //   )
                        // ),
                        flexDirection: FlexDirection.HORIZONTAL,
                        // flexDirection: FlexDirection.HORIZONTAL_REVERSE,
                        justifyContent: ContentAlignment.FLEX_END,
                        gap: $box.utils.gap(
                          horizontal: 20.px,
                          vertical: 10.px,
                        ),
                        overflow: Overflow.VISIBLE,
                      ),
                      children: [
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.FLEX_END,
                            flexGrow: 1,
                            width: Unit.auto,
                            height: Unit.auto,
                            backgroundColor: Colors.orange,
                          ),
                          children: [
                            Text('Text', style: TextStyle(fontSize: 16),),
                          ],
                        ),
                        Box(
                          style: Style(
                            flexGrow: 1,
                            alignSelf: ItemAlignment.STRETCH,
                            // width: 50.px,
                            // height: 50.px,
                            backgroundColor: Colors.red,
                            margin: EdgeInsetsUnit.only(
                              // top: 30.px,
                              // left: 20.px,
                              // right: 40.px,
                            ),
                            padding: EdgeInsetsUnit.only(
                              top: 5.px,
                              left: 5.px,
                              right: 5.px,
                              bottom: 5.px,
                            ),
                            justifyContent: ContentAlignment.CENTER,
                          ),
                          children: [
                            Box(
                              style: Style(
                                width: 30.px,
                                height: 30.px,
                                backgroundColor: Colors.white,
                                justifyContent: ContentAlignment.CENTER,
                              ),
                              children: [
                                Box(
                                  style: Style(
                                    alignSelf: ItemAlignment.CENTER,
                                    width: 10.px,
                                    height: 10.px,
                                    backgroundColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Box(
                          style: Style(
                            alignSelf: ItemAlignment.CENTER,
                            width: 70.px,
                            height: 70.px,
                            backgroundColor: Colors.white,
                            flexDirection: FlexDirection.HORIZONTAL,
                            justifyContent: ContentAlignment.CENTER,
                            alignItems: ItemAlignment.CENTER,
                          ),
                          children: [
                            Box(
                              style: Style(
                                width: 90.px,
                                height: 40.px,
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        alignSelf: ItemAlignment.CENTER,
                        boxSizing: BoxSizing.CONTENT_BOX,
                        width: 300.px,
                        height: 400.px,
                        backgroundColor: Colors.black,
                        padding: EdgeInsetsUnit.only(
                          top: 20.px,
                          left: 20.px,
                          right: 20.px,
                          bottom: 20.px,
                        ),
                        // gap: $box.utils.gap(vertical: 10.px),
                      ),
                      children: [
                        Box(
                          style: Style(
                            width: 1.pr,
                            // height: 100.px,
                            flexGrow: 1,
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                        ),
                        Box(
                          style: Style(
                            width: 1.pr,
                            // height: 200.px,
                            flexGrow: 2,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ),
                        Box(
                          style: Style(
                            width: 1.pr,
                            // height: 100.px,
                            flexGrow: 1,
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                        ),
                      ],
                    ),
                    Box(
                      style: Style(
                        boxSizing: BoxSizing.CONTENT_BOX,
                        alignSelf: ItemAlignment.CENTER,
                        width: 400.px,
                        height: 300.px,
                        backgroundColor: Colors.black,
                        padding: EdgeInsetsUnit.only(
                          top: 20.px,
                          left: 20.px,
                          right: 20.px,
                          bottom: 20.px,
                        ),
                        flexDirection: FlexDirection.HORIZONTAL,
                        // gap: $box.utils.gap(horizontal: 10.px),
                      ),
                      children: [
                        Box(
                          style: Style(
                            height: 1.pr,
                            flexGrow: 1,
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                        ),
                        Box(
                          style: Style(
                            height: 1.pr,
                            flexGrow: 2,
                            backgroundColor: Colors.purpleAccent,
                          ),
                        ),
                        Box(
                          style: Style(
                            height: 1.pr,
                            flexGrow: 1,
                            backgroundColor: Colors.lightGreenAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
