import Foundation

struct Stat: Identifiable {
  let id = UUID()
  let title: String
  let value: String
  let percent: Double?
  
  init(title: String, value: String, percent: Double? = nil) {
    self.title = title
    self.value = value
    self.percent = percent
  }
}
