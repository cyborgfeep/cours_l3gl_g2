import 'package:cours_l3gl_g2/models/options.dart';
import 'package:cours_l3gl_g2/models/transaction.dart';
import 'package:cours_l3gl_g2/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isVisible = true;
  List<Options> optionList = [
    Options(
        icon: Icons.person, text: "Transfert", color: const Color(0xff4749cd)),
    Options(
        icon: Icons.shopping_cart_outlined,
        text: "Paiements",
        color: Colors.orangeAccent),
    Options(
        icon: Icons.phone_android_rounded, text: "Crédit", color: Colors.blue),
    Options(
        icon: Icons.account_balance_outlined,
        text: "Banque",
        color: Colors.red),
    Options(icon: Icons.card_giftcard, text: "Cadeau", color: Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 90,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
                onPressed: () {
                  print("Settings");
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                )),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                margin: const EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: isVisible ? "100.000" : "•••••••",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: isVisible ? "F" : "",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, left: 8),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(
                            !isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  ],
                ),
              ),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25))),
                          height: 60,
                        ),
                      ),
                      const CardWidget()
                    ],
                  )),
              Container(
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  shrinkWrap: true,
                  itemCount: optionList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return optionWidget(
                        onTap: () {
                          print(optionList[index].text!);
                        },
                        color: optionList[index].color!,
                        text: optionList[index].text!,
                        icon: optionList[index].icon!);
                  },
                ),
              ),
              Divider(
                color: Colors.grey.withOpacity(.2),
                thickness: 3,
                height: 5,
              ),
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: Transaction.transactionList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    Transaction t = Transaction.transactionList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${t.type == TransactionType.transferE ? "De" : t.type == TransactionType.transferS ? "À" : ""} ${t.title}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                              Text(
                                "${t.type == TransactionType.transferS || t.type == TransactionType.withdraw || t.type == TransactionType.operation ? "-" : ""}${t.amount}F",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            Jiffy.parse(t.date.toString())
                                .format(pattern: 'dd MMMM yyyy à HH:mm'),
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget optionWidget(
      {required IconData icon,
      required String text,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
