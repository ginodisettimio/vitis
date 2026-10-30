import 'package:flutter/material.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/data/states/wallets_store.dart';
import 'package:vitis/ui/screens/shell/main_shell_screen.dart';
import 'package:vitis/utils/date_formatter.dart';
import 'package:vitis/ui/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:vitis/ui/widgets/dashboard/balance_card.dart';
import 'package:vitis/ui/widgets/dashboard/category_spending_card.dart';
import 'package:vitis/ui/widgets/savings/saving_goal_card.dart';
import 'package:vitis/ui/widgets/feedback/empty_message.dart';
import 'package:vitis/ui/widgets/navigation/see_all_text_button.dart';
import 'package:vitis/ui/widgets/dashboard/transaction_tile.dart';
import 'package:vitis/ui/widgets/wallets/wallet_mini_chip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monthLabel = mesActual().toUpperCase();
    final session = SessionStore.instance;
    final walletsStore = WalletsStore.instance;
    final savingsStore = SavingsStore.instance;
    final movementsStore = MovementsStore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: SafeArea(
        // Se redibuja cuando cambia cualquier dato que muestra el resumen.
        child: ListenableBuilder(
          listenable: Listenable.merge([
            session,
            walletsStore,
            savingsStore,
            movementsStore,
          ]),
          builder: (context, _) {
            final wallets = walletsStore.wallets;
            final savings = savingsStore.savings;
            final categories = movementsStore.expensesByCategory;
            final recent = movementsStore.recent;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            monthLabel,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: () => MainShellScreen.irA(
                              context,
                              NavSection.ajustes,
                            ),
                            child: Text(
                              'Hola, ${session.currentUser?.firstName ?? ''} 👋',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BalanceCard(
                  availableBalance: session.availableBalance,
                  reservedInSavings: savingsStore.totalReserved,
                  syncedBanks: walletsStore.connectedCount,
                  monthGrowthPercent: movementsStore.monthGrowthPercent(
                    session.balance,
                  ),
                  onSyncedBanksTap: () =>
                      MainShellScreen.irA(context, NavSection.billeteras),
                ),
                const SizedBox(height: 20),
                _SectionHeader(title: 'Mis Ahorros', route: "/savings"),
                const SizedBox(height: 10),
                if (savings.isEmpty)
                  const EmptyMessage('Todavía no creaste ningún ahorro')
                else
                  SizedBox(
                    height: 128,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: savings.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, i) => SavingGoalCard(
                        saving: savings[i],
                        onTap: () =>
                            MainShellScreen.irA(context, NavSection.ahorro),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _SectionHeader(title: 'Mis Billeteras', route: "/wallets"),
                const SizedBox(height: 10),
                if (wallets.isEmpty)
                  const EmptyMessage('Todavía no agregaste billeteras')
                else
                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: wallets.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, i) => WalletMiniChip(
                        bankKey: wallets[i].providerKey,
                        balance: wallets[i].balance,
                        onTap: () =>
                            MainShellScreen.irA(context, NavSection.billeteras),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (categories.isEmpty)
                  const EmptyMessage('Sin gastos este mes')
                else
                  CategorySpendingCard(categories: categories),
                const SizedBox(height: 20),
                _SectionHeader(
                  title: 'Movimientos Recientes',
                  route: "/movements",
                ),
                const SizedBox(height: 10),
                if (recent.isEmpty)
                  const EmptyMessage('Todavía no hay movimientos')
                else
                  // El recorte evita que el efecto de cada fila pise las esquinas.
                  Material(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      child: Column(
                        children: recent
                            .map(
                              (m) => TransactionTile(
                                movement: m,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/movements'),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String route;

  const _SectionHeader({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        SeeAllTextButton(route: route),
      ],
    );
  }
}
