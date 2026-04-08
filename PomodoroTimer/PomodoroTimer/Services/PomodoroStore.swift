//
//  PomodoroStore.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import Foundation

protocol PomodoroStoreProtocol {
    var sessions: [PomodoroSession] { get }
    var settings: PomodoroSettings { get }

    func addSession(mode: PomodoroMode, durationMinutes: Int, note: String) -> PomodoroSession
    func updateSession(id: String, mode: PomodoroMode, durationMinutes: Int, note: String)
    func deleteSession(id: String)
    func updateSettings(workMinutes: Int, shortBreakMinutes: Int, longBreakMinutes: Int)

    func countsByMode() -> [PomodoroMode: Int]
    func sessionsByDayAndMode() -> [String: [PomodoroMode: Int]]
}

final class PomodoroStore: PomodoroStoreProtocol {
    static let shared = PomodoroStore()

    private let defaults: UserDefaults
    private static let sessionsKey = "PomodoroTimer.sessions"
    private static let settingsKey = "PomodoroTimer.settings"

    private(set) var sessions: [PomodoroSession]
    private(set) var settings: PomodoroSettings

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.sessions = PomodoroStore.loadSessions(defaults: defaults)
        self.settings = PomodoroStore.loadSettings(defaults: defaults)
    }

    func addSession(mode: PomodoroMode, durationMinutes: Int, note: String) -> PomodoroSession {
        let session = PomodoroSession(
            id: UUID().uuidString,
            mode: mode,
            durationMinutes: durationMinutes,
            completedAt: Date(),
            note: note
        )
        sessions.insert(session, at: 0)
        saveSessions()
        notifySessionsChanged()
        return session
    }

    func updateSession(id: String, mode: PomodoroMode, durationMinutes: Int, note: String) {
        guard let index = sessions.firstIndex(where: { $0.id == id }) else { return }
        let current = sessions[index]
        sessions[index] = PomodoroSession(
            id: current.id,
            mode: mode,
            durationMinutes: durationMinutes,
            completedAt: current.completedAt,
            note: note
        )
        saveSessions()
        notifySessionsChanged()
    }

    func deleteSession(id: String) {
        guard let index = sessions.firstIndex(where: { $0.id == id }) else { return }
        sessions.remove(at: index)
        saveSessions()
        notifySessionsChanged()
    }

    func updateSettings(workMinutes: Int, shortBreakMinutes: Int, longBreakMinutes: Int) {
        settings = PomodoroSettings(workMinutes: workMinutes, shortBreakMinutes: shortBreakMinutes, longBreakMinutes: longBreakMinutes)
        saveSettings()
        NotificationCenter.default.post(name: PomodoroNotifications.settingsDidChange, object: nil)
    }

    func countsByMode() -> [PomodoroMode: Int] {
        var counts: [PomodoroMode: Int] = [:]
        for session in sessions {
            counts[session.mode, default: 0] += 1
        }
        return counts
    }

    func sessionsByDayAndMode() -> [String: [PomodoroMode: Int]] {
        var result: [String: [PomodoroMode: Int]] = [:]
        for session in sessions {
            let dayKey = session.completedAt.pomodoroDayKey()
            var dayMap = result[dayKey, default: [:]]
            dayMap[session.mode, default: 0] += 1
            result[dayKey] = dayMap
        }
        return result
    }

    private func saveSessions() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        defaults.set(data, forKey: PomodoroStore.sessionsKey)
    }

    private func saveSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: PomodoroStore.settingsKey)
    }

    private func notifySessionsChanged() {
        NotificationCenter.default.post(name: PomodoroNotifications.sessionsDidChange, object: nil)
    }

    private static func loadSessions(defaults: UserDefaults) -> [PomodoroSession] {
        if let data = defaults.data(forKey: PomodoroStore.sessionsKey),
           let stored = try? JSONDecoder().decode([PomodoroSession].self, from: data) {
            return stored
        }
        return []
    }

    private static func loadSettings(defaults: UserDefaults) -> PomodoroSettings {
        if let data = defaults.data(forKey: PomodoroStore.settingsKey),
           let stored = try? JSONDecoder().decode(PomodoroSettings.self, from: data) {
            return stored
        }
        return PomodoroSettings.defaultValue
    }
}
