import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atividade04/models/resultado_desconto.dart';

class DescontoScreen extends StatefulWidget {
  const DescontoScreen({super.key});

  @override
  State<DescontoScreen> createState() => _DescontoScreenState();
}

class _DescontoScreenState extends State<DescontoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _precoController = TextEditingController();
  final _percentualController = TextEditingController();

  ResultadoDesconto? _resultado;
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _calcularDesconto() {
    if (!_formKey.currentState!.validate()) return;

    final precoOriginal = double.parse(_precoController.text.replaceAll(',', '.'));
    final percentual = double.parse(_percentualController.text.replaceAll(',', '.'));

    final valorDesconto = precoOriginal * (percentual / 100);
    final precoFinal = precoOriginal - valorDesconto;

    setState(() {
      _resultado = ResultadoDesconto(
        precoOriginal: precoOriginal,
        percentual: percentual,
        valorDesconto: double.parse(valorDesconto.toStringAsFixed(2)),
        precoFinal: double.parse(precoFinal.toStringAsFixed(2)),
      );
    });
  }

  String? _validarPreco(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe o preço';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0) return 'Informe um valor válido';
    return null;
  }

  String? _validarPercentual(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe o percentual';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero < 0 || numero > 100) {
      return 'Informe um percentual entre 0 e 100';
    }
    return null;
  }

  @override
  void dispose() {
    _precoController.dispose();
    _percentualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Desconto')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _precoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Preço original (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: _validarPreco,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _percentualController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Percentual de desconto (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: _validarPercentual,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularDesconto,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Calcular', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              if (_resultado != null) _buildResultado(_resultado!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultado(ResultadoDesconto r) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _linha('Valor do desconto', '- ${_formatoMoeda.format(r.valorDesconto)}'),
            const Divider(),
            _linha(
              'Preço final',
              _formatoMoeda.format(r.precoFinal),
              destaque: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _linha(String rotulo, String valor, {bool destaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rotulo,
            style: destaque ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: destaque ? Colors.purple : null,
              fontSize: destaque ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}