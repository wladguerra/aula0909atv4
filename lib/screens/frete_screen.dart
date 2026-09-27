import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atividade04/models/resultado_frete.dart';

class FreteScreen extends StatefulWidget {
  const FreteScreen({super.key});

  @override
  State<FreteScreen> createState() => _FreteScreenState();
}

class _FreteScreenState extends State<FreteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _compraController = TextEditingController();
  final _minimoController = TextEditingController();

  ResultadoFrete? _resultado;
  final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  void _calcularFrete() {
    if (!_formKey.currentState!.validate()) return;

    final valorCompra = double.parse(_compraController.text.replaceAll(',', '.'));
    final valorMinimo = double.parse(_minimoController.text.replaceAll(',', '.'));

    final temFreteGratis = valorCompra >= valorMinimo;
    final valorFaltante = temFreteGratis ? 0.0 : (valorMinimo - valorCompra);

    setState(() {
      _resultado = ResultadoFrete(
        valorCompra: valorCompra,
        valorMinimo: valorMinimo,
        temFreteGratis: temFreteGratis,
        valorFaltante: double.parse(valorFaltante.toStringAsFixed(2)),
      );
    });
  }

  String? _validarValor(String? valor, String campo) {
    if (valor == null || valor.isEmpty) return 'Informe $campo';
    final numero = double.tryParse(valor.replaceAll(',', '.'));
    if (numero == null || numero <= 0) return 'Informe um valor numérico válido';
    return null;
  }

  @override
  void dispose() {
    _compraController.dispose();
    _minimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcular Frete Grátis')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _compraController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor da compra (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.point_of_sale),
                ),
                validator: (v) => _validarValor(v, 'o valor da compra'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _minimoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor mínimo para frete grátis (R\$)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping),
                ),
                validator: (v) => _validarValor(v, 'o valor mínimo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularFrete,
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

  Widget _buildResultado(ResultadoFrete r) {
    if (r.temFreteGratis) {
      return Card(
        color: Colors.green.shade50,
        elevation: 3,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Text(
                'Frete grátis liberado!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.orange.shade50,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Faltam ${_formatoMoeda.format(r.valorFaltante)} para conseguir o frete grátis!',
          style: TextStyle(
            color: Colors.orange.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}