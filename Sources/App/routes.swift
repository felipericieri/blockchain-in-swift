
import Vapor

func routes(_ app: Application) throws {
  
  let blockchainService = BlockchainService()
  
  let blockchainController = BlockchainController(blockchainService: blockchainService)
  app.get("blockchain", use: blockchainController.blockchain)
  app.post("mine", use: blockchainController.mine)
  
  let nodesController = NodesController(blockchainService: blockchainService)
  app.get("nodes", use: nodesController.nodes)
  app.post("nodes", use: nodesController.registerNode)
}
