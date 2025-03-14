import Foundation
import Combine

class CoinService {
  @Published var allCoins: [Coin] = []
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    getCoins()
  }
  
  func getCoins(completion: ((Subscribers.Completion<Error>) -> Void)? = nil) {
    guard let url = Endpoint.coinMarketData() else { return }
    
    NetworkManager.download(url: url)
      .decode(type: [Coin].self, decoder: JSONDecoder())
      .sink(receiveCompletion: { result in
        if let completion = completion {
          completion(result)
        }
        NetworkManager.handleCompletion(completion: result)
      }, receiveValue: { [weak self] coins in
        self?.allCoins = coins
      })
      .store(in: &cancellables)
  }
}
