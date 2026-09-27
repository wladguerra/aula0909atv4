import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atividade04/models/resultado_parcelamento.dart';

class ParcelamentoScreen extends StatefulWidget {
  const ParcelamentoScreen({super.key});

  @override
  State<ParcelamentoScreen> createState() => _ParcelamentoScreenState();
}

class _ParcelamentoScreenState extends State<ParcelamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _parcelasController = TextEditingController();

  ResultadoParcelamento? _resultado;
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _calcularParcelamento() {
    if (!_formKey.currentState!.validate()) return;

    final valorTotal = double.parse(_valorController.text.replaceAll(',', '.'));
    final parcelas = int.parse(_parcelasController.text);
    final valorParcela = valorTotal / parcelas;

    setState(() {
      _resultado = ResultadoParcelamento(
        valorTotal: valorTotal,
        parcelas: parcelas,
        valorParcela: double.parse(valorParcela.toStringAsFixed(2)),
      );
    });
  }

  String? _validarValor(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe o valor total';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0) return 'Informe um valor numérico válido';
    return null;
  }

  String? _validarParcelas(String? valor) {
    if (valor == null || valor.isEmpty) return 'Informe o nº de parcelas';
    final numero = int.tryParse(valor);
    if (numero == null || numero <= 0) return 'Informe um número inteiro > 0';
    return null;
  }

  @override
  void dispose() {
    _valorController.dispose();
    _parcelasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Parcelamento')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _valorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor total da compra (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _parcelasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de parcelas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: _validarParcelas,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularParcelamento,
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

  Widget _buildResultado(ResultadoParcelamento r) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${r.parcelas}x de:'),
                Text(
                  _formatoMoeda.format(r.valorParcela),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}