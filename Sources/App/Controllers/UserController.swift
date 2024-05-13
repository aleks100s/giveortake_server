import Vapor

struct UserController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let users = routes.grouped("api", PathComponent(stringLiteral: User.schema))
		users.get("get-by-device", use: { try await getUserByDevice(req: $0) })
		users.post("create", use: { try await createUser(req: $0) })
	}
	
	private func getUserByDevice(req: Request) async throws -> UserDTO {
		guard let deviceId = req.headers["device-id"].first else {
			throw Abort(.unauthorized)
		}
		
		guard let user = try? await User.query(on: req.db)
			.filter(\.$deviceId, .equal, deviceId)
			.first()
		else { throw Abort(.notFound) }
		
		return user.toDTO()
	}
	
	private func createUser(req: Request) async throws -> UserDTO {
		struct Container: Content {
			let deviceId: String
		}
		
		guard let container = try? req.content.decode(Container.self) else {
			throw Abort(.badRequest)
		}
		
		let user = User()
		user.deviceId = container.deviceId
		try await user.save(on: req.db)
		return user.toDTO()
	}
}
