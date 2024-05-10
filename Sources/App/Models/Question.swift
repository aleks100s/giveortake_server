import Fluent

final class Question: Model, @unchecked Sendable {
	static let schema = "questions"
	
	@ID(custom: "id", generatedBy: .database)
	var id: Int?
	
	@Field(key: "text")
	var text: String
	
	@Field(key: "answer")
	var answer: Double
	
	@Field(key: "image_url")
	var imageUrl: String?
	
	init() {}
	
	init(id: Int? = nil, text: String, answer: Double, imageUrl: String? = nil) {
		self.id = id
		self.text = text
		self.answer = answer
		self.imageUrl = imageUrl
	}
	
	func toDTO() -> QuestionDTO {
		QuestionDTO(id: id, text: text, answer: answer, imageUrl: imageUrl)
	}
}
