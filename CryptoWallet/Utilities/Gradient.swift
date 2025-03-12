import SwiftUI

extension LinearGradient {
  static let appG1: LinearGradient = .init(
    gradient: Gradient(colors: [.appG1, .appG2, .appG3, .appG4]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  static let appG2: LinearGradient = .init(
    gradient: Gradient(colors: [.appG5, .appG6]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}
