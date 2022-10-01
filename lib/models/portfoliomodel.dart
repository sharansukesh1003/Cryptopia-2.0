class PortfolioModel {
  String name, symbol, image;
  num buyPrice, currentPrice, priceChangePercentage24h;
  PortfolioModel({
    required this.name,
    required this.symbol,
    required this.image,
    required this.buyPrice,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });
}
