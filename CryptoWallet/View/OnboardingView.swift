import SwiftUI

struct OnboardingView: View {
  @State private var indicator = 0
  @ObservedObject var appState: AppState
  let onboardingScreens = [
    ("onboard1", "Property Diversity"),
    ("onboard2", "Safe Security"),
    ("onboard3", "Convenient Transaction"),
    ("onboard4", "Wallet Setup")
  ]
  
  var body: some View {
    VStack {
      Spacer()
      
      ZStack {
        ForEach(0..<onboardingScreens.count, id: \.self) { index in
          if index == indicator {
            OnboardingScreen(image: onboardingScreens[index].0, text: onboardingScreens[index].1)
              .transition(.move(edge: .trailing))
          }
        }
      }
      .animation(.easeInOut(duration: 0.3), value: indicator)
      
      Indicator(currentIndex: indicator)
        .padding(.bottom, 30)
        .padding(.top, 90)
      
      CustomButton(
        vm: ButtonModel(
          title: indicator < onboardingScreens.count - 1 ? "Next" : "Create a new Wallet",
          isPrimary: indicator == onboardingScreens.count - 1,
          action: {
            withAnimation {
              if indicator < onboardingScreens.count - 1 {
                indicator += 1
              } else {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                appState.checkAppState()
              }
            }
          }
        )
      )
    }
    .padding(.horizontal, 24)
  }
}

// MARK: - OnboardingScreen
struct OnboardingScreen: View {
  let image: String
  let text: String
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    VStack(spacing: 80) {
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(height: 252)
        .frame(maxWidth: .infinity)
      FormattedText(text: text)
        .frame(width: 230)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .minimumScaleFactor(0.8)
    }
    .frame(maxWidth: .infinity)
    .background(colorScheme == .light ? Color.white : Color.black)
  }
}

// MARK: - Formatted Text
struct FormattedText: View {
  var text: String
  
  var body: some View {
    let words = text.split(separator: " ", maxSplits: 1).map(String.init)
    
    return Text(words.first ?? "")
      .font(.system(size: 40))
      .foregroundStyle(.white)
      .bold()
    + Text(" " + (words.count > 1 ? words[1] : ""))
      .font(.system(size: 40, weight: .bold))
      .foregroundStyle(LinearGradient.appG1)
      .bold()
  }
}

// MARK: - Preview
#Preview {
  OnboardingView(appState: .init())
}
