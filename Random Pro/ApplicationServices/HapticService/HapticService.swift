//
//  HapticService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import CoreHaptics

protocol HapticService {
  
  /// Запустить обратную связь от моторчика
  /// - Parameters:
  ///  - isRepeat: Повтор
  ///  - patternType: Шаблон вибрации
  ///  - completion: Результат завершения
  func play(isRepeat: Bool,
            patternType: HapticServiceImpl.PatternType,
            completion: (Result<Void, HapticServiceImpl.HapticError>) -> Void)
  
  /// Остановить обратную связь от моторчика
  func stop()
}

final class HapticServiceImpl: HapticService {
  
  /// Ошибки запуска обратной связи от моторчика
  enum HapticError: Error {
    
    /// Обратную связь от моторчика не поддерживается
    case notSupported
    
    /// Не получилось создать Обратную связь
    case hapticEngineCreationError(Error)
    
    /// Ошибка воспроизведения
    case failedToPlay(Error)
    
    /// Ошибка создания шаблона
    case failedCreationPattern(Error)
  }
  
  /// Шаблоны запуска обратной связи от моторчика
  enum PatternType {
    
    /// Два тактильных события
    case slice
    
    /// Кормление крокодила
    case feedingCrocodile
    
    /// Всплеск
    case splash
  }
  
  // MARK: - Private property
  
  private var hapticEngine: CHHapticEngine?
  private let hapticCapability = CHHapticEngine.capabilitiesForHardware()
  private var isStopHaptic = false
  
  // MARK: - Internal property
  
  func play(isRepeat: Bool,
            patternType: PatternType,
            completion: (Result<Void, HapticError>) -> Void) {
    isStopHaptic = false
    createHapticEngine { [weak self] createResult in
      switch createResult {
      case .success:
        getPatternFrom(patternType: patternType) { [weak self] patternResult in
          switch patternResult {
          case let .success(pattern):
            playPattern(pattern, isRepeat: isRepeat) { [weak self] in
              if isRepeat && !(self?.isStopHaptic ?? true) {
                self?.play(isRepeat: isRepeat, patternType: patternType) { _ in }
              }
            } completion: { playResult in
              switch playResult {
              case .success:
                completion(.success(()))
              case let .failure(error):
                completion(.failure(error))
              }
            }
          case let .failure(error):
            completion(.failure(error))
          }
        }
      case let .failure(error):
        completion(.failure(error))
      }
    }
  }
  
  func stop() {
    isStopHaptic = true
    hapticEngine?.stop()
  }
}

// MARK: - Private

private extension HapticServiceImpl {
  func createHapticEngine(completion: (Result<Void, HapticError>) -> Void) {
    guard hapticCapability.supportsHaptics else {
      completion(.failure(.notSupported))
      return
    }
    
    if hapticEngine != nil {
      completion(.success(()))
      return
    }
    
    do {
      hapticEngine = try CHHapticEngine()
      hapticEngine?.isAutoShutdownEnabled = true
      completion(.success(()))
    } catch {
      completion(.failure(.hapticEngineCreationError(error)))
    }
  }
  
  func playPattern(_ pattern: CHHapticPattern,
                   isRepeat: Bool,
                   playersFinished: (() -> Void)?,
                   completion: (Result<Void, HapticError>) -> Void) {
    do {
      try hapticEngine?.start()
      let player = try hapticEngine?.makePlayer(with: pattern)
      try player?.start(atTime: CHHapticTimeImmediate)
      completion(.success(()))
      hapticEngine?.notifyWhenPlayersFinished { [weak self] _ in
        DispatchQueue.main.async {
          playersFinished?()
        }
        return isRepeat && !(self?.isStopHaptic ?? true) ? .leaveEngineRunning : .stopEngine
      }
    } catch {
      completion(.failure(.failedToPlay(error)))
    }
  }
  
  func getPatternFrom(patternType: PatternType,
                      completion: (Result<CHHapticPattern, HapticError>) -> Void) {
    switch patternType {
    case .slice:
      slicePattern { result in
        completion(result)
      }
    case .feedingCrocodile:
      feedingCrocodilePattern { result in
        completion(result)
      }
    case .splash:
      splashPattern { result in
        completion(result)
      }
    }
  }
}

// MARK: - Patterns

private extension HapticServiceImpl {
  func slicePattern(completion: (Result<CHHapticPattern, HapticError>) -> Void) {
    do {
      let slice = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.35),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
        ],
        relativeTime: .zero,
        duration: 0.25)
      
      let snip = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        ],
        relativeTime: 0.08)
      completion(.success(try CHHapticPattern(events: [slice, snip], parameters: [])))
    } catch {
      completion(.failure(.failedCreationPattern(error)))
    }
  }
  
  func feedingCrocodilePattern(completion: (Result<CHHapticPattern, HapticError>) -> Void) {
    do {
      let rumbleOne = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        ],
        relativeTime: 0,
        duration: 0.15)
      
      let rumbleTwo = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
        ],
        relativeTime: 0.3,
        duration: 0.3)
      
      let crunchOne = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        ],
        relativeTime: 0)
      
      let crunchTwo = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        ],
        relativeTime: 0.3)
      
      completion(.success(try CHHapticPattern(events: [rumbleOne,
                                                       rumbleTwo,
                                                       crunchOne,
                                                       crunchTwo],
                                              parameters: [])))
    } catch {
      completion(.failure(.failedCreationPattern(error)))
    }
  }
  
  func splashPattern(completion: (Result<CHHapticPattern, HapticError>) -> Void) {
    do {
      let splish = CHHapticEvent(
        eventType: .hapticTransient,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1),
          CHHapticEventParameter(parameterID: .attackTime, value: 0.1),
          CHHapticEventParameter(parameterID: .releaseTime, value: 0.2),
          CHHapticEventParameter(parameterID: .decayTime, value: 0.3)
        ],
        relativeTime: 0)
      
      let splash = CHHapticEvent(
        eventType: .hapticContinuous,
        parameters: [
          CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
          CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
        ],
        relativeTime: 0.1,
        duration: 0.6)
      
      let curve = CHHapticParameterCurve(
        parameterID: .hapticIntensityControl,
        controlPoints: [
          .init(relativeTime: 0, value: 0.2),
          .init(relativeTime: 0.08, value: 1.0),
          .init(relativeTime: 0.24, value: 0.2),
          .init(relativeTime: 0.34, value: 0.6),
          .init(relativeTime: 0.5, value: 0)
        ],
        relativeTime: 0)
      
      completion(.success(try CHHapticPattern(events: [splish,
                                                       splash],
                                              parameterCurves: [curve])))
    } catch {
      completion(.failure(.failedCreationPattern(error)))
    }
  }
}
