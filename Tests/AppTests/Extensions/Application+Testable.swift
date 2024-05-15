import App
import XCTVapor

extension Application {
	static func setUpTestable() async throws -> Application {
		let app = try await Application.make(.testing)
		try await configure(app)
		try await app.autoMigrate()
		return app
	}
	
	static func tearDownTestable(app: Application) async throws {
		try await app.autoRevert()
		try await app.asyncShutdown()
	}
}
