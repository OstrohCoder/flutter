enum TransactionType { deposit, withdrawal }

class Transaction {
  final TransactionType type;
  final double amount;
  final DateTime date;

  Transaction({required this.type, required this.amount})
    : date = DateTime.now();

  @override
  String toString() {
    final label = type == TransactionType.deposit ? 'DEPOSIT' : 'WITHDRAWAL';
    return '[$label] ${amount.toStringAsFixed(1)} грн - ${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} ${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
}

class InsufficientFundsException implements Exception {
  final String message;

  InsufficientFundsException(this.message);

  @override
  String toString() => 'InsufficientFundsException: $message';
}

class BankAccount {
  final String accountNumber;
  final String ownerName;
  double _balance;
  List<Transaction> _transactions;

  BankAccount({
    required this.accountNumber,
    required this.ownerName,
    double initialBalance = 0.0,
  }) : _balance = initialBalance,
       _transactions = [];

  double get balance => _balance;

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    _balance += amount;
    final transaction = Transaction(
      type: TransactionType.deposit,
      amount: amount,
    );
    _transactions.add(transaction);
    print('✅ Додано $amount грн. Баланс: $_balance грн');
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    if (amount > _balance) {
      throw InsufficientFundsException(
        'Недостатньо коштів. Баланс: $_balance, запит: $amount',
      );
    }
    _balance -= amount;
    final transaction = Transaction(
      type: TransactionType.withdrawal,
      amount: amount,
    );
    _transactions.add(transaction);
    print('✅ Знято $amount грн. Баланс: $_balance грн');
  }

  double getBalance() => _balance;
}

List<Transaction> filterByAmount({
  required List<Transaction> transactions,
  required double minAmount,
}) {
  return transactions
      .where((transaction) => transaction.amount > minAmount)
      .toList();
}

List<Transaction> filterByType({
  required List<Transaction> transactions,
  required TransactionType type,
}) {
  return transactions.where((transaction) => transaction.type == type).toList();
}

double calculateTotalByType({
  required List<Transaction> transactions,
  required TransactionType type,
}) {
  return transactions
      .where((t) => t.type == type)
      .fold<double>(0.0, (sum, t) => sum + t.amount);
}

void printStatistics(BankAccount account) {
  final accountTransactions = account.transactions;

  print('\n=== Історія транзакцій ===');
  for (var i = 0; i < accountTransactions.length; i++) {
    print('${i + 1}. ${accountTransactions[i]}');
  }

  print('\n=== Аналіз ===');

  print(
    'Великі транзакції (>1000 грн): ${filterByAmount(transactions: accountTransactions, minAmount: 1000).length} грн',
  );

  print(
    'Загальна сума депозитів: ${calculateTotalByType(transactions: accountTransactions, type: TransactionType.deposit)} грн',
  );

  print(
    'Загальна сума зняттів: ${calculateTotalByType(transactions: accountTransactions, type: TransactionType.withdrawal)} грн',
  );
}

Future<double> checkBalanceFromServer({required String accountNumber}) async {
  print('⏳ Запит до банківського серверу...');
  await Future.delayed(Duration(seconds: 2));
  return 5500.0;
}

Future<void> verifyBalance({required BankAccount account}) async {
  print('\nПеревірка балансу через API...');

  try {
    final serverBalance = await checkBalanceFromServer(
      accountNumber: account.accountNumber,
    );
    final localBalance = account.balance;

    if (serverBalance == localBalance) {
      print('✅ Баланс з сервера: $serverBalance грн');
    } else {
      print(
        '⚠️ Розбіжність! Баланс з сервера: $serverBalance грн, локальний баланс: $localBalance грн',
      );
    }
  } catch (e) {
    print('❌ Помилка при перевірці балансу: $e');
  }
}

// Бонусна функція
({double totalDeposits, double totalWithdrawals, int count}) getStatistics({
  required BankAccount account,
}) {
  final accountTransactions = account.transactions;

  double totalDeposits = calculateTotalByType(
    transactions: accountTransactions,
    type: TransactionType.deposit,
  );
  double totalWithdrawals = calculateTotalByType(
    transactions: accountTransactions,
    type: TransactionType.withdrawal,
  );
  int count = accountTransactions.length;

  return (
    totalDeposits: totalDeposits,
    totalWithdrawals: totalWithdrawals,
    count: count,
  );
}

void main() async {
  print('=== Bank Account Manager ===\n');

  print('Створення рахунку...');
  var account = BankAccount(
    accountNumber: 'UA1234567890',
    ownerName: 'Олександр Коваленко',
    initialBalance: 0.0,
  );
  print(
    '✅ Рахунок створено: ${account.accountNumber} (${account.ownerName})\n',
  );

  print('Внесення коштів...');
  account.deposit(5000);
  print('');

  print('Зняття коштів...');
  account.withdraw(1500);
  print('');

  print('Внесення коштів...');
  account.deposit(2000);
  print('');

  print('Спроба зняти більше, ніж є...');
  try {
    account.withdraw(10000);
  } catch (e) {
    if (e is InsufficientFundsException) {
      print('❌ Помилка: ${e.message}');
    }
  }

  printStatistics(account);

  await verifyBalance(account: account);
}
