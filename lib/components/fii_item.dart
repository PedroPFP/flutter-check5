import 'package:expense_tracker/models/Fii.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FiiItem extends StatelessWidget {
  final Fii fii;
  final void Function()? onTap;
  const FiiItem({Key? key, required this.fii, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(      
        child: Text(fii.sigla)
      ),
      title: Text(fii.cotacao.toString()),
      subtitle: Text(fii.qnt.toString()),
      trailing: Text(fii.rendimentoAnual.toString()),
      onTap: onTap,
    );
  }
}
