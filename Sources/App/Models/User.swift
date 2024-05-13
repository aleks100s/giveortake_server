import Fluent
import Vapor

final class User: Model, @unchecked Sendable {
	static let schema = "users"
	
	@ID
	var id: UUID?
	
	@Field(key: "deviceId")
	var deviceId: String
	
	@OptionalField(key: "username")
	var username: String?
	
	init() {}
	
	init(id: UUID? = nil, deviceId: String, username: String?) {
		self.deviceId = deviceId
		self.username = username
	}
	
	func toDTO() -> UserDTO {
		UserDTO(id: id, username: username)
	}
}
