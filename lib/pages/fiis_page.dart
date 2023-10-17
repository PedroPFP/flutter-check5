import 'package:expense_tracker/components/fii_item.dart';
import 'package:expense_tracker/models/Fii.dart';
import 'package:expense_tracker/pages/fii_cadastro_page.dart';
import 'package:expense_tracker/pages/transacao_cadastro_page.dart';
import 'package:expense_tracker/repository/fii_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FiisPage extends StatefulWidget {
  const FiisPage({super.key});

  @override
  State<FiisPage> createState() => _FiisPageState();
}

class _FiisPageState extends State<FiisPage> {
  late Future<List<Fii>> futureFii;
  final fiiRepo = FiiRepository();

  @override
  void initState() {
    futureFii = fiiRepo.listarFiis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ações/Fii'),
        actions: [
          // create a filter menu action
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Todas'),
                  onTap: () {
                    setState(() {
                      futureFii = fiiRepo.listarFiis();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Receitas'),
                  onTap: () {
                    setState(() {
                      // futureTransacoes = transacoesRepo.listarTransacoes(
                      //     userId: user?.id ?? '',
                      //     tipoTransacao: TipoTransacao.receita);
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Despesas'),
                  onTap: () {
                    setState(() {
                      // futureTransacoes = transacoesRepo.listarTransacoes(
                      //     userId: user?.id ?? '',
                      //     tipoTransacao: TipoTransacao.despesa);
                    });
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Fii>>(
        future: futureFii,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as Ações/Fiis"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma Ações/Fiis cadastrada"),
            );
          } else {
            final fiis = snapshot.data!;
            return ListView.separated(
              itemCount: fiis.length,
              itemBuilder: (context, index) {
                final fii = fiis[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FiiCadastroPage(
                                fiiParaEdicao: fii,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              // futureTransacoes =
                              //     transacoesRepo.listarTransacoes(
                              //   userId: user?.id ?? '',
                              // );
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await fiiRepo.excluirFii(fii.id);

                          setState(() {
                            fiis.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: FiiItem(
                    fii: fii,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FiiCadastroPage(
                                    fiiParaEdicao: fii,
                                  )));

                      setState(() {
                        futureFii = fiiRepo.listarFiis();
                      });
                    },
                  ),
                  // child: TransacaoItem(
                  //   transacao: transacao,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/transacao-detalhes',
                  //         arguments: transacao);
                  //   },
                  // ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fii-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/fii-cadastro') as bool?;

          if (result == true) {
            setState(() {
              futureFii = fiiRepo.listarFiis();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
