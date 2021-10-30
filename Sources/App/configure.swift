
import Vapor

// configures your application
public func configure(_ app: Application) throws {
  // configure port
  print(app.commands)
  app.http.server.configuration.port = 8090
  // register routes
  try routes(app)
}
