import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_provider.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registro_screen.dart';
import '../screens/usuario/home_usuario_screen.dart';
import '../screens/cuidador/home_cuidador_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => appRouter);

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (BuildContext context, GoRouterState state) {
    final auth = context.read<AuthProvider>();
    final autenticado = auth.autenticado;
    final naAuth = state.matchedLocation == '/login' ||
        state.matchedLocation == '/registro' ||
        state.matchedLocation == '/splash';

    if (!autenticado && !naAuth) return '/login';

    if (autenticado && naAuth && state.matchedLocation != '/splash') {
      return auth.usuario!.isCuidador ? '/cuidador' : '/usuario';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/registro', builder: (_, __) => const RegistroScreen()),
    GoRoute(path: '/usuario', builder: (_, __) => const HomeUsuarioScreen()),
    GoRoute(path: '/cuidador', builder: (_, __) => const HomeCuidadorScreen()),
  ],
);
