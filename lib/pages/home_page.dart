import 'dart:async';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:expense_tracker/pages/categorias_page.dart';
import 'package:expense_tracker/pages/contas_page.dart';
import 'package:expense_tracker/pages/dashboard_page.dart';
import 'package:expense_tracker/pages/fiis_page.dart';
import 'package:expense_tracker/pages/transacoes_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<AuthState>? authSubscription;
  int pageIndex = 0;

  @override
  void initState() {
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        DashBoardPage(),
        TransacoesPage(),
        ContasPage(),
        CategoriasPage(),
        FiisPage()
      ],
    );
  }

  Widget getFooter() {
    List<BottomNavyBarItem> items = [
      BottomNavyBarItem(
        icon: Icon(Ionicons.bar_chart_outline),
        title: Text('Dashboard'),
      ),
      BottomNavyBarItem(
        icon: Icon(Ionicons.swap_horizontal_outline),
        title: Text('Transações'),
      ),
      BottomNavyBarItem(
          icon: Icon(Ionicons.wallet_outline), title: Text('Contas')),
      BottomNavyBarItem(
          icon: Icon(Ionicons.list_outline), title: Text('Categorias')),
      BottomNavyBarItem(
          icon: Icon(Ionicons.bar_chart), title: Text('Ações/Fiis')),
    ];

    return BottomNavyBar(
      items: items,
        selectedIndex: pageIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
      onItemSelected: (index) {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }
}
