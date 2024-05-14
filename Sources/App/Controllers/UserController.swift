import Vapor

struct UserController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("api", PathComponent(stringLiteral: User.schema))
		users.get("get-by-device", use: { try await getUserByDevice(req: $0) })
		users.post("create", use: { try await createUser(req: $0) })
	}
	
	private func getUserByDevice(req: Request) async throws -> UserDTO {
		guard let user = req.user else {
			throw Abort(.notFound)
		}
		
		return user.toDTO()
	}
	
	private func createUser(req: Request) async throws -> UserDTO {
		guard let deviceId = req.headers["device-id"].first else {
			throw Abort(.unauthorized)
		}
		
		let user = User()
		user.deviceId = deviceId
		try await user.save(on: req.db)
		return user.toDTO()
	}
}
