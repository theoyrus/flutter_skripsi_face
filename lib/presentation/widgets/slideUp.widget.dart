import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'gridView.widget.dart';

class SlideUpWidget extends StatefulWidget {
  final List<Widget> panel;
  final PanelController? panelCtrl;
  final Widget? body;
  final Widget? collapsed;
  final double? minHeight;

  const SlideUpWidget({
    Key? key,
    required this.panel,
    this.panelCtrl,
    this.body,
    this.collapsed,
    this.minHeight,
  }) : super(key: key);

  @override
  _SlideUpWidgetState createState() => _SlideUpWidgetState();
}

class _SlideUpWidgetState extends State<SlideUpWidget> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 150.0;

  @override
  void initState() {
    super.initState();

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SlidingUpPanel(
          controller: widget.panelCtrl,
          maxHeight: _panelHeightOpen,
          minHeight: widget.minHeight ?? _panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          body: _body(),
          collapsed: _collapsed(),
          panelBuilder: (sc) => _panel(sc, null),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          }),
        ),

        // Positioned(
        //     top: 0,
        //     child: ClipRRect(
        //         child: BackdropFilter(
        //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //             child: Container(
        //               width: MediaQuery.of(context).size.width,
        //               height: MediaQuery.of(context).padding.top,
        //               color: Colors.transparent,
        //             )))),

        //the SlidingUpPanel Title
        // Positioned(
        //   top: 52.0,
        //   child: Container(
        //     padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
        //     child: Text(
        //       "SlidingUpPanel Example",
        //       style: TextStyle(fontWeight: FontWeight.w500),
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(24.0),
        //       boxShadow: [
        //         BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _panel(ScrollController sc, PanelController? pc) {
    if (mounted) {
      pc?.open();
    }
    var listViewChildren = (widget.panel.isEmpty)
        ? [
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            const SizedBox(
              height: 18.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Example Slide Up Title",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 36.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonPanel(
                    label: "Popular", icon: Icons.favorite, color: Colors.blue),
                buttonPanel(
                    label: "Food", icon: Icons.restaurant, color: Colors.red),
                buttonPanel(
                    label: "Events", icon: Icons.event, color: Colors.amber),
                buttonPanel(
                    label: "More", icon: Icons.more_horiz, color: Colors.green),
              ],
            ),
            const SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridViewWidget(
                    items: GridViewWidget.sampleItems,
                    // onTap: controller.detailImage,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 0,
                  ),
                  const Text("Images List",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                        height: 120.0,
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        fit: BoxFit.cover,
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                        width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                        height: 120.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("About",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    """ Its about long long text for example only. Its about long long text for example only. Its about long long text for example only. Its about long long text for example only. Its about long long text for example only. 
                    """,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ]
        : widget.panel;

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ListView(
            controller: sc,
            children: listViewChildren,
          ),
        ));
  }

  Widget? _body() {
    return widget.body;
  }

  Widget? _collapsed() {
    if (widget.collapsed != null) {
      return widget.collapsed;
    }
  }
}

Widget buttonPanel(
    {String? label, IconData? icon, Color? color, Function()? onTap}) {
  return Column(
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 8.0,
              )
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(
        height: 12.0,
      ),
      Text(label ?? ''),
    ],
  );
}
