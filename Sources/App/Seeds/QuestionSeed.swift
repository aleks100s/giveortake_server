import Fluent
import Vapor

struct QuestionSeed {
	func generate(in db: Database) async throws {
		guard try await Question.query(on: db).first() == nil else { return }
		
		for _ in 0..<100 {
			let model = Question(text: UUID().uuidString, answer: Double.random(in: 0...1000))
			try await model.save(on: db)
		}
	}
}
