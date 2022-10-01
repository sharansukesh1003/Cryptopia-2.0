import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/providers/favoritecryptodataprovider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text("Favorite's"),
        ),
        body:
            Consumer<FavoriteCryptoProvider>(builder: (_, favoriteCrypto, __) {
          if (favoriteCrypto.cryptoList.isEmpty) {
            return const Center(child: Text("Add your Favorite crypto."));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                Provider.of<FavoriteCryptoProvider>(context, listen: false)
                    .checkIfValueChange(await Provider.of<CryptoDataProvider>(
                            context,
                            listen: false)
                        .getFavoriteCryptoData());
              },
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: favoriteCrypto.cryptoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                              favoriteCrypto.cryptoList[index].image),
                        ),
                        title: Text.rich(
                          TextSpan(
                            text: favoriteCrypto.cryptoList[index].name,
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    ' (${favoriteCrypto.cryptoList[index].symbol.toUpperCase()})',
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
                          var priceData = [];
                          var priceChangePercentageData = [];
                          if (streamData.isNotEmpty) {
                            for (var i = 0;
                                i < favoriteCrypto.cryptoList.length;
                                i++) {
                              for (var j = 0; j < streamData.length; j++) {
                                if (favoriteCrypto.cryptoList[i].symbol ==
                                    streamData[j].symbol) {
                                  priceData.add(streamData[j].price);
                                  priceChangePercentageData.add(
                                      streamData[j].priceChangePercentage24h);
                                }
                              }
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('\$ ${priceData[index].toString()}'),
                                Icon(
                                  priceChangePercentageData[index]
                                              .toString()[0] ==
                                          '-'
                                      ? Icons.arrow_drop_down_rounded
                                      : Icons.arrow_drop_up_rounded,
                                  color: priceChangePercentageData[index]
                                              .toString()[0] ==
                                          '-'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                Text(
                                  '${priceChangePercentageData[index].toString().substring(0, 5)}%',
                                )
                              ],
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '\$ ${favoriteCrypto.cryptoList[index].price.toString()}'),
                              Icon(
                                favoriteCrypto.cryptoList[index]
                                            .priceChangePercentage24h
                                            .toString()[0] ==
                                        '-'
                                    ? Icons.arrow_drop_down_rounded
                                    : Icons.arrow_drop_up_rounded,
                                color: favoriteCrypto.cryptoList[index]
                                            .priceChangePercentage24h
                                            .toString()[0] ==
                                        '-'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              Text(
                                '${favoriteCrypto.cryptoList[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                              )
                            ],
                          );
                        }),
                        trailing: IconButton(
                          onPressed: () {
                            favoriteCrypto.removeCrypto(
                                favoriteCrypto.cryptoList[index].symbol);
                          },
                          icon: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
        }),
      ),
    );
  }
}
