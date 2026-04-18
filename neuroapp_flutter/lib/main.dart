import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'tema.dart';
import 'auth_provider.dart';

void main() {
  runApp(const NeuroApp());
}

class NeuroApp extends StatelessWidget {
  const NeuroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'NeuroApp',
            debugShowCheckedModeBanner: false,
            theme: AppTema.tema,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
