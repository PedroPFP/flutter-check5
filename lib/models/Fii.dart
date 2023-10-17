class Fii{
   int id;
   String sigla;
   double cotacao;
   double rendimentoAnual;
   int qnt;

   Fii({required this.id, required this.sigla, required this.cotacao, required this.rendimentoAnual, required this.qnt});

  factory Fii.fromMap(Map<String, dynamic> map) {
    return Fii(
      id: map['id'],
      sigla: map['sigla'],
      cotacao: map['cotacao'],
      rendimentoAnual: map['rendimento_anual'],
      qnt: map['quantidade'],
    );
  }

}