import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
  @Published var overviewStats: [Stat] = []
  @Published var additionalStats: [Stat] = []
  @Published var coin: Coin
  @Published var coinDescription: String?
  @Published var websiteURL: String?
  @Published var redditURL: String?
  
  private let coinDetailService: CoinDetailService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: Coin) {
    self.coin = coin
    self.coinDetailService = CoinDetailService(coin: coin)
    addSubs()
  }
  
  private func addSubs() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map(mapDataStats)
      .sink { [weak self] array in
        self?.overviewStats = array.overview
        self?.additionalStats = array.additional
      }
      .store(in: &cancellables)
    
    coinDetailService.$coinDetails
      .sink { [weak self] coin in
        self?.coinDescription = coin?.description?.en
        self?.websiteURL = coin?.links?.homepage?.first
        self?.redditURL = coin?.links?.subredditURL
      }
      .store(in: &cancellables)
  }
  
  private func mapDataStats(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Stat], additional: [Stat]) {
    let overviewArray = createOverviewArray(coin: coin)
    let additionalArray = createAdditionalArray(coin: coin, coinDetail: coinDetail)
    return (overviewArray, additionalArray)
  }
  
  private func createOverviewArray(coin: Coin) -> [Stat] {
    let price = coin.currentPrice.asCurrencyDecimals6()
    let pricePercentChange = coin.priceChangePercentage24H
    let priceStat = Stat(title: "Current Price", value: price, percent: pricePercentChange)
    
    let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "n/a")
    let marketCapPercentChange = coin.marketCapChangePercentage24H
    let marketStat = Stat(title: "Market Cap", value: marketCap, percent: marketCapPercentChange)
    
    let rank = coin.rank.description
    let rankStat = Stat(title: "Rank", value: rank)
    
    let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "n/a")
    let volumeStat = Stat(title: "Volume", value: volume)
    
    let overviewArray: [Stat] = [priceStat, marketStat, rankStat, volumeStat]
    return overviewArray
  }
  
  private func createAdditionalArray(coin: Coin, coinDetail: CoinDetail?) -> [Stat] {
    let high = coin.high24H?.asCurrencyDecimals6() ?? "n/a"
    let highStat = Stat(title: "24h High", value: high)
    
    let low = coin.low24H?.asCurrencyDecimals6() ?? "n/a"
    let lowStat = Stat(title: "24h Low", value: low)
    
    let priceChange = coin.priceChange24H?.asCurrencyDecimals6() ?? "n/a"
    let pricePercentChange = coin.priceChangePercentage24H
    let priceChangeStat = Stat(title: "24h Price Change", value: priceChange, percent: pricePercentChange)
    
    let marketChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "n/a")
    let marketCapPercentChange = coin.marketCapChangePercentage24H
    let marketCapChangeStat = Stat(title: "24h Market Change", value: marketChange, percent: marketCapPercentChange)
    
    let blockTimeString = coinDetail?.blockTimeInMinutes.map { "\($0)" } ?? "n/a"
    let blockTimeStat = Stat(title: "Block Time", value: blockTimeString)
    
    let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
    let hashingStat = Stat(title: "Hashing Algorithm", value: hashing)
    
    let additionalArray: [Stat] = [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat]
    return additionalArray
  }
}
