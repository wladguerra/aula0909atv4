// ============================================================================
// MODELO — guarda os dados do cálculo de frete grátis
// ============================================================================
class ResultadoFrete {
  final double valorCompra;
  final double valorMinimo;
  final bool temFreteGratis;
  final double valorFaltante;

  ResultadoFrete({
    required this.valorCompra,
    required this.valorMinimo,
    required this.temFreteGratis,
    required this.valorFaltante,
  });
}