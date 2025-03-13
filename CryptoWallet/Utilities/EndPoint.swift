import Foundation

struct Endpoint {
  static let baseURL = "https://api.coingecko.com/api/v3"
  
  enum Path: String {
    case coinMarketData = "/coins/markets"
    case coinDetail = "/coins"
    case globalMarketData = "/global"
  }
  
  // MARK: - Coin Market Data
  static func coinMarketData(
    vsCurrency: String = "usd",
    order: String = "market_cap_desc",
    perPage: Int = 50,
    page: Int = 1,
    sparkline: Bool = true,
    priceChangePercentage: String = "24h"
  ) -> URL? {
    let urlString = "\(baseURL)\(Path.coinMarketData.rawValue)?vs_currency=\(vsCurrency)&order=\(order)&per_page=\(perPage)&page=\(page)&sparkline=\(sparkline)&price_change_percentage=\(priceChangePercentage)"
    return URL(string: urlString)
  }
  
  // MARK: - Coin Detail Data
  static func coinDetailData(
    coinId: String,
    localization: Bool = false,
    tickers: Bool = false,
    marketData: Bool = false,
    communityData: Bool = false,
    developerData: Bool = false,
    sparkline: Bool = false
  ) -> URL? {
    let urlString = "\(baseURL)\(Path.coinDetail.rawValue)/\(coinId)?localization=\(localization)&tickers=\(tickers)&market_data=\(marketData)&community_data=\(communityData)&developer_data=\(developerData)&sparkline=\(sparkline)"
    return URL(string: urlString)
  }
  
  // MARK: - Global Market Data
  static func globalMarketData() -> URL? {
    let urlString = "\(baseURL)\(Path.globalMarketData.rawValue)"
    return URL(string: urlString)
  }
}
