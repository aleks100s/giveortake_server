import Vapor

struct DeviceIDCheckerMiddleware: AsyncMiddleware {
	func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
		guard request.url.path != "/api/\(User.schema)/create" else {
			return try await next.respond(to: request)
		}
		
		guard let deviceId = request.headers["device-id"].first else {
			throw Abort(.unauthorized)
		}
		
		guard let user = try? await User.query(on: request.db)
			.filter(\.$deviceId, .equal, deviceId)
			.first()
		else { throw Abort(.notFound) }
				
		request.storage[UserKey.self] = user
		
		return try await next.respond(to: request)
	}
}

struct UserKey: StorageKey {
	typealias Value = User
}

extension Request {
	var user: User? {
		return self.storage[UserKey.self]
	}
}
