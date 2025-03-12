import SwiftUI

struct AuthView: View {
  @ObservedObject var appState: AppState
  
  var body: some View {
    VStack {
      Text("Auth Screen")
      Button("Login") {
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        appState.checkAppState()
      }
    }
  }
}

