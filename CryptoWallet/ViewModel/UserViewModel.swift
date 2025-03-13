import SwiftUI

class RegistrationViewModel: ObservableObject {
  @Published var name = ""
  @Published var email = ""
  @Published var password = ""
  @Published var nameError: String?
  @Published var emailError: String?
  @Published var passwordError: String?
  
  func register() -> Bool {
    validateFields()
    if nameError == nil, emailError == nil, passwordError == nil {
      return true
    }
    return false
  }
  
  private func validateFields() {
    nameError = name.count >= 2 ? nil : "Name must be at least 2 characters long"
    emailError = isValidEmail(email) ? nil : "Invalid email format"
    passwordError = isValidPassword(password) ? nil : "Password must be at least 8 characters long"
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
  }
  
  private func isValidPassword(_ password: String) -> Bool {
    return password.count >= 8
  }
}

