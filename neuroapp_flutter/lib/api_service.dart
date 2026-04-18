import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000'; // Android emulator -> localhost
  // Para iOS simulator use: 'http://localhost:5000'
  // Para dispositivo físico use: 'http://SEU_IP_LOCAL:5000'

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    // Interceptor: injeta token JWT em todas as requisições
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException err, handler) {
        // 401 -> token expirado, limpa armazenamento local
        if (err.response?.statusCode == 401) {
          _storage.delete(key: _tokenKey);
        }
        return handler.next(err);
      },
    ));
  }

  // ── Token ──────────────────────────────────────────────────

  Future<void> salvarToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<void> limparToken() => _storage.delete(key: _tokenKey);

  Future<bool> temToken() async =>
      (await _storage.read(key: _tokenKey)) != null;

  // ── Auth ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> registrar({
    required String nome,
    required String email,
    required String senha,
    required String perfil, // 'usuario' | 'cuidador'
  }) async {
    final response = await _dio.post('/auth/registrar', data: {
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'senha': senha,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPerfil() async {
    final response = await _dio.get('/auth/perfil');
    return response.data as Map<String, dynamic>;
  }

  // ── Cuidador ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getMeusUsuarios() async {
    final response = await _dio.get('/cuidador/meus-usuarios');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> vincularUsuario(int usuarioId) async {
    final response = await _dio.post('/cuidador/vincular/$usuarioId');
    return response.data as Map<String, dynamic>;
  }
}
