import Foundation
import Combine

class CoinDetailService {
  @Published var coinDetails: CoinDetail?
  private var cancellables = Set<AnyCancellable>()
  let coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
    getCoinsDetails()
  }
  
  func getCoinsDetails() {
    guard let url = Endpoint.coinDetailData(coinId: coin.id) else { return }
    
    NetworkManager.download(url: url)
      .decode(type: CoinDetail.self, decoder: JSONDecoder())
      .sink(receiveCompletion:  NetworkManager.handleCompletion, receiveValue: { [weak self] details in
        self?.coinDetails = details
      })
      .store(in: &cancellables)
  }
}
