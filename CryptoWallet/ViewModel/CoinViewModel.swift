import Foundation
import Combine

class CoinViewModel: ObservableObject {
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []
  @Published var searchText = ""
  @Published var stat: [StatModel] = []
  @Published var isLoading = false
  @Published var sortOption: SortOption = .holdings
  
  private let coinDataService = CoinService()
  private let marketDataService = MarketService()
  private let portfolioDataService = WalletService()
  private var cancellables = Set<AnyCancellable>()
  
  enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
  }
  
  init() {
    addSubs()
  }
  
  func addSubs() {
    $searchText
      .combineLatest(coinDataService.$allCoins, $sortOption)
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .map(filterAndSortCoins)
      .sink { [weak self] coins in
        self?.allCoins = coins
      }
      .store(in: &cancellables)
    
    $allCoins
      .combineLatest(portfolioDataService.$savedEntities)
      .map(mapAllCoins)
      .sink { [weak self] coin in
        guard let self = self else { return }
        self.portfolioCoins = self.sortPortfolioCoins(coin: coin)
      }
      .store(in: &cancellables)
    
    marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map(mapMarketData)
      .sink { [weak self] stats in
        self?.stat = stats
        self?.isLoading = false
      }
      .store(in: &cancellables)
    
    
  }
  
  func updatePortfolio(coin: Coin, amount: Double) {
    portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  func reloadData() {
    isLoading = true
    coinDataService.getCoins()
    marketDataService.getData()
  }
  
  private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
    var updateCoins = filterCoins(text: text, coins: coins)
    sortCoins(sort: sort, coin: &updateCoins)
    return updateCoins
  }
  
  private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
    guard !text.isEmpty else { return coins }
    let lowercasedText = text.lowercased()
    return coins.filter { coin -> Bool in
      return coin.name.lowercased().contains(lowercasedText) ||
              coin.symbol.lowercased().contains(lowercasedText) ||
              coin.id.lowercased().contains(lowercasedText)
    }
  }
  
  private func sortCoins(sort: SortOption, coin: inout [Coin]) {
    switch sort {
      case .rank, .holdings:
        coin.sort { $0.rank < $1.rank }
      case .rankReversed, .holdingsReversed:
        coin.sort { $0.rank > $1.rank }
      case .price:
        coin.sort { $0.currentPrice > $1.currentPrice }
      case .priceReversed:
        coin.sort { $0.currentPrice < $1.currentPrice }
    }
  }
  
  private func sortPortfolioCoins(coin: [Coin]) -> [Coin] {
    switch sortOption {
      case .holdings:
        return coin.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
      case .holdingsReversed:
        return coin.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
      default: return coin
    }
  }
  
  private func mapAllCoins(coinModels: [Coin], entity: [Wallet]) -> [Coin] {
    coinModels.compactMap { coin -> Coin? in
      guard let entity = entity.first(where: { $0.coinID == coin.id }) else {
        return coin
      }
      return coin.updateHoldings(amount: entity.amount)
    }
  }
  
  private func mapMarketData(market: MarketData?, WalletCoins: [Coin]) -> [StatModel] {
    var stats: [StatModel] = []
    
    guard let data = market else { return stats }
    
    let marketCap = StatModel(title: "Market Cap", value: data.marketCap, percent: data.marketCapChangePercentage24HUsd)
    let volume = StatModel(title: "24h volume", value: data.volume)
    let btcDominance = StatModel(title: "BTC Dominance", value: data.btcDominance)
    
    let walletValue = WalletCoins
      .map{ $0.currentHoldingsValue}
      .reduce(0, +)
    let previousValue = portfolioCoins
      .map{ coin -> Double in
        let currentValue = coin.currentHoldingsValue
        let percentChange = coin.priceChangePercentage24H ?? 0 / 100
        let previousValue = currentValue / (1 + percentChange)
        return previousValue
      }
      .reduce(0, +)
    let percentageChange = ((walletValue - previousValue) / previousValue) * 100
    
    let wallet = StatModel(title: "Wallet Value", value: walletValue.asCurrencyDecimals2(), percent: percentageChange)
    
    stats.append(contentsOf: [marketCap, volume, btcDominance, wallet])
    return stats
  }
}
