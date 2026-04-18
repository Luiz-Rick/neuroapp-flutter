import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'api_service.dart';
import 'tema.dart';

class HomeCuidadorScreen extends StatefulWidget {
  const HomeCuidadorScreen({super.key});

  @override
  State<HomeCuidadorScreen> createState() => _HomeCuidadorScreenState();
}

class _HomeCuidadorScreenState extends State<HomeCuidadorScreen> {
  final _api = ApiService();
  List<Map<String, dynamic>> _usuarios = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    try {
      final dados = await _api.getMeusUsuarios();
      setState(() {
        _usuarios = List<Map<String, dynamic>>.from(
            dados['usuarios_vinculados'] as List);
        _carregando = false;
      });
    } catch (_) {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuidador = context.watch<AuthProvider>().usuario!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${cuidador.nome.split(' ').first}! 💚'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Painel resumo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTema.cuidadorClara,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite_rounded,
                      color: AppTema.cuidador, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Painel do cuidador',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppTema.cuidador)),
                        const SizedBox(height: 4),
                        Text(
                          '${_usuarios.length} usuário(s) vinculado(s)',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTema.cuidador.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Usuários vinculados',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                TextButton.icon(
                  onPressed: _carregarUsuarios,
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Atualizar'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_carregando)
              const Center(child: CircularProgressIndicator())
            else if (_usuarios.isEmpty)
              _EmptyUsuarios()
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _usuarios.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final u = _usuarios[index];
                  return _CardUsuario(usuario: u);
                },
              ),

            const SizedBox(height: 28),

            const Text('Ações rápidas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: const [
                _CardAcao(
                    icone: Icons.bar_chart_rounded,
                    titulo: 'Relatórios',
                    cor: Color(0xFF2E7D6B)),
                _CardAcao(
                    icone: Icons.notifications_outlined,
                    titulo: 'Alertas',
                    cor: Color(0xFFD97706)),
                _CardAcao(
                    icone: Icons.tune_rounded,
                    titulo: 'Personalizar',
                    cor: Color(0xFF3B6FD4)),
                _CardAcao(
                    icone: Icons.history_rounded,
                    titulo: 'Histórico',
                    cor: Color(0xFF7C3AED)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardUsuario extends StatelessWidget {
  final Map<String, dynamic> usuario;
  const _CardUsuario({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final nome = usuario['nome'] as String;
    final iniciais = nome.split(' ').take(2).map((p) => p[0]).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTema.borda),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTema.primariaClara,
            child: Text(iniciais,
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: AppTema.primaria)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                Text(usuario['email'] as String,
                    style: TextStyle(
                        fontSize: 13, color: AppTema.textoSecundario)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppTema.textoSecundario),
        ],
      ),
    );
  }
}

class _EmptyUsuarios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTema.borda.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline_rounded,
              size: 48, color: AppTema.textoSecundario),
          const SizedBox(height: 12),
          Text('Nenhum usuário vinculado ainda.',
              style:
                  TextStyle(fontSize: 15, color: AppTema.textoSecundario)),
          const SizedBox(height: 4),
          Text('Use o endpoint /cuidador/vincular para conectar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, color: AppTema.textoSecundario.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _CardAcao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final Color cor;

  const _CardAcao(
      {required this.icone, required this.titulo, required this.cor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$titulo — em breve!')),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cor.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 32, color: cor),
            const SizedBox(height: 8),
            Text(titulo,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTema.textoPrimario)),
          ],
        ),
      ),
    );
  }
}
