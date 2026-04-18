import 'package:flutter/foundation.dart';
import 'usuario.dart';
import 'api_service.dart';

enum AuthStatus { desconhecido, autenticado, naoAutenticado }

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  AuthStatus _status = AuthStatus.desconhecido;
  Usuario? _usuario;
  String? _erro;

  AuthStatus get status => _status;
  Usuario? get usuario => _usuario;
  String? get erro => _erro;
  bool get autenticado => _status == AuthStatus.autenticado;

  // Verifica se há sessão salva ao abrir o app
  Future<void> verificarSessao() async {
    if (await _api.temToken()) {
      try {
        final dados = await _api.getPerfil();
        _usuario = Usuario.fromJson(dados);
        _status = AuthStatus.autenticado;
      } catch (_) {
        await _api.limparToken();
        _status = AuthStatus.naoAutenticado;
      }
    } else {
      _status = AuthStatus.naoAutenticado;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    _erro = null;
    try {
      final dados = await _api.login(email: email, senha: senha);
      await _api.salvarToken(dados['token'] as String);
      _usuario = Usuario.fromJson(dados['usuario'] as Map<String, dynamic>);
      _status = AuthStatus.autenticado;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> registrar({
    required String nome,
    required String email,
    required String senha,
    required String perfil,
  }) async {
    _erro = null;
    try {
      final dados = await _api.registrar(
        nome: nome,
        email: email,
        senha: senha,
        perfil: perfil,
      );
      await _api.salvarToken(dados['token'] as String);
      _usuario = Usuario.fromJson(dados['usuario'] as Map<String, dynamic>);
      _status = AuthStatus.autenticado;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.limparToken();
    _usuario = null;
    _status = AuthStatus.naoAutenticado;
    notifyListeners();
  }

  String _mensagemErro(Object e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('401')) return 'E-mail ou senha incorretos.';
      if (msg.contains('409')) return 'E-mail já cadastrado.';
      if (msg.contains('SocketException')) return 'Sem conexão com o servidor.';
    }
    return 'Ocorreu um erro. Tente novamente.';
  }
}
