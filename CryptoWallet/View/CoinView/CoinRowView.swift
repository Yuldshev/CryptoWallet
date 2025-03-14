import SwiftUI

//MARK: - Main View
struct CoinRowView: View {
  
  //MARK: - Properties
  var coin: Coin
  var showHoldingsColumn: Bool
  
  //MARK: - Body
  var body: some View {
    HStack(spacing: 0) {
      lefColumn
      Spacer()
      if showHoldingsColumn {
        centerColumn
      }
      rightColumn
    }
  }
}

//MARK: - View Column
extension CoinRowView {
  private var lefColumn: some View {
    HStack(spacing: 16) {
      CoinImageView(coin: coin)
        .frame(width: 38, height: 38)
      Text(coin.symbol.uppercased())
        .font(.body)
    }
  }
  
  private var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentHoldingsValue.asCurrencyDecimals2())
        .font(.system(size: 12, weight: .semibold))
      Text((coin.currentHoldings ?? 0).asNumberString())
        .font(.system(size: 10))
        .foregroundStyle(.secondary)
    }
  }
  
  private var rightColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice.asCurrencyDecimals6())
        .font(.system(size: 12, weight: .semibold))
      
      Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
        .font(.system(size: 10))
        .foregroundStyle(.secondary)
    }
    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
  }
}

//MARK: - Preview
#Preview {
  CoinRowView(coin: AppPreview.instance.coin, showHoldingsColumn: true)
}
