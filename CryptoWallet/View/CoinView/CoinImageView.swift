import SwiftUI

struct CoinImageView: View {
  //MARK: - Properties
  @StateObject var vm: CoinImageViewModel
  
  init(coin: Coin) {
    _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
  }
  
  //MARK: - Body
  var body: some View {
    ZStack {
      if let image = vm.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
      } else if vm.isLoading {
        ProgressView()
      } else {
        Image(systemName: "questionmark")
          .font(.headline)
          .foregroundStyle(.secondary)
      }
    }
  }
}

#Preview {
  CoinImageView(coin: AppPreview.instance.coin)
}
