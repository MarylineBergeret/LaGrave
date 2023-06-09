import 'package:flutter/material.dart';
import 'package:la_grave_1/plan_with_webcams.dart';

class WebcamMap extends StatelessWidget {
  const WebcamMap({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    /// Initialisation de certains paramètres : image; dimensions, propriété titre zoom
    /// L'image est une ressource (images)
    final IFWPlanWithWebcamsParameters params = IFWPlanWithWebcamsParameters()
      ..image.type = "A"
      ..image.assetName = "images/plan_piste_s69.jpg"
      ..parameters.imageHeight = 869.0
      ..parameters.imageWidth = 1615.0
      ..parameters.zoomTitleProperty = "Nom";

    /// Initialisation manuelle d'une liste des webcams
    final List<dynamic> webcams = [
      {
        "Nom": "Le Maroly - 1750m",
        "Plan_XY": [309, 292],
        "Url": "https://www.skaping.com/le-grand-bornand/terresrouges"
      },
      {
        "Nom": "Village - 1000m",
        "Plan_XY": [1491, 586],
        "Url": "https://www.skaping.com/le-grand-bornand/village"
      },
      {
        "Nom": "La Taverne - 1550m",
        "Plan_XY": [1149, 448],
        "Url": "https://www.skaping.com/le-grand-bornand/taverne"
      },
      {
        "Nom": "Lormay - 1200m",
        "Plan_XY": [1530, 568],
        "Url": "https://www.skaping.com/le-grand-bornand/auberge-nordique"
      },
      {
        "Nom": "Chinaillon - 1300m",
        "Plan_XY": [713, 818],
        "Url": "https://www.skaping.com/le-grand-bornand/chinaillon"
      },
      {
        "Nom": "Mont Lachat - 2100m",
        "Plan_XY": [827, 150],
        "Url": "https://www.skaping.com/le-grand-bornand/mont-lachat"
      },
      {
        "Nom": "Snowpark du Maroly - 1650m",
        "Plan_XY": [279, 379],
        "Url": "https://app.webcam-hd.com/grand-bornand/maroly"
      },
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(title),
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Center(

                /// Utilisation du widget
                child: IFWPlanWithWebcams(
              webcams: webcams,
              params: params,
            ))));
  }
}
