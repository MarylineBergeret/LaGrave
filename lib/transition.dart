import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void navigateToPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => page,
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
}

Future<void> simulatePageLoading(BuildContext context, Widget page) async {
  await Future.delayed(
      const Duration(milliseconds: 2000)); // Simule une attente de 2 secondes

  // ignore: use_build_context_synchronously
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return FutureBuilder(
        future:
            _loadPage(), // Remplacez `_loadPage()` par votre fonction de chargement de la page d'arrivée
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez une page de chargement tant que la page d'arrivée n'est pas prête
            return const LoadingPage();
          } else {
            // Une fois que la page d'arrivée est prête, naviguez vers cette page
            return page;
          }
        },
      );
    }),
  );
}

Future<void> _loadPage() async {
  await Future.delayed(
      const Duration(seconds: 2)); // Exemple d'attente simulée de 2 secondes
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 76, 133), // Fond noir
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(ModalRoute.of(context)!.animation!),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors
                    .orange), // Set CircularProgressIndicator color to orange
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.chargement.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white, // Set text color to white
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

