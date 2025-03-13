import SwiftUI
import Combine

class CoinImageService {
  @Published var image: UIImage?
  private var cancellables = Set<AnyCancellable>()
  private let coin: Coin
  private let fileManager = LocalFileManager.instance
  private let folderName = "coin_images"
  private let imageName: String
  
  init(coin: Coin) {
    self.coin = coin
    self.imageName = coin.id
    getCoinImage()
  }
  
  private func getCoinImage() {
    if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
      image = savedImage
    } else {
      downloadCoinImage()
    }
  }
  
  private func downloadCoinImage() {
    guard let url = URL(string: coin.image) else { return }
    
    NetworkManager.download(url: url)
      .tryMap { data in
        return UIImage(data: data)
      }
      .sink(receiveCompletion:  NetworkManager.handleCompletion, receiveValue: { [weak self] image in
        guard let self = self, let dowloadImage = image else { return }
        self.image = dowloadImage
        self.fileManager.saveImage(image: dowloadImage, imageName: self.imageName, folderName: self.folderName)
      })
      .store(in: &cancellables)
  }
}
