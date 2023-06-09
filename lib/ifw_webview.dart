import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importation de l'orientation
import 'package:webview_flutter/webview_flutter.dart';

/// Widget Webview plein écran
///
/// Se présente sous la forme d'un widget de type page Scafold avec une
/// zone supérieure de navigation (bouton retour) et titre
/// (style : thème défaut) et la zone inférieure correspondant à la webview

class IFWFullScreenWebView extends StatefulWidget {
  /// Url à afficher dans la zone webview
  final String url;

  /// Méthode à exécuter  lors du retour
  final Function endRouting;

  /// Liste des orientations possibles de la page
  final List<DeviceOrientation>? beginOrientations;

  /// Liste des orientations possibles lors du retour
  final List<DeviceOrientation>? endOrientations;

  /// Titre de la zone supérieure de navigation
  final String? title;

  const IFWFullScreenWebView({
    super.key,
    required this.endRouting,
    required this.url,
    this.title,
    this.beginOrientations,
    this.endOrientations,
  });

  @override
  State<IFWFullScreenWebView> createState() => _IFWFullScreenWebView();
}

class _IFWFullScreenWebView extends State<IFWFullScreenWebView> {
  @override
  void initState() {
    super.initState();
    if (widget.beginOrientations != null) {
      SystemChrome.setPreferredOrientations(widget.beginOrientations!);
    }
  }

  void onClose() {
    if (widget.endOrientations != null) {
      SystemChrome.setPreferredOrientations(widget.endOrientations!).then((_) {
        widget.endRouting(context);
      });
    } else {
      widget.endRouting(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _IFWInternalFullScreenWebView(
      url: widget.url,
      title: widget.title,
      onPressed: () {
        onClose();
      },
    );
  }
}

class _IFWInternalFullScreenWebView extends StatelessWidget {
  final String url;
  final Function onPressed;
  final String? title;

  const _IFWInternalFullScreenWebView({
    required this.url,
    required this.onPressed,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    // String localTitle = ((title != null) ? title : "")!;
    return Material(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            title ?? " ",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.orange),
            onPressed: () => onPressed(),
          )),
      body: IFWWebView(url: url),
    ));
  }
}


class IFWWebView extends StatefulWidget {
  final String url;
  const IFWWebView({
    super.key,
    required this.url,
  });

  @override
  State<IFWWebView> createState() => _IFWWebViewState();
}

class _IFWWebViewState extends State<IFWWebView> {
  late final WebViewController
      controller; // Définition tardive (late) du contrôleur WebViewController

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(
          JavaScriptMode.unrestricted) // Activation du mode JavaScript
      ..setBackgroundColor(const Color(
          0x00000000)) // Définition de la couleur de fond (transparente)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Mettre à jour la barre de chargement.
          },
          onPageStarted: (String url) {
            // Callback appelée lorsque le chargement de la page débute
          },
          onPageFinished: (String url) {
            // Callback appelée lorsque le chargement de la page est terminé
          },
          onWebResourceError: (WebResourceError error) {
            // Callback appelée en cas d'erreur de chargement des ressources Web
          },
          onNavigationRequest: (NavigationRequest request) {
            // Callback appelée lorsqu'une navigation est demandée
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision
                  .prevent; // Empêche la navigation si l'URL commence par 'https://www.youtube.com/'
            }
            return NavigationDecision
                .navigate; // Autorise la navigation pour toutes les autres URLs
          },
        ),
      )
      ..loadRequest(
          Uri.parse(widget.url)); // Charge l'URL spécifiée dans le contrôleur
  }

  @override
  void didUpdateWidget(covariant IFWWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.loadRequest(Uri.parse(widget.url)); // Met à jour l'URL chargée dans le contrôleur lorsque le widget est mis à jour
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
        controller:
            controller); // Retourne un widget WebViewWidget avec le contrôleur spécifié
  }
}

