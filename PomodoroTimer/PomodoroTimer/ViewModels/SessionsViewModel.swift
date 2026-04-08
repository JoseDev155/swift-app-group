//
//  SessionsViewModel.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class SessionsViewModel {
    private let store: PomodoroStoreProtocol

    init(store: PomodoroStoreProtocol = PomodoroStore.shared) {
        self.store = store
    }

    var sessions: [PomodoroSession] {
        store.sessions.sorted { $0.completedAt > $1.completedAt }
    }

    func session(at index: Int) -> PomodoroSession {
        sessions[index]
    }

    func addSession(mode: PomodoroMode, durationMinutes: Int, note: String) {
        _ = store.addSession(mode: mode, durationMinutes: durationMinutes, note: note)
    }

    func updateSession(id: String, mode: PomodoroMode, durationMinutes: Int, note: String) {
        store.updateSession(id: id, mode: mode, durationMinutes: durationMinutes, note: note)
    }

    func deleteSession(id: String) {
        store.deleteSession(id: id)
    }
}
