import SwiftUI

struct SortView: View {
  //MARK: - Properties
  var isShowHolding: Bool
  @EnvironmentObject var vm: CoinViewModel
  
  //MARK: - Body
  var body: some View {
    HStack {
      HStack(spacing: 4) {
        Text("Coins")
        Image(systemName: "chevron.down")
          .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
          .rotationEffect(.degrees(vm.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation {
          vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
        }
      }
      
      Spacer()
      if isShowHolding {
        HStack(spacing: 4) {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
            .rotationEffect(.degrees(vm.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
          withAnimation {
            vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        }
      }
      
      HStack(spacing: 4) {
        Text("Price")
        Image(systemName: "chevron.down")
          .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
          .rotationEffect(.degrees(vm.sortOption == .price ? 0 : 180))
      }
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
      .onTapGesture {
        withAnimation {
          vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
        }
      }
      
      Button {
        withAnimation {
          vm.reloadData()
        }
      } label: {
        Image(systemName: "goforward")
          .foregroundStyle(.accent)
      }
      .rotationEffect(.degrees(vm.isLoading ? 360 : 0))
    }
    .font(.caption)
    .padding(.horizontal, 20)
  }
}

//MARK: - Preview
#Preview {
  SortView(isShowHolding: false).environmentObject(CoinViewModel())
}
