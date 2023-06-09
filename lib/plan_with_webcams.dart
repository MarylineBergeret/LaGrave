import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import "ifw_webview.dart";

/// Paramètres dimensionnels privés widget IFWPlanWithWebcams
class _Parameters {
  /// position x et y exclusion affichage widget
  static const double positionNotDisplay = -9999.0;

  /// paramètre velocity défaut algorithme calcul animation jusqu'à arrêt image
  /// pour ensuite afficher les webcams visibles
  static const double defaultVelocity = 10.0;

  /// paramètre drag défaut algorithme calcul animation jusqu'à arrêt image
  /// pour ensuite afficher les webcams visibles
  static const double defaultDrag = 0.000013;
}

/// Caractéristiques image
class IFImage {
  /// Type image
  /// A : AssetImage => indiquer assetName
  String type = "A";

  /// identifiant image pour type AssetImage : nom de fichier
  String assetName = "";

  @override
  String toString() {
    return '{type : $type, assetName : $assetName }';
  }
}

/// Parametres divers fonctionnement widget IFWPlanWithWebcams
class IFParameters {
  /// hauteur image
  double imageHeight = 0.0;

  /// largeur image
  double imageWidth = 0.0;

  /// Echelle zoom minimum
  double minScale = 0.5;

  /// Echelle zoom maximum
  double maxScale = 3.0;

  /// hauteur zone contenant l'icone représentant la webcam
  double iconHeight = 48.0;

  /// largeur zone contenant l'icone représentant de la webcam
  double iconWidth = 48.0;

  /// Icone représentant l'action d'ouverture de la vignette webcam
  IconData webcamIcon = Icons.video_camera_back_sharp;

  /// hauteur zone contenant l'icone représentant la webcam
  double webcamHeight = 148.0;

  /// largeur zone contenant l'icone représentant de la webcam
  double webcamWidth = 180.0;

  /// Icone représentant la fermeture de la vignette webcam sur le plan
  IconData closeIcon = Icons.close;

  /// Icone représentant l'action du zoom plein écran de la vignette webcam
  IconData zoomIcon = Icons.zoom_out_map;

  /// marge des  zones contenant les webviews avec les bordures
  double marginBorders = 5.0;

  /// couleur lorsque la webcam est sélectionnée
  Color iconColor = Colors.redAccent;

  /// couleur lorsque la webcam est sélectionnée
  Color webcamColor = Colors.transparent;

  /// zoom : propriété liste webcams utilisé pour le titre de la fenêtre
  String zoomTitleProperty = "";

  /// zoom : comportement orientation avant affichage zoom
  List<DeviceOrientation> zoomBeginOrientation = const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ];

  /// zoom : comportement orientation en sortie d'affichage zoom
  List<DeviceOrientation> zoomEndOrientation = const [
    DeviceOrientation.portraitUp
  ];

  @override
  String toString() {
    return """{
      imageHeight : $imageHeight, 
      imageWidth : $imageWidth, 
      iconHeight : $iconHeight, 
      iconWidth : $iconWidth, 
      webcamHeight : $webcamHeight, 
      webcamWidth : $webcamWidth, 
      marginBorders : $marginBorders, 
      webcamColor : $iconColor, 
      webcamColor : $webcamColor,
      zoomTitleProperty : $zoomTitleProperty,
      zoomBeginOrientation : $zoomBeginOrientation,
      zoomEndOrientation : $zoomEndOrientation
    }""";
  }
}

/// Paramètres divers widget IFWPlanWithWebcams
class IFWPlanWithWebcamsParameters {
  /// Caractéristiques de l'image de fond du plan
  IFImage image = IFImage();

  /// Paramètres divers
  IFParameters parameters = IFParameters();
  @override
  String toString() {
    return """{
      image : $image,
      parameters : $parameters
    }""";
  }
}

/// Widget affichage image plan avec représentation webcams rattachées

///  Se présente sous la forme d'un widget à insérer dans une zone
/// type Container.
class IFWPlanWithWebcams extends StatefulWidget {
  /// Paramètres divers (image, dimensions, ...) type [IFWPlanWithWebcamsParameters]
  final IFWPlanWithWebcamsParameters? params;

  /// Structure JSON Intence décrivant la liste des webcams
  final List<dynamic>? webcams;

  const IFWPlanWithWebcams({
    super.key,
    this.webcams,
    this.params,
  });

  @override
  State<IFWPlanWithWebcams> createState() => _PlanWithWebcams();
}

class _PlanWithWebcams extends State<IFWPlanWithWebcams> {
  bool isInteraction = false;
  bool isGesturePan = true;
  bool isInteractionEnd = false;
  bool isInteractionIcon = false;

  late IFWPlanWithWebcamsParameters _settings;
  late Image _image;
  List<dynamic> uiWebcams = [];

  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _settings = widget.params ?? IFWPlanWithWebcamsParameters();
    if (_settings.image.type == "A") {
      _image = Image(image: AssetImage(_settings.image.assetName));
    }
    for (int i = 0; i < widget.webcams!.length; i++) {
      uiWebcams.add({
        "Nom": widget.webcams![i]["Nom"],
        "Plan_XY": widget.webcams![i]["Plan_XY"],
        "Url": widget.webcams![i]["Url"],
        "selected": false,
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onInteractionStart(ScaleStartDetails interaction) {
    setState(() {
      isInteraction = true;
    });
  }

  void _onInteractionEnd(ScaleEndDetails interaction) {
    setState(() {
      isInteraction = false;
      isInteractionEnd = true;
    });
    Timer(
      Duration(
          milliseconds: ((IFWCalculateDurationAnimation.getValue(
                          velocity:
                              interaction.velocity.pixelsPerSecond.distance) *
                      1000.0 +
                  100.0)
              .round())),
      () {
        setState(() {
          isInteractionEnd = false;
        });
      },
    );
  }

  List<Widget> _listWidgets() {
    List<Widget> listWidgets = [
      LayoutId(
          id: "-1",
          child: InteractiveViewer(
              // child: IFWInteractiveViewer(
              minScale: _settings.parameters.minScale,
              maxScale: _settings.parameters.maxScale,
              constrained: false,
              transformationController: _transformationController,
              onInteractionStart: (ScaleStartDetails intercation) {
                _onInteractionStart(intercation);
              },
              onInteractionEnd: (ScaleEndDetails intercation) {
                _onInteractionEnd(intercation);
              },
              child: _image))
    ];
    if ((!isInteraction) && (!isInteractionEnd)) {
      for (int i = 0; i < uiWebcams.length; i++) {
        listWidgets.add(LayoutId(
          id: i.toString(),
          child: webcamScreen(i),
        ));
      }
    }
    return listWidgets;
  }

  Widget webcamScreen(int idx) {
    if ((uiWebcams[idx]["selected"]) && (uiWebcams[idx]["Url"] != "")) {
      return SizedBox(
          height: _settings.parameters.webcamHeight,
          width: _settings.parameters.webcamWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Container(
                color: _settings.parameters.webcamColor,
                // child: Text("webcam $idx"),
                child: IFWWebView(url: uiWebcams[idx]["Url"]),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    iconSize: _settings.parameters.iconHeight,
                    icon: Icon(_settings.parameters.closeIcon,
                        color: _settings.parameters.iconColor),
                    onPressed: () {
                      _onPressedSelection(idx);
                    },
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    iconSize: _settings.parameters.iconHeight,
                    icon: Icon(_settings.parameters.zoomIcon,
                        color: _settings.parameters.iconColor),
                    onPressed: () {
                      _onPressedZoom(idx);
                    },
                  )
                ],
              )
            ],
          ));
    } else {
      return SizedBox(
          height: _settings.parameters.iconHeight,
          width: _settings.parameters.iconHeight,
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            iconSize: _settings.parameters.iconHeight,
            icon: Icon(
              _settings.parameters.webcamIcon,
              color: _settings.parameters.iconColor,
            ),
            onPressed: () {
              _onPressedSelection(idx);
            },
          ));
    }
  }

  void _onPressedSelection(int idx) {
    uiWebcams[idx]["selected"] = !uiWebcams[idx]["selected"];
    setState(() {
      isInteractionIcon = !isInteractionIcon;
    });
  }

  void _onPressedZoom(int idx) {
    if (uiWebcams[idx]["Url"] != "") {
      final String title =
          uiWebcams[idx].containsKey(_settings.parameters.zoomTitleProperty)
              ? uiWebcams[idx][_settings.parameters.zoomTitleProperty]
              : "";

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IFWFullScreenWebView(
                url: uiWebcams[idx]["Url"],
                title: title,
                endRouting: (context) => {Navigator.pop(context)},
                beginOrientations: _settings.parameters.zoomBeginOrientation,
                endOrientations: _settings.parameters.zoomEndOrientation,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
        delegate: _PlanWithWebcamsDelegate(
          webcams: uiWebcams,
          isInteraction: isInteraction,
          isInteractionEnd: isInteractionEnd,
          transformationController: _transformationController,
          parameters: _settings.parameters,
        ),
        children: _listWidgets());
  }
}

class _PlanWithWebcamsDelegate extends MultiChildLayoutDelegate {
  _PlanWithWebcamsDelegate({
    required this.webcams,
    required this.isInteraction,
    required this.isInteractionEnd,
    required this.transformationController,
    required this.parameters,
  });
  final List<dynamic> webcams;
  final bool isInteraction;
  final bool isInteractionEnd;
  final TransformationController transformationController;
  Offset offset0 = const Offset(0.0, 0.0);
  final IFParameters parameters;

  @override
  void performLayout(Size size) {
    double sceneX = transformationController.toScene(offset0).dx;
    double sceneY = transformationController.toScene(offset0).dy;
    double scaleX = transformationController.value.entry(0, 0);
    double scaleY = transformationController.value.entry(1, 1);
    List<List<double>> widgetPositions =
        List.generate(webcams.length, (index) => List<double>.filled(4, 0.0));

    layoutChild(
      "-1",
      BoxConstraints(maxHeight: size.height, maxWidth: size.width),
    );

    positionChild("-1", offset0);
    widgetPositions = _calculatePositionWidgets(sceneX, sceneY, size.width,
        size.height, scaleX, scaleY, parameters, webcams, widgetPositions);
    if ((!isInteraction) && (!isInteractionEnd)) {
      for (int i = 0; i < webcams.length; i++) {
        if (hasChild(i.toString())) {
          layoutChild(
            i.toString(),
            BoxConstraints(maxHeight: size.height, maxWidth: size.width),
          );
          positionChild(
            i.toString(),
            Offset(widgetPositions[i][0], widgetPositions[i][1]),
          );
        }
      }
    }
  }

  List<List<double>> _calculatePositionWidgets(
      double sceneX,
      double sceneY,
      double screenWidth,
      double screenHeight,
      double scaleX,
      double scaleY,
      IFParameters parameters,
      List<dynamic> webcams,
      List<List<double>> widgetPositions) {
    Offset position = offset0;
    for (int i = 0; i < webcams.length; i++) {
      position = _position(
          sceneX,
          sceneY,
          screenWidth,
          screenHeight,
          scaleX,
          scaleY,
          parameters,
          webcams[i]["Plan_XY"][0].toDouble(),
          webcams[i]["Plan_XY"][1].toDouble(),
          webcams[i]["selected"]);
      widgetPositions[i][0] = position.dx;
      widgetPositions[i][1] = position.dy;
      widgetPositions[i][2] = position.dx +
          ((webcams[i]["selected"])
                  ? parameters.webcamWidth
                  : parameters.iconHeight) /
              scaleX;
      widgetPositions[i][3] = position.dy +
          ((webcams[i]["selected"])
                  ? parameters.webcamHeight
                  : parameters.iconHeight) /
              scaleY;
    }
    return widgetPositions;
  }

  Offset _position(
      double sceneX,
      double sceneY,
      double screenWidth,
      double screenHeight,
      double scaleX,
      double scaleY,
      dynamic parameters,
      double x,
      double y,
      bool selected) {
    double resultX = _Parameters.positionNotDisplay;
    double resultY = _Parameters.positionNotDisplay;
    double height =
        (selected) ? parameters.webcamHeight : parameters.iconHeight;
    double width = (selected) ? parameters.webcamWidth : parameters.iconWidth;

    if ((x >= sceneX) &&
        (x <= (sceneX + screenWidth / scaleX)) &&
        (y >= sceneY) &&
        (y <= (sceneY + screenHeight / scaleY))) {
      resultX = ((x - sceneX) * scaleX - (width / 2.0 / scaleX));
      resultY = ((y - sceneY) * scaleY - (height / 2.0 / scaleY));
      // repositionnement dans zone image si déborde en haut ou à gauche
      if (resultX < 0.0) {
        resultX = parameters.marginBorders;
      }
      if (resultY < 0.0) {
        resultY = parameters.marginBorders;
      }
      if ((resultX + width) > screenWidth) {
        resultX = screenWidth - width - parameters.marginBorders;
      }
      if ((resultY + height) > screenHeight) {
        resultY = screenHeight - height - parameters.marginBorders;
      }
    }
    return Offset(resultX, resultY);
  }

  @override
  bool shouldRelayout(_PlanWithWebcamsDelegate oldDelegate) {
    return ((oldDelegate.isInteraction != isInteraction) ||
        (oldDelegate.isInteractionEnd != isInteractionEnd));
  }
}

class IFWCalculateDurationAnimation {
  static getValue(
      {double velocity = _Parameters.defaultVelocity,
      double drag = _Parameters.defaultDrag,
      double effectivelyMotionless = 10}) {
    velocity = (velocity < _Parameters.defaultVelocity)
        ? _Parameters.defaultVelocity
        : velocity;
    return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
  }
}
