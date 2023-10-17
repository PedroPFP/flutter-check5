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
        backgroundColor: Colors.amber,
        child: Icon(
          Icons.attach_money,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(fii.sigla.toString()),
      subtitle: Text(fii.cotacao.toString()+" - "+ fii.qnt.toString()),
      trailing: Text(fii.rendimentoAnual.toString()+"%"),
      onTap: onTap,
    );
  }
}
