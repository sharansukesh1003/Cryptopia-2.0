import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/screens/addcryptoscreen.dart';

class SelectCryptoScreen extends StatelessWidget {
  const SelectCryptoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Add Transaction'),
        leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.xmark),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Consumer<CryptoDataProvider>(
        builder: (_, value, __) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: value.list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(_addCryptoRoute(value.list[index]));
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.network(value.list[index].image),
                  ),
                  title: Text.rich(
                    TextSpan(
                      text: value.list[index].name,
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' (${value.list[index].symbol.toUpperCase()})',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 15.0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Route _addCryptoRoute(CryptoModel data) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddCryptoScreen(
        crypto: data,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
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
