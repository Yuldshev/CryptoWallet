import SwiftUI

struct WalletView: View {
  @StateObject private var user = RegistrationViewModel()
  @EnvironmentObject private var vm: CoinViewModel
  @State private var addCoin = false
  
  var body: some View {
    ZStack {
      ImageBG()
      
      VStack {
        Header
          .padding(24)
        CoinStatus
          .padding(.top, 40)
        SortView(isShowHolding: true)
          .environmentObject(vm)
          .padding(.top, 45)
        
        List(vm.walletCoins) { coin in
          NavigationLink { LazyView(CoinDetailView(coin: coin)) } label: {
            CoinRowView(coin: coin, showHoldingsColumn: true)
          }
        }
        .scrollContentBackground(.hidden)
        .refreshable {
          vm.reloadData()
        }
        Spacer()
      }
      .sheet(isPresented: $addCoin) {
        NavigationStack {
          AddCoinView()
            .environmentObject(vm)
        }
      }
    }
  }
  
  private var Header: some View {
    HStack {
      Spacer()
      Text(user.name)
      Spacer()
    }
    .overlay(alignment: .leading) {
      Circle()
        .foregroundStyle(.gray)
        .frame(width: 38, height: 38)
        .overlay {
          Image(systemName: "person")
            .font(.system(size: 16))
            .foregroundStyle(.black)
        }
    }
    .overlay(alignment: .trailing) {
      Button { addCoin.toggle() } label: {
        Text("+ Add Coin")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.blue)
      }
    }
  }
  
  private var CoinStatus: some View {
    VStack(spacing: 4) {
      Text(vm.totalHoldings.asCurrencyDecimals2())
        .font(.system(size: 48, weight: .bold))
        .foregroundStyle(LinearGradient.appG2)
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
}

#Preview {
  WalletView()
    .environmentObject(CoinViewModel())
}
