import Foundation

extension Double {
  private var currencyFormatter2: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.currencySymbol = "$"
    formatter.locale = Locale(identifier: "en_US")
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
  func asCurrencyDecimals2() -> String {
    return currencyFormatter2.string(from: NSNumber(value: self)) ?? ""
  }
  
  private var currencyFormatter6: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.currencySymbol = "$"
    formatter.locale = Locale(identifier: "en_US")
    formatter.maximumFractionDigits = 2
    formatter.maximumFractionDigits = 6
    return formatter
  }
  
  func asCurrencyDecimals6() -> String {
    return currencyFormatter6.string(from: NSNumber(value: self)) ?? ""
  }
  
  func asNumberString() -> String {
    return String(format: "%.2f", self)
  }
  
  func asPercentString() -> String {
    return asNumberString() + "%"
  }
  
  func formattedWithAbbreviations() -> String {
    let num = abs(Double(self))
    let sign = (self < 0) ? "-" : ""
    
    switch num {
      case 1_000_000_000_000...:
        let formatted = num / 1_000_000_000_000
        let stringFormatted = formatted.asNumberString()
        return "\(sign)\(stringFormatted)Tr"
      case 1_000_000_000...:
        let formatted = num / 1_000_000_000
        let stringFormatted = formatted.asNumberString()
        return "\(sign)\(stringFormatted)Bn"
      case 1_000_000...:
        let formatted = num / 1_000_000
        let stringFormatted = formatted.asNumberString()
        return "\(sign)\(stringFormatted)M"
      case 1_000...:
        let formatted = num / 1_000
        let stringFormatted = formatted.asNumberString()
        return "\(sign)\(stringFormatted)K"
      case 0...:
        return self.asNumberString()
      default :
        return "\(sign)\(self)"
    }
  }
}
