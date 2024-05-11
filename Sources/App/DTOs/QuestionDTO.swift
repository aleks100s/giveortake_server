import Vapor

struct QuestionDTO: Content {
	let id: UUID?
	let text: String
	let imageUrl: String?
}
