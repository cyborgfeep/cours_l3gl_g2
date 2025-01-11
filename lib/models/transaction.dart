class Transaction {
  String? title;
  int? amount;
  DateTime? date;
  TransactionType? type;

  Transaction({this.title, this.amount, this.date, this.type});

  static List<Transaction> transactionList = [
    Transaction(
        title: "Dépot",
        amount: 50000,
        date: DateTime.now(),
        type: TransactionType.deposit),
    Transaction(
        title: "Modou Fall 77 777 77 77",
        amount: 10000,
        date: DateTime.now(),
        type: TransactionType.transferE),
    Transaction(
        title: "Mbaye Pekh 77 777 77 77",
        amount: 50000,
        date: DateTime.now(),
        type: TransactionType.transferS),
    Transaction(
        title: "Paiment Canal+",
        amount: 10000,
        date: DateTime.now(),
        type: TransactionType.operation),
    Transaction(
        title: "Retrait",
        amount: 10000,
        date: DateTime.now(),
        type: TransactionType.withdraw)
  ];
}

enum TransactionType {
  withdraw,
  transferE,
  transferS,
  operation,
  deposit,
}
