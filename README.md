# la_grave_1

A new Flutter project.

## Getting Started
Le langage dart est un langage orienté objet


## Bonnes pratiques :
   - Utilisez des majuscules pour les noms de classes et de widgets (par exemple, `MyWidget`).
   - Style de nommage en camelcase pour les variables et les méthodes (par exemple, `myVariable`, `myMethod`).
   - @override est une annotation qui garantit que vous redéfinissez correctement une méthode héritée ou une interface implémentée, et c'est une bonne pratique de l'utiliser pour améliorer la lisibilité et la maintenabilité du code.
   - Utilisez le mot-clé `const` pour déclarer des valeurs immuables lors de la création d'objets, tels que des chaînes de texte, des nombres et des listes (permet d'optimiser les performances et de réduire la consommation de mémoire), préférez `final` pour déclarer des variables qui ne changeront pas après leur initialisation (permet de garantir l'immutabilité des valeurs et de faciliter la compréhension du code)..
   - Importez uniquement les packages, les bibliothèques et les classes dont vous avez réellement besoin.
   - Dans la mesure du possible, divisez votre code en widgets réutilisables et indépendants.
   - Séparez la logique métier de l'interface utilisateur en utilisant le modèle MVC (Modèle-Vue-Contrôleur) ou le modèle BLoC (Business Logic Component).
   - Utilisez le mot-clé 
   - Utilisez des bibliothèques de tests, telles que `flutter_test`, pour effectuer des tests unitaires automatisés.



## Configuration
L'application utilise les fonctionnalités suivantes qui nécessitent une configuration préalable :

- Les dépendences se trouvent dans le pubspec.yaml pour l'utilisation des packages, (attention a la casse et les espaces !!!)
- installer les dépendences dans le pubspec.yaml, attention a la casse et les espaces !!! 

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  cupertino_icons: ^1.0.2
  http: ^0.13.5
  webview_flutter: ^4.0.7
  shared_preferences: ^2.1.1
  flutter_inappwebview: ^5.7.2+3
  flutter_bloc: ^8.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  ifp_widgets :
    path: ../ifp_widgets
  flutter_launcher_icons: ^0.13.1
  flutter_lints: ^2.0.0
flutter_icons:
  android: "launcher_icon" 
  ios: true
  image_path: "images/logo_C.png" 



flutter:
  generate: true
  uses-material-design: true
  assets:
   - images/


## Utilisation
Voici comment utiliser l'application :

1. fichier principal: main.dart
2. Package ifw_webview.dart à installer :

- IFWWebView : widget pour afficher une URL dans une zone de l'interface
- IFWFullScreenWebView : widget page plein écran pour afficher une URL
- IFWPlanWithWebcams : widget plan webcams : afficher une image représentant une carte 

Il est conseillé d'installer ce package local au même niveau que le dossier du ou des projets flutter qui vont l'utiliser.
Le nom du dossier contenant ce package doit être ifp_widgets.

Dans le projet flutter utilisateur, il faut configurer les dépendances; dans le fichier pubspec.yaml, dans la rubrique dev_dependencies, ajouter les 2 lignes suivantes :
  ifp_widgets :
    path: ../ifp_widgets

Il faut également installer le package webview_flutter : https://pub.dev/packages/webview_flutter
Procédure installation particulière : 
- installation : https://pub.dev/packages/webview_flutter/install
- dans le projet utilisateur du package : 
You should however make sure to set the correct minSdkVersion in android/app/build.gradle if it was previously lower than 19:
android {
    defaultConfig {
        minSdkVersion 19
    }
}

L'utilisation du widget IFWPlanWithWebcams nécessite auparavant l'utilisation du widget MaterialApp dans l'application. 
Voir sources de 2 exemples dans le dossier example

Exemple composant webview : 
```dart
SizedBox(
    height: 200,
    child: (_urlView == "")
        ? const Text("")
        : IFWWebView(url: _urlView),
),
```

Exemple lancement page plein écran webview : 
```dart
Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IFWFullScreenWebView(
                url: _urlView,
                title: _urlView.substring(_urlView.lastIndexOf("/")),
                endRouting: (context) => {Navigator.pop(context)},
                beginOrientations: const [
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ],
                endOrientations: const [DeviceOrientation.portraitUp],
              )));
```


3. La requête pour récupérer les données des webcams est dans webcam_list.dart
- [Sous-étape 1]
- [Sous-étape 2]
4. [Étape 4]

## Ressources :
Voici quelques ressources utiles pour en savoir plus sur Flutter :

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter GitHub Repository](https://github.com/flutter/flutter)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
# following page: https://dart.dev/tools/pub/pubspec

## Changer l'icône de l'application et le texte affiché :
Dans dev.dependencies:

dev_dependencies:
  flutter_test:
    sdk: flutter
  ifp_widgets :
    path: ../ifp_widgets
  flutter_launcher_icons: ^0.13.1  (ou flutter pub add flutter_launcher_icons)

flutter_icons:
  android: "launcher_icon" 
  ios: true
  image_path: "images/logo_C.png" 



 - dans la console: flutter pub run flutter_icons:main

pour Android>app>src>main>AndroidManifest
modifier "android:label"

pour Ios>Runner>info.plist>
key : CFBundleDisplayName
script : "nom affiché de l'application"


## Package langues :
- Création du dossier l10n dans le lib avec les fichiers selon les langues souhaitées : app-fr.arb, app-en.arb, app-es.arb ect...

Mettre les clés et les valeurs avec cette syntaxe selon la langue:
{
  "@@locale": "fr",        |    "@@locale": "es",  
  "titre": "L'expérience", |    "titre": "La experiencia",
  "domaine": "le domaine"  |    "domaine": "el dominio"
}

- Création fichier l10n.yaml à la racine du projet :
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart

- Dans le puspec.yaml :
 dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
flutter pub get (pour l'installation des dépendances)
- Dans la console :
flutter gen-l10 (génère dans le dart_tool, gen_l10n, tous les fichiers) 
## penser à relancer cette commande si des modifications sont apportées.

Les packages peuvent être appelés et utilisés dans le main.dart (voir le 1er bloc pour application, langue par défaut et enregistrement de celle sélectionnée)
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
pour enregistrer la langue sélectionnée afin qu elle soit activé au redémarrage:
import 'package:shared_preferences/shared_preferences.dart';
```