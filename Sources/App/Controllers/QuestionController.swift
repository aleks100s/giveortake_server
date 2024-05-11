import Vapor

struct QuestionController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let questions = routes.grouped(PathComponent(stringLiteral: Question.schema))

		questions.get(use: { try await self.getRandom(req: $0) })
	}
	
	func getRandom(req: Request) async throws -> QuestionDTO {
		guard let question = try await Question.query(on: req.db).all().randomElement() else {
			throw Abort(.noContent)
		}
		
		return question.toDTO()
	}
}
