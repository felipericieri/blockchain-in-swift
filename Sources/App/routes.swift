
import Vapor

func routes(_ app: Application) throws {
  
  let blockchainController = BlockchainController()
  
  app.get("blockchain", use: blockchainController.blockchain)
  app.post("mine", use: blockchainController.mine)
  app.get("nodes", use: blockchainController.nodes)
  app.post("nodes", use: blockchainController.registerNode)
}
