import Foundation
import Combine
import os.log

class NetworkManager {
  enum NetworkError: LocalizedError {
    case invalidURL
    case badURLResponse(statusCode: Int)
    case noData
    case decodingFailed
    case unknown(Error)
    
    var errorDescription: String? {
      switch self {
        case .invalidURL:
          return "❌ Invalid URL"
        case .badURLResponse(let statusCode):
          return "🔥 Bad response from URL: \(statusCode)"
        case .noData:
          return "⚠️ No data received"
        case .decodingFailed:
          return "🚨 Failed to decode response"
        case .unknown(let error):
          return "❓ Unknown error: \(error.localizedDescription)"
      }
    }
  }
  
  static func download(url: URL) -> AnyPublisher<Data, Error> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .tryMap { try handleURLResponse(output: $0) }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  private static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard let response = output.response as? HTTPURLResponse else {
      throw NetworkError.unknown(NSError(domain: "Invalid Response", code: 0))
    }
    
    guard (200...299).contains(response.statusCode) else {
      throw NetworkError.badURLResponse(statusCode: response.statusCode)
    }
    
    guard !output.data.isEmpty else {
      throw NetworkError.noData
    }
    
    return output.data
  }
  
  static func handleCompletion(completion: Subscribers.Completion<Error>) {
    switch completion {
      case .finished:
        os_log("✅ Request finished successfully")
      case .failure(let error):
        os_log("⚠️ Network error: %@", error.localizedDescription)
    }
  }
}
