import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../utils/tema.dart';

class HomeUsuarioScreen extends StatelessWidget {
  const HomeUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${usuario.nome.split(' ').first}! 👋'),
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
            // Banner de boas-vindas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTema.primariaClara,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Como você está hoje?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTema.primaria)),
                  const SizedBox(height: 4),
                  Text('Vamos organizar seu dia juntos.',
                      style: TextStyle(
                          fontSize: 14, color: AppTema.primaria.withOpacity(0.8))),
                  const SizedBox(height: 16),
                  // Check-in emocional rápido
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _EmojiHumor(emoji: '😄', label: 'Ótimo'),
                      _EmojiHumor(emoji: '🙂', label: 'Bem'),
                      _EmojiHumor(emoji: '😐', label: 'Ok'),
                      _EmojiHumor(emoji: '😔', label: 'Difícil'),
                      _EmojiHumor(emoji: '😰', label: 'Crise'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text('Seus módulos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // Grid de módulos
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
              children: const [
                _CardModulo(
                  icone: Icons.calendar_today_rounded,
                  titulo: 'Rotinas',
                  descricao: 'Organize seu dia',
                  cor: Color(0xFF3B6FD4),
                  disponivel: true,
                ),
                _CardModulo(
                  icone: Icons.chat_bubble_outline_rounded,
                  titulo: 'Comunicação',
                  descricao: 'CAA e símbolos',
                  cor: Color(0xFF7C3AED),
                  disponivel: false,
                ),
                _CardModulo(
                  icone: Icons.favorite_outline_rounded,
                  titulo: 'Emocional',
                  descricao: 'Como estou me sentindo',
                  cor: Color(0xFFDB2777),
                  disponivel: false,
                ),
                _CardModulo(
                  icone: Icons.star_outline_rounded,
                  titulo: 'Conquistas',
                  descricao: 'Metas e recompensas',
                  cor: Color(0xFFD97706),
                  disponivel: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiHumor extends StatelessWidget {
  final String emoji;
  final String label;

  const _EmojiHumor({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Humor registrado: $label'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppTema.primaria,
          ),
        );
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: AppTema.primaria.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _CardModulo extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final Color cor;
  final bool disponivel;

  const _CardModulo({
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.disponivel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disponivel
          ? () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Abrindo $titulo...')),
              )
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: disponivel ? cor.withOpacity(0.08) : AppTema.borda.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: disponivel ? cor.withOpacity(0.3) : AppTema.borda),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone,
                size: 32, color: disponivel ? cor : AppTema.textoSecundario),
            const Spacer(),
            Text(titulo,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: disponivel ? AppTema.textoPrimario : AppTema.textoSecundario)),
            const SizedBox(height: 2),
            Text(descricao,
                style: TextStyle(fontSize: 12, color: AppTema.textoSecundario)),
            if (!disponivel) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTema.borda,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Em breve',
                    style: TextStyle(
                        fontSize: 10, color: AppTema.textoSecundario)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
