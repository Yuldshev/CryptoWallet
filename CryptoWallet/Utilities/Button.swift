import SwiftUI

struct CustomButton: View {
  //MARK: - Properties
  let vm: ButtonModel
  
  //MARK: - Body
  var body: some View {
    Button (action: vm.action) {
      Text(vm.title)
        .foregroundStyle(.white)
        .font(.system(size: 16, weight: .bold))
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(vm.isPrimary ? AnyView(LinearGradient.appG1) : AnyView(Color.accentColor.opacity(0.4)))
        .clipShape(Capsule())
    }
    
  }
}

enum buttonType {
  case primary, secondary
}

struct ButtonModel {
  let title: String
  let isPrimary: Bool
  let action: () -> Void
}

#Preview {
  VStack {
    CustomButton(vm: ButtonModel(title: "Secondary", isPrimary: false, action: {}))
    CustomButton(vm: ButtonModel(title: "Primary", isPrimary: true, action: {}))
  }
}
