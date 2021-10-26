import Vapor

class BlockchainController {
  
  private let blockchainService: BlockchainService
  
  init() {
      blockchainService = BlockchainService()
  }
  
  // MARK: - Routes
  
  func greet(req: Request) -> EventLoopFuture<String> {
    return req.eventLoop.future("Hello world!")
  }
  
  func blockchain(req: Request) -> EventLoopFuture<Blockchain> {
    return req.eventLoop.future(blockchainService.blockchain)
  }
  
  func mine(req: Request) throws -> EventLoopFuture<Block> {
    let txs = try req.content.decode([Transaction].self)
    let block = blockchainService.nextBlock(txs: txs)
    return req.eventLoop.future(block)
  }
  
  func nodes(req: Request) throws -> EventLoopFuture<[Node]> {
    return req.eventLoop.future(blockchainService.nodes)
  }
  
  func registerNode(req: Request) throws -> EventLoopFuture<[Node]> {
    let givenNodes = try req.content.decode([Node].self)
    let nodes = blockchainService.register(nodes: givenNodes)
    return req.eventLoop.future(nodes)
  }
}
