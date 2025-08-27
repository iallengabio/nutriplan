import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerfilTab extends ConsumerStatefulWidget {
  const PerfilTab({super.key});

  @override
  ConsumerState<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends ConsumerState<PerfilTab> {
  final _formKey = GlobalKey<FormState>();
  final _adultosController = TextEditingController();
  final _criancasController = TextEditingController();
  
  // Restrições alimentares
  bool _restricaoGluten = false;
  bool _restricaoLactose = false;
  bool _restricaoAcucar = false;
  bool _restricaoCarneVermelha = false;
  bool _restricaoFrango = false;
  bool _restricaoPeixe = false;
  bool _restricaoOvos = false;
  bool _restricaoFerro = false;
  bool _restricaoSodio = false;

  @override
  void initState() {
    super.initState();
    // TODO: Carregar dados salvos do perfil familiar
    _adultosController.text = '2';
    _criancasController.text = '1';
  }

  @override
  void dispose() {
    _adultosController.dispose();
    _criancasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perfil Familiar',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              
              // Composição familiar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Composição Familiar',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _adultosController,
                              decoration: const InputDecoration(
                                labelText: 'Número de adultos',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obrigatório';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number < 1) {
                                  return 'Deve ser um número maior que 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _criancasController,
                              decoration: const InputDecoration(
                                labelText: 'Número de crianças',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obrigatório';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number < 0) {
                                  return 'Deve ser um número maior ou igual a 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Restrições alimentares
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restrições Alimentares',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildRestricaoCheckbox('Glúten', _restricaoGluten, (value) {
                        setState(() => _restricaoGluten = value!);
                      }),
                      _buildRestricaoCheckbox('Lactose', _restricaoLactose, (value) {
                        setState(() => _restricaoLactose = value!);
                      }),
                      _buildRestricaoCheckbox('Açúcar', _restricaoAcucar, (value) {
                        setState(() => _restricaoAcucar = value!);
                      }),
                      _buildRestricaoCheckbox('Carne vermelha', _restricaoCarneVermelha, (value) {
                        setState(() => _restricaoCarneVermelha = value!);
                      }),
                      _buildRestricaoCheckbox('Frango', _restricaoFrango, (value) {
                        setState(() => _restricaoFrango = value!);
                      }),
                      _buildRestricaoCheckbox('Peixe', _restricaoPeixe, (value) {
                        setState(() => _restricaoPeixe = value!);
                      }),
                      _buildRestricaoCheckbox('Ovos', _restricaoOvos, (value) {
                        setState(() => _restricaoOvos = value!);
                      }),
                      _buildRestricaoCheckbox('Ferro', _restricaoFerro, (value) {
                        setState(() => _restricaoFerro = value!);
                      }),
                      _buildRestricaoCheckbox('Sal/Sódio', _restricaoSodio, (value) {
                        setState(() => _restricaoSodio = value!);
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarPerfil,
                  child: const Text('Salvar Alterações'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestricaoCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _salvarPerfil() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar salvamento do perfil familiar
      final adultos = int.parse(_adultosController.text);
      final criancas = int.parse(_criancasController.text);
      
      final restricoes = <String>[];
      if (_restricaoGluten) restricoes.add('Glúten');
      if (_restricaoLactose) restricoes.add('Lactose');
      if (_restricaoAcucar) restricoes.add('Açúcar');
      if (_restricaoCarneVermelha) restricoes.add('Carne vermelha');
      if (_restricaoFrango) restricoes.add('Frango');
      if (_restricaoPeixe) restricoes.add('Peixe');
      if (_restricaoOvos) restricoes.add('Ovos');
      if (_restricaoFerro) restricoes.add('Ferro');
      if (_restricaoSodio) restricoes.add('Sal/Sódio');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil familiar salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}