import SwiftUI

struct Indicator: View {
  var currentIndex: Int
  
  var body: some View {
    HStack {
      ForEach(0..<4) { index in
        Circle()
          .frame(width: 8, height: 8)
          .foregroundStyle(index == currentIndex ? .blue : .secondary)
      }
    }
  }
}

#Preview {
  Indicator(currentIndex: 0)
}
