import Fluent

struct CreateLog: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema(Log.schema)
			.id()
			.field("userId", .uuid, .required, .references(User.schema, "id"))
			.field("action", .string, .required)
			.field("createdAt", .datetime, .required)
			.create()
	}
	
	func revert(on database: Database) async throws {
		try await database.schema(Log.schema).delete()
	}
}
