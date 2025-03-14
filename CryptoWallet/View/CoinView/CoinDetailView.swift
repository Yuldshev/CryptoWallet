import SwiftUI

struct CoinDetailView: View {
  @StateObject private var vm: CoinDetailViewModel
  @State var showFullDescription = false
  private let column: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  init(coin: Coin) {
    _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
  }
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        ChartView(coin: vm.coin)
        OverviewScreen
        AdditionalScreen
        LinkScreen
      }
      .padding(24)
    }
    .navigationTitle(vm.coin.name)
  }
  
  private var OverviewScreen: some View {
    VStack(alignment: .leading) {
      Text("Overview")
        .font(.system(size: 22, weight: .bold))
      Divider()
      Text(vm.coinDescription ?? "")
        .font(.caption)
        .padding(.top, 6)
        .lineLimit(showFullDescription ? nil : 3)
      Button { showFullDescription.toggle()} label: {
        Text("Read more...")
          .foregroundStyle(.blue)
          .font(.system(size: 12, weight: .semibold))
          .padding(.top, 4)
      }
      LazyVGrid(columns: column, alignment: .leading, spacing: 20) {
        ForEach(vm.overviewStats) { stat in
          StatView(stat: stat)
        }
      }
      .padding(.top, 20)
    }
  }
  
  private var AdditionalScreen: some View {
    VStack(alignment: .leading) {
      Text("Additional Details")
        .font(.system(size: 22, weight: .bold))
      Divider()
      LazyVGrid(columns: column, alignment: .leading, spacing: 20) {
        ForEach(vm.additionalStats) { stat in
          StatView(stat: stat)
        }
      }
      .padding(.top, 20)
    }
  }
  
  private var LinkScreen: some View {
    VStack(alignment: .leading) {
      Text("Links")
        .font(.system(size: 22, weight: .bold))
      Divider()
      LazyVGrid(columns: column, alignment: .leading, spacing: 20) {
        if let websiteURL = vm.websiteURL, let url = URL(string: websiteURL) {
          Link(destination: url) {
            Label("Website", systemImage: "link")
          }
        }
        
        if let reddit = vm.redditURL, let url = URL(string: reddit) {
          Link(destination: url) {
            Label("Reddit", systemImage: "link")
          }
        }
      }
      .padding(.top, 10)
    }
  }
}

#Preview {
  NavigationStack {
    CoinDetailView(coin: AppPreview.instance.coin)
  }
}
