import Fluent

struct CreateQuestion: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema(Question.schema)
			.id()
			.field("text", .string, .required)
			.field("answer", .double, .required)
			.field("image_url", .string)
			.create()
	}
	
	func revert(on database: Database) async throws {
		try await database.schema(Question.schema).delete()
	}
}
