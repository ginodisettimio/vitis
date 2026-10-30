enum WalletStatus {
  pending, // agregada, todavía sin sincronizar con el banco
  connected,
  disconnected, // se conserva para que sus movimientos sigan teniendo origen
}

// Las credenciales no van en este documento: la base no está cifrada.
// Se guardan aparte con CredentialsStore.
class Wallet {
  final String? id; // null hasta que se guarda en la base
  final String userId;
  final String name;
  final String logo;
  final String providerKey; // coincide con AppTheme.bankColors ('mp', 'nx'...)
  final double balance;
  final WalletStatus status;

  const Wallet({
    this.id,
    required this.userId,
    required this.name,
    required this.logo,
    required this.providerKey,
    required this.balance,
    this.status = WalletStatus.pending,
  });

  Wallet copyWith({String? id, WalletStatus? status}) => Wallet(
    id: id ?? this.id,
    userId: userId,
    name: name,
    logo: logo,
    providerKey: providerKey,
    balance: balance,
    status: status ?? this.status,
  );

  Map<String, Object?> toMap() => {
    'userId': userId,
    'name': name,
    'logo': logo,
    'providerKey': providerKey,
    'balance': balance,
    'status': status.name,
  };

  factory Wallet.fromMap(String id, Map<String, Object?> map) => Wallet(
    id: id,
    userId: map['userId'] as String,
    name: map['name'] as String,
    logo: map['logo'] as String,
    providerKey: map['providerKey'] as String,
    balance: (map['balance'] as num).toDouble(),
    status: WalletStatus.values.byName(map['status'] as String),
  );
}

class WalletCredentials {
  final String apiKey;
  final String accessToken;

  const WalletCredentials({required this.apiKey, required this.accessToken});
}
