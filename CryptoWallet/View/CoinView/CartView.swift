import SwiftUI

struct ChartView: View {
  //MARK: - Properties
  let data: [Double]
  let maxY: Double
  let minY: Double
  
  @State private var percentage: CGFloat = 0
  
  init(coin: Coin) {
    self.data = coin.sparklineIn7D?.price ?? []
    self.maxY = data.max() ?? 1
    self.minY = data.min() ?? 0
  }
  
  //MARK: - Body
  var body: some View {
    HStack(spacing: 12) {
      chartText
      chartView
        .background(chartBg)
    }
    .frame(height: 200)
    .onAppear {
      animateChart()
    }
  }
}

//MARK: - Extension View
extension ChartView {
  private var chartView: some View {
    GeometryReader { geometry in
      Path { path in
        guard !data.isEmpty else { return }
        
        for index in data.indices {
          let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
          let yAxis = maxY - minY
          let yPos = yAxis > 0 ? (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height : geometry.size.height / 2
          
          if index == 0 {
            path.move(to: CGPoint(x: xPos, y: yPos))
          } else {
            path.addLine(to: CGPoint(x: xPos, y: yPos))
          }
        }
      }
      .trim(from: 0, to: percentage)
      .stroke(LinearGradient.appG1, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
    }
  }
  
  private var chartBg: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
  
  private var chartText: some View {
    VStack(alignment: .leading) {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(((maxY + minY) / 2).formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
    .foregroundStyle(.gray)
    .font(.caption2)
  }
  
  private func animateChart() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      withAnimation(.easeInOut(duration: 1.5)) {
        percentage = 1
      }
    }
  }
}

//MARK: - Preview
#Preview {
  ChartView(coin: AppPreview.instance.coin)
}
