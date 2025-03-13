import SwiftUI

struct AuthView: View {
  @ObservedObject var appState: AppState
  @StateObject private var viewModel = RegistrationViewModel()
  @FocusState private var focusedField: Field?
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Create Wallet")
        .font(.system(size: 34, weight: .bold))
        .padding(.top, 47)
      
      VStack(spacing: 20) {
        CustomTextField(title: "Name", text: $viewModel.name, errorMessage: viewModel.nameError)
          .focused($focusedField, equals: .name)
          .submitLabel(.next)
          .onSubmit { focusedField = .email }
        CustomTextField(title: "Email", text: $viewModel.email, errorMessage: viewModel.emailError)
          .focused($focusedField, equals: .email)
          .submitLabel(.next)
          .onSubmit { focusedField = .password }
        CustomTextField(title: "Password", text: $viewModel.password, errorMessage: viewModel.passwordError, isSecure: true)
          .focused($focusedField, equals: .password)
          .submitLabel(.done)
          .onSubmit { focusedField = nil }
      }
      .padding(.top, 24)
      Spacer()
      CustomButton(vm: ButtonModel(title: "Let's go!", isPrimary: true, action: {
        if viewModel.register() == true {
          UserDefaults.standard.set(true, forKey: "isAuthenticated")
          appState.checkAppState()
        }
      }))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 24)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {focusedField = .name }
    }
  }
}

//MARK: - Custom TextField
struct CustomTextField: View {
  let title: String
  @Binding var text: String
  let errorMessage: String?
  var isSecure = false
  @FocusState private var isFocused: Bool
  @State private var showPassword = false
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading) {
          Text(title)
            .font(.system(size: 12))
            .foregroundStyle(.gray)
          
          if isSecure {
            if showPassword {
              TextField("", text: $text)
                .font(.system(size: 14, weight: .semibold))
                .autocorrectionDisabled(true)
                .textContentType(.password)
            } else {
              SecureField("", text: $text)
                .font(.system(size: 14, weight: .semibold))
                .autocorrectionDisabled(true)
                .textContentType(.password)
            }
          } else {
            TextField("", text: $text)
              .font(.system(size: 14, weight: .semibold))
              .autocorrectionDisabled(true)
              .textInputAutocapitalization(.never)
              .keyboardType(title == "Email" ? .emailAddress : .default)
              .textContentType(title == "Email" ? .emailAddress : .none)
          }
        }
        
        if isSecure {
          Button(action: { showPassword.toggle() }) {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
              .foregroundStyle(.gray)
              .font(.system(size: 18))
          }
        }
        
        if errorMessage != nil {
          Button(action: {text = ""}) {
            Image(systemName: "xmark.circle")
              .font(.system(size: 18))
              .foregroundStyle(.red)
          }
        }
      }
      .padding(.horizontal, 16)
      .frame(height: 64)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(errorMessage == nil ? .gray.opacity(0.3) : .red)
      }
      
      if let errorMessage = errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
          .font(.system(size: 12))
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 84)
  }
}

//MARK: - Focus Field
enum Field {
  case name, email, password
}
//MARK: - Preview
#Preview {
  AuthView(appState: AppState())
}
