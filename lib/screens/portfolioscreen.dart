// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/providers/portfoilocryptodataprovider.dart';
import 'package:provider_cryptopia/screens/selectcryptoscreen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  CryptoModel defaultVal = CryptoModel.defaultVal;
  String dropdownValue = 'One';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(_selectCryptoRoute());
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: SafeArea(
        child: Consumer<ProtfolioCryptoProvider>(
          builder: (_, data, __) {
            if (data.isLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<CryptoDataProvider>(context, listen: false)
                      .getCryptoData();
                },
                child: data.portfolio.isEmpty
                    ? CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          appBar(context),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height * 0.3),
                              child: const Text(
                                "Add crypto's to portfolio",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      )
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          appBar(context),
                          const SliverToBoxAdapter(
                            child: Text("Your Currencie's"),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Card(
                                  elevation: 0.0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(
                                          data.portfolio[index].image),
                                    ),
                                    title: Text.rich(
                                      TextSpan(
                                        text: data.portfolio[index].name,
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                ' (${data.portfolio[index].symbol.toUpperCase()})',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Consumer<List<CryptoModel>>(
                                      builder: (_, streamData, __) {
                                        if (streamData.isNotEmpty) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                  '\$ ${streamData[index].price.toString()}'),
                                              Icon(
                                                streamData[index]
                                                            .priceChangePercentage24h
                                                            .toString()[0] ==
                                                        '-'
                                                    ? Icons
                                                        .arrow_drop_down_rounded
                                                    : Icons
                                                        .arrow_drop_up_rounded,
                                                color: streamData[index]
                                                            .priceChangePercentage24h
                                                            .toString()[0] ==
                                                        '-'
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                              Text(
                                                '${streamData[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                                              )
                                            ],
                                          );
                                        }
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                '\$ ${data.portfolio[index].buyPrice.toString()}'),
                                            Icon(
                                              data.portfolio[index]
                                                          .priceChangePercentage24h
                                                          .toString()[0] ==
                                                      '-'
                                                  ? Icons
                                                      .arrow_drop_down_rounded
                                                  : Icons.arrow_drop_up_rounded,
                                              color: data.portfolio[index]
                                                          .priceChangePercentage24h
                                                          .toString()[0] ==
                                                      '-'
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                            Text(
                                              '${data.portfolio[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              childCount: 20,
                            ),
                          ),
                        ],
                      ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      title: const Text('Invested Value'),
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Current Value'),
            Text('23453'),
            Text('Invested Value'),
            Text('213445'),
          ],
        ),
      ),
    );
  }

  Route _selectCryptoRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SelectCryptoScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
