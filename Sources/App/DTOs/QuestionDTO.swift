import Vapor

struct QuestionDTO: Content {
	let id: Int?
	let text: String
	let answer: Double
	let imageUrl: String?
	
	func toModel() -> Question {
		let model = Question()
		model.id = id
		model.text = text
		model.answer = answer
		model.imageUrl = imageUrl
		return model
	}
}
