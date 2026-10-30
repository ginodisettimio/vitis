import 'package:vitis/data/mock/mock_data.dart';
import 'package:vitis/data/repositories/movement_repository.dart';
import 'package:vitis/data/repositories/saving_repository.dart';
import 'package:vitis/data/repositories/user_repository.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';

// Único lugar donde se elige la implementación: para pasar a la base real
// alcanza con cambiar estas instancias.
final UserRepository userRepository = MockUserRepository();
final WalletRepository walletRepository = MockWalletRepository(demoWallets());
final SavingRepository savingRepository = MockSavingRepository(demoSavings());
final MovementRepository movementRepository = MockMovementRepository(
  cash: demoCash(),
  transfers: demoTransfers(),
);
