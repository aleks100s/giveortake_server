import Vapor

struct QuestionSeed {
	func generate(app: Application) async throws {
		guard try await Question.query(on: app.db).all().isEmpty else { return }
		
		for _ in 0..<100 {
			let model = Question(text: UUID().uuidString, answer: Double.random(in: 0...1000))
			try await model.save(on: app.db)
		}
	}
}
