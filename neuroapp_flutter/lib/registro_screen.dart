import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/auth_provider.dart';
import '../../utils/tema.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  String _perfil = 'usuario'; // padrão
  bool _senhaVisivel = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);

    final auth = context.read<AuthProvider>();
    final ok = await auth.registrar(
      nome: _nomeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      senha: _senhaCtrl.text,
      perfil: _perfil,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (ok) {
      context.go(auth.usuario!.isCuidador ? '/cuidador' : '/usuario');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.erro ?? 'Erro ao cadastrar.'),
          backgroundColor: AppTema.erro,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Criar conta',
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Preencha seus dados para começar.',
                    style: TextStyle(
                        fontSize: 16, color: AppTema.textoSecundario)),

                const SizedBox(height: 32),

                // Seleção de perfil — card visual
                const Text('Quem é você?',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _CardPerfil(
                      titulo: 'Sou neurodivergente',
                      icone: Icons.self_improvement_rounded,
                      cor: AppTema.primaria,
                      corClara: AppTema.primariaClara,
                      selecionado: _perfil == 'usuario',
                      onTap: () => setState(() => _perfil = 'usuario'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _CardPerfil(
                      titulo: 'Sou cuidador',
                      icone: Icons.favorite_rounded,
                      cor: AppTema.cuidador,
                      corClara: AppTema.cuidadorClara,
                      selecionado: _perfil == 'cuidador',
                      onTap: () => setState(() => _perfil = 'cuidador'),
                    )),
                  ],
                ),

                const SizedBox(height: 24),

                // Nome
                TextFormField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe seu nome.' : null,
                ),
                const SizedBox(height: 16),

                // E-mail
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe seu e-mail.';
                    if (!v.contains('@')) return 'E-mail inválido.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Senha
                TextFormField(
                  controller: _senhaCtrl,
                  obscureText: !_senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_senhaVisivel
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _senhaVisivel = !_senhaVisivel),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe uma senha.';
                    if (v.length < 6) return 'Mínimo 6 caracteres.';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _carregando ? null : _cadastrar,
                  child: _carregando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Criar conta'),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14, color: AppTema.textoSecundario),
                        children: [
                          const TextSpan(text: 'Já tem conta? '),
                          TextSpan(
                            text: 'Entrar',
                            style: TextStyle(
                                color: AppTema.primaria,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardPerfil extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final Color corClara;
  final bool selecionado;
  final VoidCallback onTap;

  const _CardPerfil({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.corClara,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: selecionado ? corClara : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado ? cor : AppTema.borda,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icone, size: 36, color: selecionado ? cor : AppTema.textoSecundario),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selecionado ? cor : AppTema.textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
