import Fluent

struct CreateUser: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema(User.schema)
			.id()
			.field("deviceId", .string, .required)
			.field("username", .string)
			.create()
	}
	
	func revert(on database: Database) async throws {
		try await database.schema(User.schema).delete()
	}
}
