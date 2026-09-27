// ============================================================================
// MODELO — guarda os dados do cálculo de parcelamento
// ============================================================================
class ResultadoParcelamento {
  final double valorTotal;
  final int parcelas;
  final double valorParcela;

  ResultadoParcelamento({
    required this.valorTotal,
    required this.parcelas,
    required this.valorParcela,
  });
}