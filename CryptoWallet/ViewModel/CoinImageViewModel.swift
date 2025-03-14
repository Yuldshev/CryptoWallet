import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
  @Published var image: UIImage?
  @Published var isLoading = false
  
  private let coin: Coin
  private let dataService: CoinImageService
  private var cancellables = Set<AnyCancellable>()
  
  init(coin: Coin) {
    self.coin = coin
    self.dataService = CoinImageService(coin: coin)
    self.addSubs()
    self.isLoading = true
  }
  
  private func addSubs() {
    dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] image in
        self?.image = image
      }
      .store(in: &cancellables)
  }
}
