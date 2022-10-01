// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider_cryptopia/providers/portfoilocryptodataprovider.dart';
import 'package:provider_cryptopia/screens/homescreen.dart';
import 'package:provider_cryptopia/providers/cryptodataprovider.dart';
import 'package:provider_cryptopia/screens/favoritecryptoscreen.dart';
import 'package:provider_cryptopia/screens/newsscreen.dart';
import 'package:provider_cryptopia/screens/portfolioscreen.dart';
import 'package:provider_cryptopia/screens/settingsscreen.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

int _pageIndex = 1;

List<BottomNavigationBarItem> options = [
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.chartColumn), label: 'Search'),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.chartPie), label: 'Portfolio'),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house), label: 'Home'),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.solidNewspaper), label: 'News'),
  const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.gear), label: 'Search'),
];

List<Widget> tabPages = [
  const FavoriteScreen(),
  const PortfolioScreen(),
  const HomeScreen(),
  const NewsScreen(),
  const SettingsScreen()
];

class _WrapperScreenState extends State<WrapperScreen> {
  bool _isInit = true;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<CryptoDataProvider>(context, listen: false)
          .getCryptoData();
      Provider.of<CryptoDataProvider>(context, listen: false)
          .getStreamCryptoData();
      Provider.of<CryptoDataProvider>(context, listen: false).getTopGainers();
      Provider.of<CryptoDataProvider>(context, listen: false).getTopLosers();
      Provider.of<ProtfolioCryptoProvider>(context, listen: false)
          .updateIsLoaded();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Colors.grey[700],
        fixedColor: Colors.white,
        currentIndex: _pageIndex,
        onTap: onPageChanged,
        backgroundColor: Colors.blue,
        items: options,
      ),
      body: tabPages.elementAt(_pageIndex),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }
}
