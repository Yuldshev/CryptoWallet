import SwiftUI

struct Indicator: View {
  @State var currentPage = 0
  var body: some View {
    HStack {
      ForEach(0..<3) { index in
        Circle()
          .frame(width: 8, height: 8)
          .foregroundStyle(index == currentPage ? .blue : .secondary)
      }
    }
  }
}

#Preview {
  Indicator()
}
