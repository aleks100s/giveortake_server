import Vapor

struct UserController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("api", PathComponent(stringLiteral: User.schema))
		users.post(use: { try await getUserByDevice(req: $0) })
	}
	
	func getUserByDevice(req: Request) async throws -> UserDTO {
		struct Container: Content {
			let deviceId: String
		}
		
		guard let container = try? req.content.decode(Container.self) else {
			throw Abort(.badRequest)
		}
		
		guard let user = try? await User.query(on: req.db)
			.filter(\.$deviceId, .equal, container.deviceId)
			.first()
		else { return try await createUser(req: req, deviceId: container.deviceId) }
		
		return user.toDTO()
	}
	
	private func createUser(req: Request, deviceId: String) async throws -> UserDTO {
		let user = User()
		user.deviceId = deviceId
		try await user.save(on: req.db)
		return user.toDTO()
	}
}
