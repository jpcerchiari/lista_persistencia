import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool temaEscuro = false;
  double tamanhoFonte = 18;
  bool ocupado = true;
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    carregarPreferencias();
  }

  Future<void> carregarPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        temaEscuro = prefs.getBool('leitura.temaEscuro') ?? false;
        tamanhoFonte = prefs.getDouble('leitura.tamanhoFonte') ?? 18;
      });
    } catch (e) {
      if (mounted) {
        setState(() => mensagem = 'Não foi possível carregar as preferências.');
      }
    } finally {
      if (mounted) setState(() => ocupado = false);
    }
  }

  Future<void> salvarPreferencias() async {
    setState(() => ocupado = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final salvouTema = await prefs.setBool('leitura.temaEscuro', temaEscuro);
      final salvouFonte = await prefs.setDouble(
        'leitura.tamanhoFonte',
        tamanhoFonte,
      );
      if (!mounted) return;
      setState(() {
        mensagem = salvouTema && salvouFonte
            ? 'Preferências salvas.'
            : 'Não foi possível salvar as preferências.';
      });
    } catch (e) {
      if (mounted) {
        setState(() => mensagem = 'Não foi possível salvar as preferências.');
      }
    } finally {
      if (mounted) setState(() => ocupado = false);
    }
  }

  Future<void> restaurarPadrao() async {
    setState(() => ocupado = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final removeuTema = await prefs.remove('leitura.temaEscuro');
      final removeuFonte = await prefs.remove('leitura.tamanhoFonte');
      if (!mounted) return;
      setState(() {
        if (removeuTema && removeuFonte) {
          temaEscuro = false;
          tamanhoFonte = 18;
          mensagem = 'Padrão restaurado.';
        } else {
          mensagem = 'Não foi possível restaurar o padrão.';
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => mensagem = 'Não foi possível restaurar o padrão.');
      }
    } finally {
      if (mounted) setState(() => ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lorem ipsum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: temaEscuro ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: const Text('Lorem ipsum')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                style: TextStyle(fontSize: tamanhoFonte),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Tema escuro'),
                value: temaEscuro,
                onChanged: ocupado
                    ? null
                    : (valor) {
                        setState(() {
                          temaEscuro = valor;
                          mensagem = '';
                        });
                      },
              ),
              Text('Tamanho da fonte: ${tamanhoFonte.toInt()}'),
              Slider(
                value: tamanhoFonte,
                min: 14,
                max: 28,
                divisions: 7,
                label: tamanhoFonte.toInt().toString(),
                onChanged: ocupado
                    ? null
                    : (valor) {
                        setState(() {
                          tamanhoFonte = valor;
                          mensagem = '';
                        });
                      },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: ocupado ? null : salvarPreferencias,
                child: const Text('Salvar preferências'),
              ),
              TextButton(
                onPressed: ocupado ? null : restaurarPadrao,
                child: const Text('Restaurar padrão'),
              ),
              const SizedBox(height: 12),
              Text(ocupado ? 'Aguarde...' : mensagem),
            ],
          ),
        ),
      ),
    );
  }
}
