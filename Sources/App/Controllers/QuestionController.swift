import Vapor

struct QuestionController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let questions = routes.grouped("api", PathComponent(stringLiteral: Question.schema))

		questions.get(use: { try await self.getRandom(req: $0) })
		questions.post(":ID", "answer", use: { try await answerQuestion(req: $0) })
	}
	
	private func getRandom(req: Request) async throws -> QuestionDTO {
		guard let user = req.user else {
			throw Abort(.unauthorized)
		}
		
		if let pendingQuestion = try await getPendingQuestion(req: req) {
			let question = try await pendingQuestion.$question.get(on: req.db)
			return question.toDTO()
		} else {
			guard let question = try await Question.query(on: req.db).all().randomElement() else {
				throw Abort(.notFound)
			}
			
			let pendingQuestion = PendingQuestion(userId: try user.requireID(), questionId: try question.requireID(), createdAt: Date())
			try await pendingQuestion.save(on: req.db)
			
			return question.toDTO()
		}
	}
	
	private func answerQuestion(req: Request) async throws -> ResultDTO {
		let answer = try req.content.decode(AnswerDTO.self)
		guard let question = try await Question.find(req.parameters.get("ID"), on: req.db) else {
			throw Abort(.notFound)
		}
		
		guard let pendingQuestion = try await getPendingQuestion(req: req) else {
			throw Abort(.notFound)
		}
		
		guard try await pendingQuestion.$question.get(on: req.db) == question else {
			throw Abort(.notFound)
		}
		
		try await pendingQuestion.delete(on: req.db)
		
		let points = calculatePoints(userAnswer: answer.userInput, correctAnswer: question.answer)
		return ResultDTO(points: points)
	}
	
	private func getPendingQuestion(req: Request) async throws -> PendingQuestion? {
		try await req.user?.$pendingQuestions.get(on: req.db).first
	}
	
	private func calculatePoints(userAnswer: Double, correctAnswer: Double) -> Int {
		let difference = abs(userAnswer - correctAnswer)
		let maxPoints: Double = 100
		let sensibility: Double = 1 + 0.1
		let curvePower: Double = 2
		let result = maxPoints / (sensibility * difference * curvePower)
		return Int(result * 100)
	}
}
