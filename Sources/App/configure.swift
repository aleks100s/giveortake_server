import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	let databaseName: String
	let databasePort: Int
	// 1
	if (app.environment == .testing) {
	  databaseName = "giveortake-test"
	  databasePort = 5433
	} else {
	  databaseName = "giveortake"
	  databasePort = 5432
	}
	
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? databasePort,
        username: Environment.get("DATABASE_USERNAME") ?? "aleks100s",
        password: Environment.get("DATABASE_PASSWORD") ?? "qwerty",
        database: Environment.get("DATABASE_NAME") ?? databaseName,
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateQuestion())
	app.migrations.add(CreateUser())
	app.migrations.add(CreateLog())
	app.migrations.add(CreatePendingQuestion())
	
	app.middleware.use(DeviceIDCheckerMiddleware())
	app.middleware.use(LoggingMiddleware())

    app.views.use(.leaf)

	try await app.autoMigrate()

    // register routes
    try routes(app)
	
	try await QuestionSeed().generate(in: app.db)
}
