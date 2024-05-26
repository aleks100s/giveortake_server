import Fluent

struct CreatePendingQuestion: AsyncMigration {
	func prepare(on database: Database) async throws {
		try await database.schema(PendingQuestion.schema)
			.id()
			.field("userId", .uuid, .required, .references(User.schema, "id"))
			.field("questionId", .uuid, .required, .references(Question.schema, "id"))
			.field("createdAt", .datetime, .required)
			.create()
	}
	
	func revert(on database: Database) async throws {
		try await database.schema(PendingQuestion.schema).delete()
	}
}
