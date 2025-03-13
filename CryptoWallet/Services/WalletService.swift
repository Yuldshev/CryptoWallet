import Foundation
import CoreData

class WalletService {
  @Published var savedEntities: [Wallet] = []
  private let container: NSPersistentContainer
  private let containerName = "WalletContainer"
  
  init() {
    container = NSPersistentContainer(name: containerName)
    container.loadPersistentStores { [weak self] _, error in
      if let error = error {
        print("Error loading Core Data! \(error)")
      }
      self?.getPortfolio()
    }
  }
  
  //MARK: - Public
  func updatePortfolio(coin: Coin, amount: Double) {
    if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
      if amount > 0 {
        update(entity: entity, amount: amount)
      } else {
        delete(entity: entity)
      }
    } else {
      add(coin: coin, amount: amount)
    }
  }
  
  //MARK: - Private
  private func getPortfolio() {
    let requst = NSFetchRequest<Wallet>(entityName: "Wallet")
    do {
      savedEntities = try container.viewContext.fetch(requst)
    } catch {
      print("Error fetching portfolio: \(error)")
    }
  }
  
  private func add(coin: Coin, amount: Double) {
    let entity = Wallet(context: container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    applyChanges()
  }
  
  private func update(entity: Wallet, amount: Double) {
    entity.amount = amount
    applyChanges()
  }
  
  private func delete(entity: Wallet) {
    container.viewContext.delete(entity)
    applyChanges()
  }
  
  private func save() {
    do {
      try container.viewContext.save()
    } catch {
      print("Error saving context: \(error)")
    }
  }
  
  private func applyChanges() {
    save()
    getPortfolio()
  }
}
