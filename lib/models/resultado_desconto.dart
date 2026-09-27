// ============================================================================
// MODELO — guarda os dados do cálculo de desconto
// ============================================================================
class ResultadoDesconto {
  final double precoOriginal;
  final double percentual;
  final double valorDesconto;
  final double precoFinal;

  ResultadoDesconto({
    required this.precoOriginal,
    required this.percentual,
    required this.valorDesconto,
    required this.precoFinal,
  });
}