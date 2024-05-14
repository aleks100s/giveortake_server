import Vapor

struct LoggingMiddleware: AsyncMiddleware {
	func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
		guard let user = request.user else {
			return try await next.respond(to: request)
		}
		
		try await Log(userId: try user.requireID(), action: "calls \(request.url.string)").save(on: request.db)
		return try await next.respond(to: request)
	}
}
