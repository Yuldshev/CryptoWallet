import SwiftUI

struct SplashView: View {
  //MARK: - Properties
  @ObservedObject var appState: AppState
  
  //MARK: - Body
  var body: some View {
    VStack {
      Text("Splash Screen")
        .font(.largeTitle)
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
