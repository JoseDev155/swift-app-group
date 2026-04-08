//
//  TimerViewModel.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

final class TimerViewModel {
    private let store: PomodoroStoreProtocol

    init(store: PomodoroStoreProtocol = PomodoroStore.shared) {
        self.store = store
    }

    var settings: PomodoroSettings {
        store.settings
    }

    func durationMinutes(for mode: PomodoroMode) -> Int {
        switch mode {
        case .work:
            return store.settings.workMinutes
        case .shortBreak:
            return store.settings.shortBreakMinutes
        case .longBreak:
            return store.settings.longBreakMinutes
        }
    }

    func addSession(mode: PomodoroMode, durationMinutes: Int, note: String) {
        _ = store.addSession(mode: mode, durationMinutes: durationMinutes, note: note)
    }
}
