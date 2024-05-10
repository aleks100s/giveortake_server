import Vapor

struct QuestionController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let questions = routes.grouped(PathComponent(stringLiteral: Question.schema))

		questions.get(use: { try await self.getRandom(req: $0) })
		questions.post(use: { try await self.create(req: $0) })
		questions.delete(":ID", use: { try await self.delete(req: $0) })
	}
	
	func getRandom(req: Request) async throws -> QuestionDTO {
		guard let question = try await Question.query(on: req.db).all().randomElement() else {
			throw Abort(.noContent)
		}
		
		return question.toDTO()
	}
	
	func create(req: Request) async throws -> QuestionDTO {
		let question = try req.content.decode(QuestionDTO.self).toModel()

		try await question.save(on: req.db)
		return question.toDTO()
	}

	func delete(req: Request) async throws -> HTTPStatus {
		guard let question = try await Question.find(req.parameters.get("ID"), on: req.db) else {
			throw Abort(.notFound)
		}

		try await question.delete(on: req.db)
		return .noContent
	}
}
