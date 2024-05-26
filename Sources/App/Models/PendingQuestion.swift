import Fluent
import Foundation

final class PendingQuestion: Model, @unchecked Sendable {
	static let schema = "pending_questions"
	
	@ID
	var id: UUID?
	
	@Parent(key: "userId")
	var user: User
	
	@Parent(key: "questionId")
	var question: Question
	
	@Field(key: "createdAt")
	var createdAt: Date
	
	init() {}
	
	init(id: UUID? = nil, userId: User.IDValue, questionId: Question.IDValue, createdAt: Date) {
		self.id = id
		self.$user.id = userId
		self.$question.id = questionId
		self.createdAt = createdAt
	}
}

