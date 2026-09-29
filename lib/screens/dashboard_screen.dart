import 'package:flutter/material.dart';
import 'package:vitis/models/dashboard_models.dart';
import 'package:vitis/widgets/balance_card.dart';
import 'package:vitis/widgets/category_spending_card.dart';
import 'package:vitis/widgets/saving_goal_card.dart';
import 'package:vitis/widgets/see_all_textbutton.dart';
import 'package:vitis/widgets/transaction_tile.dart';
import 'package:vitis/widgets/wallet_mini_chip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({this.userName = 'María', super.key});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const meses = [
      'ENERO',
      'FEBRERO',
      'MARZO',
      'ABRIL',
      'MAYO',
      'JUNIO',
      'JULIO',
      'AGOSTO',
      'SEPTIEMBRE',
      'OCTUBRE',
      'NOVIEMBRE',
      'DICIEMBRE',
    ];
    final monthLabel = meses[now.month - 1];
    final accounts = MockDashboardData.accountBalances;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: SafeArea(
        child: ListView(
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hola, $userName 👋',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BalanceCard(
              availableBalance: MockDashboardData.availableBalance,
              reservedInSavings: MockDashboardData.reservedInSavings,
              syncedBanks: accounts.length,
              monthGrowthPercent: MockDashboardData.monthGrowthPercent,
            ),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Mis Ahorros', route: "/savings"),
            const SizedBox(height: 10),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MockDashboardData.savingGoals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) =>
                    SavingGoalCard(goal: MockDashboardData.savingGoals[i]),
              ),
            ),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Mis cuentas', route: "/wallets"),
            const SizedBox(height: 10),
            SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: accounts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final entry = accounts.entries.elementAt(i);
                  return WalletMiniChip(
                    bankKey: entry.key,
                    balance: entry.value,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            CategorySpendingCard(
              categories: MockDashboardData.categorySpending,
            ),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Movimientos Recientes', route: "/movements"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).highlightColor),
              ),
              child: Column(
                children: MockDashboardData.recentTransactions
                    .map((t) => TransactionTile(transaction: t))
                    .toList(),
              ),
            ),
          ],
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
