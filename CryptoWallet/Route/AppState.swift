import Foundation
import SwiftUI

class AppState: ObservableObject {
  @Published var currentView: AppView = .splash
  
  init() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.checkAppState()
    }
  }
  
  func checkAppState() {
    let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    let isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    
    withAnimation {
      if !hasSeenOnboarding {
        currentView = .onboarding
      } else if !isAuthenticated {
        currentView = .auth
      } else {
        currentView = .home
      }
    }
  }
  
  func logout() {
    UserDefaults.standard.set(false, forKey: "isAuthenticated")
    withAnimation {
      currentView = .auth
    }
  }
}

enum AppView {
  case splash, onboarding, auth, home
}
