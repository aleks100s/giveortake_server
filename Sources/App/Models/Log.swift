import Fluent
import Foundation

final class Log: Model, @unchecked Sendable {
	static let schema = "logs"
	
	@ID
	var id: UUID?
	
	@Parent(key: "userId")
	var user: User
	
	@Field(key: "action")
	var action: String
	
	@Field(key: "createdAt")
	var createdAt: Date
	
	init() {}
	
	init(id: UUID? = nil, userId: User.IDValue, action: String, createdAt: Date = Date()) {
		self.id = id
		self.$user.id = userId
		self.action = action
		self.createdAt = createdAt
	}
}
