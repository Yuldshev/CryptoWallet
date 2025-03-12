import SwiftUI

struct SplashView: View {
  //MARK: - Properties
  @ObservedObject var appState: AppState
  
  //MARK: - Body
  var body: some View {
    VStack {
      Text("SW")
        .font(.system(size: 74, weight: .bold))
        .foregroundStyle(LinearGradient.appG1)
      Text("crypto wallet".uppercased())
        .font(.system(size: 18, weight: .semibold))
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
              appState.checkAppState()
            }
          }
        }
    }
  }
}

#Preview {
  SplashView(appState: .init())
}
