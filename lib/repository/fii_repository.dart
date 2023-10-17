import 'package:expense_tracker/models/Fii.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FiiRepository {
  Future<List<Fii>> listarFiis() async {
    final supabase = Supabase.instance.client;

    var query =
        supabase.from('fii').select<List<Map<String, dynamic>>>();

    var data = await query;

    final list = data.map((map) {
      return Fii.fromMap(map);
    }).toList();

    return list;
  }

  Future cadastrarFii(Fii fii) async {
    final supabase = Supabase.instance.client;

    await supabase.from('fii').insert({
      'cotacao': fii.cotacao,
      'rendimento_anual': fii.rendimentoAnual,
      'sigla': fii.sigla,
      'quantidade': fii.qnt
    });
  }

  Future alterarFii(Fii fii) async {
    final supabase = Supabase.instance.client;

    await supabase.from('fii').update({
      'cotacao': fii.cotacao,
      'rendimento_anual': fii.rendimentoAnual,
      'sigla': fii.sigla,
      'quantidade': fii.qnt
    }).match({'id': fii.id});
  }

  Future excluirFii(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('fii').delete().match({'id': id});
  }
}
