import Vapor

struct QuestionController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let questions = routes.grouped("api", PathComponent(stringLiteral: Question.schema))

		questions.get(use: { try await self.getRandom(req: $0) })
		questions.post(":ID", "answer", use: { try await answerQuestion(req: $0) })
	}
	
	private func getRandom(req: Request) async throws -> QuestionDTO {
		guard let question = try await Question.query(on: req.db).all().randomElement() else {
			throw Abort(.notFound)
		}
		
		return question.toDTO()
	}
	
	private func answerQuestion(req: Request) async throws -> ResultDTO {
		let answer = try req.content.decode(AnswerDTO.self)
		guard let question = try await Question.find(req.parameters.get("ID"), on: req.db) else {
			throw Abort(.notFound)
		}
		
		let points = calculatePoints(userAnswer: answer.userInput, correctAnswer: question.answer)
		return ResultDTO(points: points)
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
