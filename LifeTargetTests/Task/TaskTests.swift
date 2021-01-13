//
//  TaskTests.swift
//  LifeTargetTests
//
//  Created by Mikhail Malyshev on 13.01.2021.
//

import XCTest
@testable import LifeTarget

class TaskTests: XCTestCase {

	lazy var database = DatabaseCoordinator(name: "Models")

	lazy var readContext = database.readContext!
	lazy var writeContext = database.writeContext!

	override func tearDown() {
		super.tearDown()
		self.writeContext.removeEntries(entity: TaskDB.self)
	}

	override func tearDownWithError() throws {
		try super.tearDownWithError()
		self.writeContext.removeEntries(entity: TaskDB.self)
	}

	func testSimpleWriteReadTask() {
		// arrange
		let task = TaskStub.rootObject(id: 1)
		TaskDB.createOrUpdate(input: task, context: writeContext)

		// act
		try? writeContext.save()

		let result = readContext.entries(entity: TaskDB.self)

		// assert
		XCTAssert(result.count == 1)

		let readedTask = Task(db: result[0])

		XCTAssert(task == readedTask)
	}

	func test2LevelsWriteReadTasks() {
		// arrange
		let root = TaskStub.rootObject(id: 2)
		let children = TaskStub.buildObject()

		let rootDB = TaskDB.createOrUpdate(input: root, context: writeContext)
		TaskDB.createOrUpdate(input: children, context: writeContext, update: { $0.parent = rootDB })

		// act
		try? writeContext.save()

		let rootReadedDB = readContext.entry(entity: TaskDB.self, predicate: NSPredicate(format: "id = '\(root.id)'"))

		// assert
		XCTAssert(rootReadedDB != nil)

		let rootReaded = Task(db: rootReadedDB!)

		XCTAssert(rootReaded == root)
		XCTAssert(rootReaded.subtasks?.count == 1)

		let subtask = rootReaded.subtasks![0]
		XCTAssert(subtask == children)
	}

	func test3LevelsWriteReadTasks() {
		// arrange
		let root = TaskStub.rootObject(id: 3)
		let children = TaskStub.buildObject()
		let childChildren = TaskStub.buildObject()

		let rootDB = TaskDB.createOrUpdate(input: root, context: writeContext)
		let childrenDB = TaskDB.createOrUpdate(input: children, context: writeContext, update: { $0.parent = rootDB })

		TaskDB.createOrUpdate(input: childChildren, context: writeContext, update: { $0.parent = childrenDB })

		// act
		try? writeContext.save()

		let rootReadedDB = readContext.entry(entity: TaskDB.self, predicate: NSPredicate(format: "id = '\(root.id)'"))

		// assert
		XCTAssert(rootReadedDB != nil)

		let rootReaded = Task(db: rootReadedDB!)

		XCTAssert(rootReaded == root)
		XCTAssert(rootReaded.subtasks?.count == 1)

		let subtask = rootReaded.subtasks![0]
		XCTAssert(subtask == children)

		XCTAssert(subtask.subtasks == nil)
	}

	func testUpdateTaskTitleAndTime() {
		// arrange
		let root = TaskStub.rootObject(id: 4)
		let newTitle = "new_title"
		let newStartDate = Date(timeIntervalSince1970: 1000)
		TaskDB.createOrUpdate(input: root, context: writeContext)
		let predicate = NSPredicate(format: "id = '\(root.id)'")

		// act
		try? writeContext.save()

		let rootReadedDB1 = readContext.entry(entity: TaskDB.self, predicate: predicate)
		var rootReaded1 = Task(db: rootReadedDB1!)
		rootReaded1.title = newTitle
		rootReaded1.duration?.start = newStartDate
		TaskDB.createOrUpdate(input: rootReaded1, context: writeContext)

		try? self.writeContext.save()

		let rootReadedDB2 = readContext.entry(entity: TaskDB.self, predicate: predicate)
		let rootReaded2 = Task(db: rootReadedDB2!)

		// assert
		XCTAssert(readContext.entries(entity: TaskDB.self, predicate: predicate).count == 1)
		XCTAssert(rootReaded2.title == newTitle)
		XCTAssert(rootReaded2.updateDate != rootReaded2.createDate)
		XCTAssert(rootReaded1.createDate == rootReaded2.createDate)
		XCTAssert(rootReaded2.duration?.start == newStartDate)
		XCTAssert(rootReaded2.duration?.end == rootReaded1.duration?.end)
	}

	func testDeleteTask() {
		// arrange
		let root = TaskStub.rootObject(id: 5)
		TaskDB.createOrUpdate(input: root, context: writeContext)
		let predicate = NSPredicate(format: "id = '\(root.id)'")

		// act
		try? writeContext.save()

		// assert
		XCTAssert(readContext.entries(entity: TaskDB.self, predicate: predicate, sort: nil).count == 1)

		writeContext.removeEntries(entity: TaskDB.self, predicate: predicate)
		XCTAssert(readContext.entries(entity: TaskDB.self, predicate: predicate, sort: nil).count == 0)
	}
}
