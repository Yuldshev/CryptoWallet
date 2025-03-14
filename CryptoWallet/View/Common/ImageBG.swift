import SwiftUI

struct ImageBG: View {
  var body: some View {
    Image(.bg)
      .resizable()
      .scaledToFit()
      .edgesIgnoringSafeArea(.all)
      .opacity(0.7)
      .offset(x: -90, y: -280)
  }
}

#Preview {
  ImageBG()
}
