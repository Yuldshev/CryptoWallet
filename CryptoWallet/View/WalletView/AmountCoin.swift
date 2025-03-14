import SwiftUI

struct AmountCoin: View {
  @EnvironmentObject private var vm: CoinViewModel
  @FocusState private var isFocused: Bool
  @State private var quantity = ""
  @Environment(\.dismiss) var dismiss
  var coin: Coin
  
  var body: some View {
    VStack {
      VStack {
        TextField("", text: $quantity)
          .padding()
          .padding(.horizontal, 50)
          .font(.system(size: 38, weight: .semibold))
          .foregroundStyle(LinearGradient.appG2)
          .focused($isFocused)
          .keyboardType(.decimalPad)
          .onChange(of: quantity) { newValue, oldValue in
            quantity = newValue.replacingOccurrences(of: ",", with: ".")
          }
      }
      
      VStack(spacing: 20) {
        HStack {
          Text("Current price of \(coin.name):")
            .font(.system(size: 17))
          Spacer()
          Text(coin.currentPrice.asCurrencyDecimals6())
        }
        
        HStack {
          Text("Current value:")
            .font(.system(size: 17))
          Spacer()
          Text(getCurrentValue().asCurrencyDecimals2())
        }
      }
      .padding(24)
      
      Spacer()
    }
    .onAppear {
      updateCoin(coin: coin)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        if quantity.isEmpty {
          isFocused = true
        }
      }
    }
    .navigationTitle("Amount")
    .toolbar {
      ToolbarItem {
        Button("Save") { savePressed() }
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.blue)
          .opacity(!quantity.isEmpty ? 1 : 0)
      }
    }
  }
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantity) {
      return quantity * coin.currentPrice
    }
    return 0
  }
  
  private func savePressed() {
    let amount = Double(quantity) ?? 0
    vm.updatePortfolio(coin: coin, amount: amount)
    dismiss()
  }
  
  private func updateCoin(coin: Coin) {
    if let portfolioCoin = vm.walletCoins.first(where: { $0.id == coin.id }),
       let amount = portfolioCoin.currentHoldings {
      quantity = "\(amount)"
    } else {
      quantity = ""
    }
  }
}

#Preview {
  NavigationStack {
    AmountCoin(coin: AppPreview.instance.coin)
      .environmentObject(CoinViewModel())
  }
}
