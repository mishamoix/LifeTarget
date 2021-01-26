//
//  ExampleTaskProvider.swift
//  LifeTarget
//
//  Created by Mikhail Malyshev on 26.01.2021.
//

import Foundation

protocol ExampleTaskProviderProtocol {
	func generateAndSave(completion: @escaping () -> Void)
}

final class ExampleTaskProvider {

	private enum Consts {
		static let id = "example_task_id"
	}

	private let taskProvider: TaskProviderProtocol

	init(taskProvider: TaskProviderProtocol) {
		self.taskProvider = taskProvider
	}

	private func deleteExampleTask(completion: @escaping () -> Void) {
		let task = Task(id: Consts.id, title: "", exposition: nil, progress: nil, duration: nil,
						notification: nil, isCompleted: false, createDate: Date(), updateDate: Date(),
						subtasks: nil, parent: nil)
		taskProvider.delete(task: task) {
			completion()
		}
	}
}

extension ExampleTaskProvider: ExampleTaskProviderProtocol {
	func generateAndSave(completion: @escaping () -> Void) {
		deleteExampleTask { [weak self] in
			guard let self = self else { return }
			self.taskProvider.saveFullTreeTask(task: self.head) {
				completion()
			}
		}
	}
}

private extension ExampleTaskProvider {
	var head: Task {
		let start = Date()
		let end = Calendar.current.date(byAdding: DateComponents(year: 1), to: start) ?? Date()

		let duration = Task.Duration(start: start, end: end)
		let task = Task(id: Consts.id, title: "example_task_title".loc,
						exposition: "example_task_exposition".loc, progress: nil,
						duration: duration, notification: nil, isCompleted: false, createDate: Date(),
						updateDate: Date(), subtasks: [reading, writing, speaking, listening, words],
						parent: nil)

		return task
	}

	var reading: Task {
		let start = Date()
		let end = Calendar.current.date(byAdding: DateComponents(month: 4), to: start) ?? Date()
		let task = Task(title: "example_task_reading".loc,
						exposition: "example_task_reading_exposition".loc, progress: nil,
						duration: Task.Duration(start: start, end: end), notification: nil, isCompleted: false,
						createDate: Date(), updateDate: Date(), subtasks: [readingBook, readArticles], parent: nil)
		return task
	}

	var readingBook: Task {
		let task = Task(title: "example_task_reading_book".loc,
						exposition: "example_task_reading_book_exposition".loc,
						progress: Task.Progress(maxCount: 186, current: 91), duration: nil,
						notification: nil, isCompleted: false, createDate: Date(), updateDate: Date(),
						subtasks: [], parent: nil)
		return task
	}

	var readArticles: Task {
		let task = Task(title: "example_task_reading_article".loc,
						exposition: "example_task_reading_article_exposition".loc,
						progress: Task.Progress(maxCount: 10, current: 0), duration: nil,
						notification: nil, isCompleted: false, createDate: Date(), updateDate: Date(),
						subtasks: [], parent: nil)
		return task
	}

	var writing: Task {
		let task = Task(title: "example_task_writing".loc,
						exposition: "example_task_writing_exposition".loc, progress: nil,
						duration: nil, notification: nil, isCompleted: false,
						createDate: Date(), updateDate: Date(), subtasks: [writingPeople, writingBlog],
						parent: nil)
		return task
	}

	var writingPeople: Task {
		let task = Task(title: "example_task_writing_people".loc,
						exposition: "example_task_writing_people_exposition".loc,
						progress: Task.Progress(maxCount: 2, current: 0),
						duration: nil, notification: nil, isCompleted: false,
						createDate: Date(), updateDate: Date(), subtasks: [], parent: nil)
		return task
	}

	var writingBlog: Task {
		let base = Date()
		let start = Calendar.current.date(byAdding: DateComponents(month: 5), to: base) ?? Date()
		let end = Calendar.current.date(byAdding: DateComponents(month: 9), to: base) ?? Date()

		let task = Task(title: "example_task_writing_blog".loc,
						exposition: "example_task_writing_blog_exposition".loc,
						progress: nil, duration: Task.Duration(start: start, end: end), notification: nil,
						isCompleted: false, createDate: Date(), updateDate: Date(), subtasks: [], parent: nil)
		return task
	}

	var speaking: Task {
		let task = Task(title: "example_task_speaking".loc,
						exposition: nil, progress: nil,
						duration: nil, notification: nil, isCompleted: false,
						createDate: Date(), updateDate: Date(), subtasks: [discordSpeaking], parent: nil)
		return task
	}

	var discordSpeaking: Task {
		let task = Task(title: "example_task_speaking_discord".loc,
						exposition: "example_task_speaking_discord_exposition".loc,
						progress: Task.Progress(maxCount: 7, current: 2), duration: nil, notification: nil,
						isCompleted: false, createDate: Date(), updateDate: Date(), subtasks: [], parent: nil)
		return task
	}

	var listening: Task {
		let task = Task(title: "example_task_listening".loc,
						exposition: nil, progress: nil,
						duration: nil, notification: nil, isCompleted: true,
						createDate: Date(), updateDate: Date(), subtasks: [listeningPodcast, listeningYoutube], parent: nil)
		return task
	}

	var listeningPodcast: Task {
		let task = Task(title: "example_task_listening_podcast".loc,
						exposition: nil, progress: Task.Progress(maxCount: 8, current: 8),
						duration: nil, notification: nil, isCompleted: true, createDate: Date(),
						updateDate: Date(), subtasks: [], parent: nil)
		return task
	}

	var listeningYoutube: Task {
		let task = Task(title: "example_task_listening_youtibe".loc,
						exposition: nil, progress: Task.Progress(maxCount: 20, current: 20),
						duration: nil, notification: nil, isCompleted: true, createDate: Date(),
						updateDate: Date(), subtasks: [], parent: nil)
		return task
	}


	var words: Task {
		let task = Task(title: "example_task_word".loc,
						exposition: "example_task_word_exposition".loc,
						progress: Task.Progress(maxCount: 2000, current: 729), duration: nil,
						notification: nil, isCompleted: false, createDate: Date(), updateDate: Date(),
						subtasks: [], parent: nil)
		return task
	}
}
