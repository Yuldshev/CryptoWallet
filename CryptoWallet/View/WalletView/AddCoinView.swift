import SwiftUI

struct AddCoinView: View {
  @EnvironmentObject private var vm: CoinViewModel
  
  var body: some View {
    VStack {
      List(vm.allCoins) { coin in
        NavigationLink { LazyView(AmountCoin(coin: coin)).environmentObject(vm) } label: {
          CoinRowView(coin: coin, showHoldingsColumn: false)
        }
      }
      .padding(.top, 10)
    }
    .navigationTitle("Add Coin")
    .searchable(text: $vm.searchText, prompt: "Search")
    .keyboardType(.webSearch)
  }
  
  private struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
      self.build = build
    }
    
    var body: Content {
      build()
    }
  }
}

#Preview {
  NavigationStack {
    AddCoinView()
      .environmentObject(CoinViewModel())
  }
}
