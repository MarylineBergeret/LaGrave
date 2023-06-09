import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webcam_service.dart';
import 'webcam_list.dart';
import 'transition.dart';
import 'langues.dart';

const Color maCouleur = Color.fromRGBO(240, 121, 36, 1);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('lang');
  runApp(MyApp(startingLanguageCode: langCode));
}

class MyApp extends StatelessWidget {
  final String? startingLanguageCode;
  const MyApp({Key? key, required this.startingLanguageCode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LanguageCubit(startingLanguageCode: startingLanguageCode),
      child: BlocBuilder<LanguageCubit, Locale>(builder: (context, lang) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: lang,
          title: 'Test Splashscreen',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), Locale('fr', ''),
            Locale('es', ''), // anglais, francais, espagnol
            Locale('pt', ''), Locale('de', ''),
            Locale('ar', ''), // portugais, allemand, arabe
            Locale('ja', ''), Locale('id', ''),
            Locale('it', ''), // japonais, hindou, italien
            Locale('zh', ''), // chinois
          ], 
          home: const SplashScreen(title: 'Test Splashscreen'),
        );
      }),
    );
  }
}

class LanguageCubit extends Cubit<Locale> {
  final String? startingLanguageCode;
  LanguageCubit({this.startingLanguageCode})
      : super(Locale(startingLanguageCode ?? 'fr', ''));

  void changeLang(BuildContext context, String languageCode) async {
    emit(Locale(languageCode, ''));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', languageCode);
  }
}

// **********SPLASHSCREEN**********
class SplashScreen extends StatelessWidget {
  final String title;
  const SplashScreen({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/fond_splashscreen.png'),
            fit: BoxFit.cover, //image sur tout l'écran
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150), // espace en hauteur
              Image.asset(
                'images/logo_C.png',
                height: 120,
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.white,
                indent: 110,
                endIndent: 110,
              ), //trait pour séparation
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .titre
                          .toUpperCase(), // appel du titre selon la langue choisie
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.titre1.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.9,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  navigateToPage(context, const HomePage());
                }, // transition intence
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: Colors.white, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.connexion),
                    const SizedBox(width: 15),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
            top: 16.0), // Décalage vers le bas de 16.0 pixels
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0),
          ),
          child: FloatingActionButton(
            onPressed: () {
              showLanguageMenu(context);
            },
            backgroundColor: Colors.transparent,
            child: const Icon(
              Icons.flag_circle_outlined,
              size: 30,
              color: maCouleur,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

// *************HOMEPAGE*************
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fond_splashscreen.png'),
              fit: BoxFit.cover, // sur toute la page
            ),
          ),
          child: Column(
            children: [
              // barre de nav en haut de l'écran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(left: 16, top: 35, right: 16),
                    decoration: BoxDecoration(
                      color: maCouleur,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.only(bottom: 2.6, right: 1.9),
                      icon: const Icon(Icons.menu,
                          size: 20.0, color: Colors.white),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen(
                                  title:
                                      'Test Splashscreen')), // Remplacez SplashScreen par le nom de votre page SplashScreen
                          (Route<dynamic> route) =>
                              false, // Supprime toutes les autres routes de la pile
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(left: 16, top: 35, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.only(bottom: 2.6, right: 2.4),
                      icon: const Icon(
                        Icons.alarm,
                        size: 20.0,
                        color: maCouleur,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0), // espace
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'images/logo_C.png',
                      fit: BoxFit.contain,
                      height: 90,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 14.0),
                          child: Icon(
                            Icons.wb_sunny_rounded,
                            size: 28,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.grey.withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                'à 3200m',
                                // Text(localization.distance(3200)), // Affiche "3200m"
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 23.0),
                              child: Text(
                                '3°C',
                                // Text(localization.temperature(3)), // Affiche "3°C"
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 25.0,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.meije.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: maCouleur,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              // sous-titre de la page
              Text(
                AppLocalizations.of(context)!.yeux.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              // 3 boutons -> 1 row, 3 columns
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.wb_sunny_outlined,
                              color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => const HomePage(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        AppLocalizations.of(context)!.meteo.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: maCouleur,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.brightness_low_outlined,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => const SplashScreen(
                                    title: 'Test Splashscreen'),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        AppLocalizations.of(context)!.ouverture.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add_shopping_cart_outlined,
                              color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => const HomePage(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        AppLocalizations.of(context)!.pass.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 17),
              // nouvelle Row avec 2 columns
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 0.3,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Image.asset('images/home_domaine.png'),
                      ],
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 4 lignes de texte
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .domaine
                                  .toUpperCase(),
                              style: const TextStyle(
                                letterSpacing: 2,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.acces.toUpperCase(),
                              style: const TextStyle(
                                letterSpacing: 2.8,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.decouvrez,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.titre1,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  pageBuilder: (_, __, ___) => const HomePage(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                    return SlideTransition(
                                      position: Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 205, 75, 24),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                // side: const BorderSide(
                                //     color: Colors.white, width: 1.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.carte,
                                ),
                                const SizedBox(width: 6.0),
                                const Icon(Icons.visibility, size: 17),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              // 1 row : 2 columns
              Container(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1st column
                    Column(
                      children: [
                        // 1st row, 1st column
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Image.asset('images/home_parcours.png',
                                    height: 80),
                                const Positioned(
                                  left: 20,
                                  top: 20,
                                  child: Icon(
                                    Icons.directions_walk_outlined,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  bottom: 20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .nos
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .parcours
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .decouvrir
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      const Positioned(
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 2nd column
                    Column(
                      children: [
                        // Bouton webcams * Premiere ligne de la deuxieme colonne
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey, width: 1.0),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.photo_camera_outlined,
                                    size: 32),
                                color: Colors.black,
                                onPressed: () {
                                  fetchWebcamUrls().then((webcams) {
                                    simulatePageLoading(
                                        context, WebcamList(webcams: webcams));
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        // Texte webcams * Deuxieme ligne de la deuxieme colonne
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            AppLocalizations.of(context)!.webcams.toUpperCase(),
                            style: const TextStyle(
                              color: maCouleur,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 105),
            ],
          ),
        ),
      ),
    );
  }
}


