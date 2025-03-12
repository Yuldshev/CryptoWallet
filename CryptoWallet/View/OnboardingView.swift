import SwiftUI

struct OnboardingView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    VStack {
      Text("Onboarding Screen")
      Button("Finish Onboarding") {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        appState.checkAppState()
      }
    }
  }
}

