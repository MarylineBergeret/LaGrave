import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ifw_webview.dart';
import 'webcam_service.dart';
import 'webmap_active.dart';
import 'webmap_no_active.dart';

//*************PAGE WEBCAM*************

class WebcamList extends StatefulWidget {
  final List<Webcam> webcams;

  const WebcamList({Key? key, required this.webcams}) : super(key: key);

  @override
  State<WebcamList> createState() => _WebcamListState();
}

class _WebcamListState extends State<WebcamList> {
  onZoom(url) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => IFWFullScreenWebView(
              url: url,
              endRouting: (context) => {Navigator.pop(context)},
              beginOrientations: const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight
              ],
              endOrientations: const [DeviceOrientation.portraitUp],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 onglets
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
            child: Text(
              'Webcams'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(240, 121, 36, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'CARTE'),
              Tab(text: 'LISTE'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const WebcamMapNoActive(
              title: 'title',
            ),
            ListView.builder(
              itemCount: widget.webcams.length,
              itemBuilder: (context, index) {
                final Webcam webcam = widget.webcams[index];
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 2,
                            width: 50,
                            color: const Color.fromRGBO(240, 121, 36, 1),
                          ),
                          const SizedBox(
                              width: 5), // Ajouter un espace entre les traits et les icônes
                          Container(
                            height: 30,
                            width: 35,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 121, 36, 1),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: IconButton(
                                padding: const EdgeInsets.only(bottom: 2.5),
                                // alignment: Alignment.center,
                                icon: const Icon(Icons.fullscreen,
                                    size: 22, color: Colors.white),
                                onPressed: () {
                                  onZoom(webcam.url);
                                }),
                          ),
                          const SizedBox(
                              width: 10), // Réduire l'espace entre les icônes
                          Expanded(
                            child: Text(
                              webcam.nom,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(240, 121, 36, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Réduire l'espace entre les icônes
                          Container(
                            width: 35,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 121, 36, 1),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              icon: const Icon(Icons.location_on,
                                  size: 20, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const WebcamMap(
                                      title: '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                              width:
                                  5), // Ajouter un espace entre les icônes et les traits
                          Container(
                            height: 2,
                            width: 50,
                            color: const Color.fromRGBO(240, 121, 36, 1),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 20), // Réduire l'espace entre les icônes

                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IFWFullScreenWebView(
                                    url: webcam.url,
                                    endRouting: (context) =>
                                        {Navigator.pop(context)},
                                    beginOrientations: const [
                                      DeviceOrientation.landscapeLeft,
                                      DeviceOrientation.landscapeRight
                                    ],
                                    // icon: Icons.arrow_circle_down_outlined,
                                    // iconPanelColor: Colors.lightBlue,
                                    // iconColor: Colors.lightBlue,
                                    endOrientations: const [
                                      DeviceOrientation.portraitUp
                                    ],
                                  )));
                        },
                        child: SizedBox(
                          width: 400,
                          height: 180,
                          child: IFWWebView(
                            url: webcam.url,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6.0),
                      Column(
                        children: [
                          Container(
                            height: 30,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(240, 121, 36, 1),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              icon: const Icon(
                                Icons.share_outlined,
                                size: 23,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Add share functionality here
                              },
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          const Text(
                            'Partager',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8.0),
                    ],
                  ),
                );
              },
            ),
          ], // children
        ),
      ),
    );
  }
}
