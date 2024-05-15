import XCTest
import XCTVapor
@testable import App

final class UserContrbollerTests: XCTestCase {
	var app: Application!
	
	override func setUp() async throws {
		try await super.setUp()
		app = try await Application.setUpTestable()
	}
	
	override func tearDown() async throws {
		try await Application.tearDownTestable(app: app)
		app = nil
		try await super.tearDown()
	}
	
	func test_createUser() throws {
		try app.test(.POST, "api/users/create", headers: ["device-id": UUID().uuidString]) { response in
			XCTAssertEqual(response.status, .ok)
			let user = try response.content.decode(UserDTO.self)
			XCTAssertNotNil(user.id)
		}
	}
	
	func test_getUserById() throws {
		let deviceId = UUID().uuidString
		var createdUser: UserDTO?
		
		try app.test(.POST, "api/users/create", headers: ["device-id": deviceId]) { response in
			createdUser = try response.content.decode(UserDTO.self)
		}
		
		try app.test(.GET, "api/users/get-by-device", headers: ["device-id": deviceId]) { response in
			XCTAssertEqual(response.status, .ok)
			let user = try response.content.decode(UserDTO.self)
			XCTAssertNotNil(user.id)
			XCTAssertEqual(createdUser, user)
		}
	}
}
