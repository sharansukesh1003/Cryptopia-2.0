import 'package:flutter/material.dart';
import 'package:provider_cryptopia/models/cryptomodel.dart';

class AddCryptoScreen extends StatelessWidget {
  const AddCryptoScreen({Key? key, required this.crypto}) : super(key: key);
  final CryptoModel crypto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(crypto.image),
          ),
          title: Text.rich(
            TextSpan(
              text: crypto.name,
              children: <InlineSpan>[
                TextSpan(
                  text: ' (${crypto.symbol.toUpperCase()})',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
