import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/providers/favoritecryptodataprovider.dart';
import 'package:provider_cryptopia/providers/portfoilocryptodataprovider.dart';
import 'package:provider_cryptopia/screens/wrapperscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavoriteCryptoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CryptoDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProtfolioCryptoProvider(),
        ),
        StreamProvider<List<CryptoModel>>(
          create: (_) => CryptoDataProvider().getStreamCryptoData(),
          initialData: CryptoDataProvider().list,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cryptopia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WrapperScreen(),
      ),
    );
  }
}
