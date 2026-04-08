//
//  TimerViewController.swift
//  PomodoroTimer
//
//  Created by Jose Ramos on 7/4/26.
//

import UIKit

final class TimerViewController: UIViewController {
    private enum TimerState {
        case idle
        case running
        case paused
    }

    private let viewModel: TimerViewModel
    private let modeControl = UISegmentedControl(items: PomodoroMode.allCases.map { $0.title })
    private let ringView = ProgressRingView()
    private let timeLabel = UILabel()
    private let startButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let logButton = UIButton(type: .system)

    private var timer: Timer?
    private var state: TimerState = .idle
    private var currentMode: PomodoroMode = .work
    private var totalSeconds: Int = 0
    private var remainingSeconds: Int = 0

    init(viewModel: TimerViewModel = TimerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Temporizador"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        configureView()
        applyMode(.work)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChanged), name: PomodoroNotifications.settingsDidChange, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: PomodoroNotifications.settingsDidChange, object: nil)
    }

    private func configureView() {
        modeControl.selectedSegmentIndex = 0
        modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        modeControl.translatesAutoresizingMaskIntoConstraints = false

        ringView.translatesAutoresizingMaskIntoConstraints = false

        timeLabel.font = .monospacedDigitSystemFont(ofSize: 36, weight: .semibold)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        startButton.setTitle("Iniciar", for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        resetButton.setTitle("Reiniciar", for: .normal)
        resetButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        logButton.setTitle("Registrar", for: .normal)
        logButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        logButton.addTarget(self, action: #selector(logTapped), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [startButton, resetButton, logButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(modeControl)
        view.addSubview(ringView)
        view.addSubview(timeLabel)
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            modeControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            modeControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modeControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            ringView.topAnchor.constraint(equalTo: modeControl.bottomAnchor, constant: 24),
            ringView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            timeLabel.topAnchor.constraint(equalTo: ringView.bottomAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            buttonStack.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func applyMode(_ mode: PomodoroMode) {
        currentMode = mode
        totalSeconds = max(viewModel.durationMinutes(for: mode), 1) * 60
        if state == .idle {
            remainingSeconds = totalSeconds
            updateTimeLabel()
            ringView.setProgress(0, animated: false)
        }
    }

    private func updateTimeLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func currentProgress() -> CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return CGFloat(Double(totalSeconds - remainingSeconds) / Double(totalSeconds))
    }

    private func startTimer() {
        if remainingSeconds == 0 {
            remainingSeconds = totalSeconds
        }
        state = .running
        startButton.setTitle("Pausar", for: .normal)
        ringView.animateProgress(from: currentProgress(), to: 1, duration: TimeInterval(remainingSeconds))

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
        state = .paused
        startButton.setTitle("Reanudar", for: .normal)
        ringView.stopAnimation()
        ringView.setProgress(currentProgress(), animated: false)
    }

    private func stopTimer(resetProgress: Bool) {
        timer?.invalidate()
        timer = nil
        state = .idle
        startButton.setTitle("Iniciar", for: .normal)
        if resetProgress {
            ringView.stopAnimation()
            ringView.setProgress(0, animated: false)
        }
    }

    private func tick() {
        remainingSeconds = max(remainingSeconds - 1, 0)
        updateTimeLabel()
        if remainingSeconds == 0 {
            completeSession()
        }
    }

    private func completeSession() {
        stopTimer(resetProgress: false)
        ringView.setProgress(1, animated: false)
        ringView.pulse()
        viewModel.addSession(mode: currentMode, durationMinutes: totalSeconds / 60, note: "")
        presentStatusAlert(title: "Sesión completada", message: "Se registró la sesión en el historial.")
    }

    @objc private func startTapped() {
        switch state {
        case .idle, .paused:
            startTimer()
        case .running:
            pauseTimer()
        }
    }

    @objc private func resetTapped() {
        stopTimer(resetProgress: true)
        remainingSeconds = totalSeconds
        updateTimeLabel()
    }

    @objc private func logTapped() {
        let alert = UIAlertController(title: "Registrar sesión", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nota (opcional)"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let noteText = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.viewModel.addSession(mode: self.currentMode, durationMinutes: self.totalSeconds / 60, note: noteText)
            self.presentStatusAlert(title: "Sesión registrada", message: "Se agregó al historial.")
        }

        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    @objc private func modeChanged() {
        let selectedMode = PomodoroMode.allCases[modeControl.selectedSegmentIndex]
        if state == .running {
            let alert = UIAlertController(title: "Cambiar modo", message: "Esto reiniciará el temporizador.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { [weak self] _ in
                guard let self = self else { return }
                self.modeControl.selectedSegmentIndex = PomodoroMode.allCases.firstIndex(of: self.currentMode) ?? 0
            })
            alert.addAction(UIAlertAction(title: "Continuar", style: .destructive) { [weak self] _ in
                self?.stopTimer(resetProgress: true)
                self?.applyMode(selectedMode)
            })
            present(alert, animated: true)
            return
        }

        applyMode(selectedMode)
        remainingSeconds = totalSeconds
        updateTimeLabel()
    }

    @objc private func handleSettingsChanged() {
        if state == .idle {
            applyMode(currentMode)
        }
    }

    private func presentStatusAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
