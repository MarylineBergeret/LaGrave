import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

void showLanguageMenu(BuildContext context) {
  final languageCubit = context.read<LanguageCubit>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sélectionner la langue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ListTile(
                leading: Image.asset(
                  'images/united-kingdom.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('English'),
                onTap: () {
                  languageCubit.changeLang(context, 'en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/france.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Français'),
                onTap: () {
                  languageCubit.changeLang(context, 'fr');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/spain.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Español'),
                onTap: () {
                  languageCubit.changeLang(context, 'es');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/italy.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Italian'),
                onTap: () {
                  languageCubit.changeLang(context, 'it');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/portugal.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Portugais'),
                onTap: () {
                  languageCubit.changeLang(context, 'pt');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/germany.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Deutsh'),
                onTap: () {
                  languageCubit.changeLang(context, 'de');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/united-arab-emirates.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Arabe'),
                onTap: () {
                  languageCubit.changeLang(context, 'ar');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/japan.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Japonais'),
                onTap: () {
                  languageCubit.changeLang(context, 'ja');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/china.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('Chinois'),
                onTap: () {
                  languageCubit.changeLang(context, 'zh');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/united-kingdom.png',
                  width: 30,
                  height: 30,
                ), // Replace with your flag image asset
                title: const Text('English'),
                onTap: () {
                  languageCubit.changeLang(context, 'en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
