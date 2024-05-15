import Vapor

struct UserDTO: Content, Equatable {
	let id: UUID?
	let username: String?
}
