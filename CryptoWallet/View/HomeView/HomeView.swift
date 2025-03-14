import SwiftUI

struct HomeView: View {
  @ObservedObject var appState: AppState
  @StateObject private var vm = CoinViewModel()
  //Coin model
  
  var body: some View {
    TabView {
      NavigationStack {
        WalletView()
          .environmentObject(vm)
      }
      .tabItem {
        Label("Wallet", systemImage: "wallet.bifold")
      }
      
      NavigationStack {
        MarketView()
          .environmentObject(vm)
      }
      .tabItem {
        Label("Market", systemImage: "tray")
      }
      
      ProfileView(appState: appState)
      .tabItem {
        Label("Profile", systemImage: "person")
      }
    }
    .tint(.blue)
  }
}

#Preview {
  HomeView(appState: AppState())
}
