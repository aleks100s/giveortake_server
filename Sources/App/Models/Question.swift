import Fluent
import Foundation

final class Question: Model, @unchecked Sendable {
	static let schema = "questions"
	
	@ID
	var id: UUID?
	
	@Field(key: "text")
	var text: String
	
	@Field(key: "answer")
	var answer: Double
	
	@OptionalField(key: "image_url")
	var imageUrl: String?
	
	init() {}
	
	init(id: UUID? = nil, text: String, answer: Double, imageUrl: String? = nil) {
		self.id = id
		self.text = text
		self.answer = answer
		self.imageUrl = imageUrl
	}
	
	func toDTO() -> QuestionDTO {
		QuestionDTO(id: id, text: text, imageUrl: imageUrl)
	}
}
