import Foundation
import Combine

class MarketService {
  @Published var marketData: MarketData?
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    getData()
  }
  
  func getData() {
    guard let url = Endpoint.globalMarketData() else { return }
    
    NetworkManager.download(url: url)
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .sink(receiveCompletion:  NetworkManager.handleCompletion, receiveValue: { [weak self] globalData in
        self?.marketData = globalData.data
      })
      .store(in: &cancellables)
  }
}
