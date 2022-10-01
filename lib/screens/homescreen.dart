// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/providers/favoritecryptodataprovider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text("Cryptopia"),
          centerTitle: true,
        ),
        body: Consumer<CryptoDataProvider>(
          builder: (_, data, __) {
            if (data.list.isNotEmpty) {
              return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<CryptoDataProvider>(context,
                            listen: false)
                        .getCryptoData();
                    Provider.of<FavoriteCryptoProvider>(context, listen: false)
                        .checkIfValueChange(data.list);
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 5.0),
                          const Text(
                            "Top Gainer's",
                            style: TextStyle(),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 150.0,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.blue),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 5.0),
                                                child: CircleAvatar(
                                                  radius: 35.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.network(data
                                                      .topGainersList[index]
                                                      .image),
                                                ),
                                              ),
                                              Consumer<FavoriteCryptoProvider>(
                                                builder: (_,
                                                    favoriteCryptProvider, __) {
                                                  return IconButton(
                                                    onPressed: () {
                                                      if (favoriteCryptProvider
                                                          .cryptoListContains(data
                                                              .topGainersList[
                                                                  index]
                                                              .symbol)) {
                                                        favoriteCryptProvider
                                                            .removeCrypto(data
                                                                .topGainersList[
                                                                    index]
                                                                .symbol);
                                                      } else {
                                                        favoriteCryptProvider
                                                            .addCrypto(
                                                          data
                                                              .topGainersList[
                                                                  index]
                                                              .name,
                                                          data
                                                              .topGainersList[
                                                                  index]
                                                              .symbol,
                                                          data
                                                              .topGainersList[
                                                                  index]
                                                              .image,
                                                          data
                                                              .topGainersList[
                                                                  index]
                                                              .price,
                                                          data
                                                              .topGainersList[
                                                                  index]
                                                              .priceChangePercentage24h,
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.star,
                                                      size: 30.0,
                                                      color: favoriteCryptProvider
                                                              .cryptoListContains(data
                                                                  .topGainersList[
                                                                      index]
                                                                  .symbol)
                                                          ? Colors.amber
                                                          : Colors.grey,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text.rich(
                                              TextSpan(
                                                text: data
                                                    .topGainersList[index].name,
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' (${data.topGainersList[index].symbol.toUpperCase()})',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Consumer<List<CryptoModel>>(
                                            builder: (_, streamData, __) {
                                              var priceData = [];
                                              var priceChangePercentageData =
                                                  [];
                                              for (var i = 0;
                                                  i <
                                                      data.topGainersList
                                                          .length;
                                                  i++) {
                                                for (var j = 0;
                                                    j < streamData.length;
                                                    j++) {
                                                  if (data.topGainersList[i]
                                                          .symbol ==
                                                      streamData[j].symbol) {
                                                    priceData.add(
                                                        streamData[j].price);
                                                    priceChangePercentageData
                                                        .add(streamData[j]
                                                            .priceChangePercentage24h);
                                                  }
                                                }
                                              }
                                              if (streamData.isNotEmpty) {
                                                return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            '\$ ${priceData[index].toString()}'),
                                                        Icon(
                                                          priceChangePercentageData[
                                                                              index]
                                                                          .toString()[
                                                                      0] ==
                                                                  '-'
                                                              ? Icons
                                                                  .arrow_drop_down_rounded
                                                              : Icons
                                                                  .arrow_drop_up_rounded,
                                                          color: priceChangePercentageData[
                                                                          index]
                                                                      .toString()[0] ==
                                                                  '-'
                                                              ? Colors.red
                                                              : Colors.green,
                                                        ),
                                                        Text(
                                                          '${priceChangePercentageData[index].toString().substring(0, 5)}%',
                                                        )
                                                      ],
                                                    ));
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        '\$ ${data.topGainersList[index].price.toString()}'),
                                                    Icon(
                                                      data.topGainersList[index]
                                                                      .priceChangePercentage24h
                                                                      .toString()[
                                                                  0] ==
                                                              '-'
                                                          ? Icons
                                                              .arrow_drop_down_rounded
                                                          : Icons
                                                              .arrow_drop_up_rounded,
                                                      color: data
                                                                  .topGainersList[
                                                                      index]
                                                                  .priceChangePercentage24h
                                                                  .toString()[0] ==
                                                              '-'
                                                          ? Colors.red
                                                          : Colors.green,
                                                    ),
                                                    Text(
                                                      '${data.topGainersList[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            "Top Loser's",
                            style: TextStyle(),
                          ),
                          const SizedBox(height: 5.0),
                          SizedBox(
                            height: 150.0,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.blue),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 5.0),
                                                child: CircleAvatar(
                                                  radius: 35.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.network(data
                                                      .topLosersList[index]
                                                      .image),
                                                ),
                                              ),
                                              Consumer<FavoriteCryptoProvider>(
                                                builder: (_,
                                                    favoriteCryptProvider, __) {
                                                  return IconButton(
                                                    onPressed: () {
                                                      if (favoriteCryptProvider
                                                          .cryptoListContains(
                                                              data
                                                                  .topLosersList[
                                                                      index]
                                                                  .symbol)) {
                                                        favoriteCryptProvider
                                                            .removeCrypto(data
                                                                .topLosersList[
                                                                    index]
                                                                .symbol);
                                                      } else {
                                                        favoriteCryptProvider
                                                            .addCrypto(
                                                          data
                                                              .topLosersList[
                                                                  index]
                                                              .name,
                                                          data
                                                              .topLosersList[
                                                                  index]
                                                              .symbol,
                                                          data
                                                              .topLosersList[
                                                                  index]
                                                              .image,
                                                          data
                                                              .topLosersList[
                                                                  index]
                                                              .price,
                                                          data
                                                              .topLosersList[
                                                                  index]
                                                              .priceChangePercentage24h,
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.star,
                                                      size: 30.0,
                                                      color: favoriteCryptProvider
                                                              .cryptoListContains(data
                                                                  .topLosersList[
                                                                      index]
                                                                  .symbol)
                                                          ? Colors.amber
                                                          : Colors.grey,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text.rich(
                                              TextSpan(
                                                text: data
                                                    .topLosersList[index].name,
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        ' (${data.topLosersList[index].symbol.toUpperCase()})',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Consumer<List<CryptoModel>>(
                                            builder: (_, streamData, __) {
                                              var priceData = [];
                                              var priceChangePercentageData =
                                                  [];
                                              for (var i = 0;
                                                  i < data.topLosersList.length;
                                                  i++) {
                                                for (var j = 0;
                                                    j < streamData.length;
                                                    j++) {
                                                  if (data.topLosersList[i]
                                                          .symbol ==
                                                      streamData[j].symbol) {
                                                    priceData.add(
                                                        streamData[j].price);
                                                    priceChangePercentageData
                                                        .add(streamData[j]
                                                            .priceChangePercentage24h);
                                                  }
                                                }
                                              }
                                              if (streamData.isNotEmpty) {
                                                return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            '\$ ${priceData[index].toString()}'),
                                                        Icon(
                                                          priceChangePercentageData[
                                                                              index]
                                                                          .toString()[
                                                                      0] ==
                                                                  '-'
                                                              ? Icons
                                                                  .arrow_drop_down_rounded
                                                              : Icons
                                                                  .arrow_drop_up_rounded,
                                                          color: priceChangePercentageData[
                                                                          index]
                                                                      .toString()[0] ==
                                                                  '-'
                                                              ? Colors.red
                                                              : Colors.green,
                                                        ),
                                                        Text(
                                                          '${priceChangePercentageData[index].toString().substring(0, 5)}%',
                                                        )
                                                      ],
                                                    ));
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                        '\$ ${data.topLosersList[index].price.toString()}'),
                                                    Icon(
                                                      data.topLosersList[index]
                                                                      .priceChangePercentage24h
                                                                      .toString()[
                                                                  0] ==
                                                              '-'
                                                          ? Icons
                                                              .arrow_drop_down_rounded
                                                          : Icons
                                                              .arrow_drop_up_rounded,
                                                      color: data
                                                                  .topLosersList[
                                                                      index]
                                                                  .priceChangePercentage24h
                                                                  .toString()[0] ==
                                                              '-'
                                                          ? Colors.red
                                                          : Colors.green,
                                                    ),
                                                    Text(
                                                      '${data.topLosersList[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            "Top 100",
                            style: TextStyle(),
                          ),
                          const SizedBox(height: 5.0),
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 100,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0.0,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child:
                                        Image.network(data.list[index].image),
                                  ),
                                  title: Text.rich(
                                    TextSpan(
                                      text: data.list[index].name,
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text:
                                              ' (${data.list[index].symbol.toUpperCase()})',
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
                                                ? Icons.arrow_drop_down_rounded
                                                : Icons.arrow_drop_up_rounded,
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
                                            '\$ ${data.list[index].price.toString()}'),
                                        Icon(
                                          data.list[index]
                                                      .priceChangePercentage24h
                                                      .toString()[0] ==
                                                  '-'
                                              ? Icons.arrow_drop_down_rounded
                                              : Icons.arrow_drop_up_rounded,
                                          color: data.list[index]
                                                      .priceChangePercentage24h
                                                      .toString()[0] ==
                                                  '-'
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        Text(
                                          '${data.list[index].priceChangePercentage24h.toString().substring(0, 5)}%',
                                        )
                                      ],
                                    );
                                  }),
                                  trailing: Consumer<FavoriteCryptoProvider>(
                                      builder: (_, favoriteCryptProvider, __) {
                                    return IconButton(
                                      onPressed: () {
                                        if (favoriteCryptProvider
                                            .cryptoListContains(
                                                data.list[index].symbol)) {
                                          favoriteCryptProvider.removeCrypto(
                                              data.list[index].symbol);
                                        } else {
                                          favoriteCryptProvider.addCrypto(
                                            data.list[index].name,
                                            data.list[index].symbol,
                                            data.list[index].image,
                                            data.list[index].price,
                                            data.list[index]
                                                .priceChangePercentage24h,
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.star,
                                        color: favoriteCryptProvider
                                                .cryptoListContains(
                                                    data.list[index].symbol)
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
