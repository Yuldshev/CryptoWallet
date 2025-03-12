import SwiftUI

struct MainView: View {
  @StateObject private var appState = AppState()
  
  var body: some View {
    ZStack {
      switch appState.currentView {
        case .splash:
          SplashView(appState: appState)
            .transition(.blurReplace)
        case .onboarding:
          OnboardingView(appState: appState)
            .transition(.blurReplace)
        case .auth:
          AuthView(appState: appState)
            .transition(.blurReplace)
        case .home:
          HomeView()
            .transition(.blurReplace)
      }
    }
    .animation(.easeInOut, value: appState.currentView)
  }
}

#Preview {
  MainView()
    .onAppear{ resetUserDefaults() }
}

@MainActor
func resetUserDefaults() {
  let defaults = UserDefaults.standard
  defaults.removeObject(forKey: "hasSeenOnboarding")
  defaults.removeObject(forKey: "isAuthenticated")
}
