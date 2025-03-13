import SwiftUI

struct ProfileView: View {
  @StateObject private var vm = RegistrationViewModel()
  @ObservedObject var appState: AppState
  
  var body: some View {
    ZStack {
      Image(.bg)
        .resizable()
        .scaledToFit()
        .edgesIgnoringSafeArea(.all)
        .opacity(0.7)
        .offset(x: -90, y: -280)
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading) {
          HeaderScreen
            .padding(.top, 20)
          TextFields
          .padding(24)
          
          Spacer()
          CustomButton(vm: ButtonModel(title: "Save changes", isPrimary: true, action: {
            vm.saveChanges()
          }))
          .padding(.horizontal, 24)
        }
      }
    }
  }
  
  private var HeaderScreen: some View {
    HStack(spacing: 40) {
      Circle()
        .foregroundStyle(.gray)
        .frame(width: 100, height: 100)
        .overlay {
          Image(systemName: "person")
            .font(.system(size: 40))
            .foregroundStyle(.black)
        }

      VStack(alignment: .leading) {
        Text("✋Hi,")
        Text(vm.name.capitalized)
          .foregroundStyle(LinearGradient.appG1)
          .bold()
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
      .font(.system(size: 34))
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, alignment: .leading)
    .overlay(alignment: .topTrailing) {
      Button {
        vm.logout()
        appState.logout()
      } label: {
        Text("Log out")
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.blue)
          .padding(.trailing, 24)
      }
    }
  }
  
  private var TextFields: some View {
    VStack(spacing: 20) {
      CustomTextField(title: "Name", text: $vm.name, errorMessage: vm.nameError)
      CustomTextField(title: "Email", text: $vm.email, errorMessage: vm.emailError)
      CustomTextField(title: "Password", text: $vm.password, errorMessage: vm.passwordError, isSecure: true)
    }
  }
}

#Preview {
  ProfileView(appState: AppState())
}
