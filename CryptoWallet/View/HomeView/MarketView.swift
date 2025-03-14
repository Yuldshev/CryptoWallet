import SwiftUI

struct MarketView: View {
  @EnvironmentObject private var vm: CoinViewModel
  
  var body: some View {
    ZStack {
      Image(.bg)
        .resizable()
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)
        .opacity(0.7)
        .offset(x: -90, y: -280)
      
      VStack {
        CoinStatView
        
        SortView(isShowHolding: false)
          .environmentObject(vm)
          .padding(.top, 20)
        
        
        List(vm.allCoins) { coin in
          NavigationLink { LazyView(CoinDetailView(coin: coin)) } label: {
            CoinRowView(coin: coin, showHoldingsColumn: false)
          }
        }
        .scrollContentBackground(.hidden)
        .refreshable {
          vm.reloadData()
        }
      }
      .navigationTitle("Live prices")
      .searchable(text: $vm.searchText, prompt: "Search")
      .keyboardType(.webSearch)
    }
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
  
  private var CoinStatView: some View {
    HStack {
      ForEach(vm.stat) { stat in
        StatView(stat: stat)
          .frame(width: UIScreen.main.bounds.width / 3)
      }
    }
  }
}

#Preview {
  NavigationStack {
    MarketView()
      .environmentObject(CoinViewModel())
  }
}
