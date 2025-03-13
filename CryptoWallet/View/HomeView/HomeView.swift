import SwiftUI

struct HomeView: View {
  @ObservedObject var appState: AppState
  //Coin model
  
  var body: some View {
    TabView {
      NavigationStack {
        WalletView()
      }
      .tabItem {
        Label("Wallet", systemImage: "wallet.bifold")
      }
      
      NavigationStack {
        MarketView()
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
