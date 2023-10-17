import 'package:expense_tracker/models/Fii.dart';
import 'package:expense_tracker/repository/fii_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class FiiCadastroPage extends StatefulWidget {
  final Fii? fiiParaEdicao;

  const FiiCadastroPage({super.key, this.fiiParaEdicao});

  @override
  State<FiiCadastroPage> createState() => _FiiCadastroPageState();
}

class _FiiCadastroPageState extends State<FiiCadastroPage> {
  final fiiRepo = FiiRepository();

  final siglaController = TextEditingController();
  final qntController = TextEditingController();

  final cotacaoController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  final rendimentoController = TextEditingController();

  final dataController = TextEditingController();

  final detalhesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {

    final fii = widget.fiiParaEdicao;

    if (fii != null) {
      cotacaoController.text = NumberFormat.simpleCurrency(locale: 'pt_BR').format(fii.cotacao);
      siglaController.text = fii.sigla;

      rendimentoController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(fii.rendimentoAnual);

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Fiis/Ações'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSigla(),
                const SizedBox(height: 30),
                _buildCotacao(),
                const SizedBox(height: 30),
                _buildRendimentoAnual(),
                const SizedBox(height: 30),
                _buildQuantidade(),
                const SizedBox(height: 30),
                _buildButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildSigla() {
    return TextFormField(
      controller: siglaController,
      decoration: const InputDecoration(
        hintText: 'Informe a sigla',
        labelText: 'Sigla',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Sigla';
        }
        if (value.length < 1 || value.length > 7) {
          return 'A Sigla deve entre 1 e 7 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildCotacao() {
    return TextFormField(
      controller: cotacaoController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe a cotação',
        labelText: 'Cotação',
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma cotação';
        }
        return null;
      },
    );
  }

    TextFormField _buildQuantidade() {
    return TextFormField(
      controller: qntController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe a quantidade',
        labelText: 'Quantidade',
        prefixIcon: Icon(Icons.format_list_numbered),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma quantidade';
        }
        return null;
      },
    );
  }

  TextFormField _buildRendimentoAnual() {
    return TextFormField(
      controller: rendimentoController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o rendimento',
        labelText: 'Rendimento',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(rendimentoController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Data
            // Descricao
            // Valor
            final cotacao = NumberFormat.currency(locale: 'pt_BR')
                .parse(cotacaoController.text.replaceAll('R\$', ''));

            final rendimentoAnual = rendimentoController.text;

            final sigla = siglaController.text;

            final quantidade = qntController.text;

            final fii = Fii(
              id: 0,
              cotacao: cotacao.toDouble(),
              qnt: int.parse(quantidade),
              rendimentoAnual: double.parse(rendimentoAnual),
              sigla: sigla,
            );

            if (widget.fiiParaEdicao == null) {
              await _cadastrarFii(fii);
            } else {
              fii.id = widget.fiiParaEdicao!.id;
              await _alterarFii(fii);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> _cadastrarFii(Fii fii) async {
    final scaffold = ScaffoldMessenger.of(context);
    await fiiRepo.cadastrarFii(fii).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Ações/Fii cadastrado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      print(error);
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar Ações/Fii ',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarFii(Fii fii) async {
    final scaffold = ScaffoldMessenger.of(context);
    await fiiRepo.alterarFii(fii).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Ações/Fii alterado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar Ações/Fii ',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
