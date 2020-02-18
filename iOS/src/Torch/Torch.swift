//
//  Torch.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import AVFoundation

final public class Torch {

    public private(set) static var isBlinking = false
    
    private static let queue = DispatchQueue(label: "torch")
    
    public enum State {
        case on(TimeInterval, Float)
        case off(TimeInterval)
    }
    
    public static var isOn: Bool {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return false
        }
        return device.hasTorch
    }
    
    // MARK: - On & Off
    
    public static func on(level: Float = 1.0) {
        on(level: level, isBlink: false)
    }
    
    private static func on(level: Float = 1.0, isBlink: Bool) {
        if !isBlink {
            isBlinking = false
        }
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: level)
            device.unlockForConfiguration()
        } catch {
            Log.debug("torch", error)
        }
    }
    
    public static func off() {
        off(isBlink: false)
    }
    
    private static func off(isBlink: Bool) {
        if !isBlink {
            isBlinking = false
        }
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
        } catch {
            Log.debug("torch", error)
        }
    }
    
    public static func toggle() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        if device.hasTorch {
            on()
        } else {
            off()
        }
    }
    
    // MARK: - Blink
    
    public static func blink(interval: TimeInterval = 0.3) {
        blink(pattern: [.on(interval, 1), .off(interval)], isRepeat: true)
    }
    
    public static func blink(pattern: [State], isRepeat: Bool = false) {
        if pattern.count > 0 {
            queue.async {
                isBlinking = true
                blink(pattern: pattern, isRepeat: isRepeat, index: 0)
            }
        }
    }
    
    private static func blink(pattern: [State], isRepeat: Bool = false, index: Int) {
        var duration: TimeInterval = 0
        switch pattern[index] {
        case .on(let interval, let level):
            on(level: level, isBlink: true)
            duration = interval
        case .off(let interval):
            off(isBlink: true)
            duration = interval
        }
        usleep(UInt32(duration * 1_000_000))
        if !isBlinking { return }
        if index < pattern.count - 1 {
            blink(pattern: pattern, isRepeat: isRepeat, index: index + 1)
        } else if isRepeat {
            blink(pattern: pattern, isRepeat: isRepeat, index: 0)
        } else {
            off()
            isBlinking = false
        }
    }

    // MARK: - Morse
    
    public enum MorseCode {
        case dot
        case dash
    }

    public enum MorseSpecial {
        case start
        case end
        case error
        case wait
        case invitation
        case understood
        case newPage
    }
    
    public static var morseSpecialCode: [MorseSpecial: [MorseCode]] = [
        .start: [.dash, .dot, .dash, .dot, .dash],
        .end: [.dot, .dot, .dot, .dash, .dot, .dash],
        .error: [.dot, .dot, .dot, .dot, .dot, .dot, .dot, .dot],
        .wait: [.dot, .dash, .dot, .dot, .dot],
        .invitation: [.dash, .dot, .dash],
        .understood: [.dot, .dot, .dot, .dash, .dot],
        .newPage: [.dot, .dash, .dot, .dash, .dot]
    ]

    public static var morseCode: [[String]: [MorseCode]] = [
        ["A", "А"]: [.dot, .dash],
        ["B", "Б"]: [.dash, .dot, .dot, .dot],
        ["C", "Ц"]: [.dash, .dot, .dash, .dot],
        ["D", "Д"]: [.dash, .dot, .dot],
        ["E", "Е", "Ё"]: [.dot],
        ["F", "Ф"]: [.dot, .dot, .dash, .dot],
        ["G", "Г"]: [.dash, .dash, .dot],
        ["H", "Х"]: [.dot, .dot, .dot, .dot],
        ["I", "И"]: [.dot, .dot],
        ["J", "Й"]: [.dot, .dash, .dash, .dash],
        ["K", "К"]: [.dash, .dot, .dash],
        ["L", "Л"]: [.dot, .dash, .dot, .dot],
        ["M", "М"]: [.dash, .dash],
        ["N", "Н"]: [.dash, .dot],
        ["O", "О"]: [.dash, .dash, .dash],
        ["P", "П"]: [.dot, .dash, .dash, .dot],
        ["Q", "Щ"]: [.dash, .dash, .dot, .dash],
        ["R", "P"]: [.dot, .dash, .dot],
        ["S", "С"]: [.dot, .dot, .dot],
        ["T", "Т"]: [.dash],
        ["U", "У"]: [.dot, .dot, .dash],
        ["V", "Ж"]: [.dot, .dot, .dot, .dash],
        ["W", "В"]: [.dot, .dash, .dash],
        ["X", "Ь"]: [.dash, .dot, .dot, .dash],
        ["Y", "Ы"]: [.dash, .dot, .dash, .dash],
        ["Z", "З"]: [.dash, .dash, .dot, .dot],
        ["0"]: [.dash, .dash, .dash, .dash, .dash],
        ["1"]: [.dot, .dash, .dash, .dash, .dash],
        ["2"]: [.dot, .dot, .dash, .dash, .dash],
        ["3"]: [.dot, .dot, .dot, .dash, .dash],
        ["4"]: [.dot, .dot, .dot, .dot, .dash],
        ["5"]: [.dot, .dot, .dot, .dot, .dot],
        ["6"]: [.dash, .dot, .dot, .dot, .dot],
        ["7"]: [.dash, .dash, .dot, .dot, .dot],
        ["8"]: [.dash, .dash, .dash, .dot, .dot],
        ["9"]: [.dash, .dash, .dash, .dash, .dash],
        ["Ö", "Ч"]: [.dash, .dash, .dash, .dot],
        ["Ш"]: [.dash, .dash, .dash, .dash],
        ["É", "Э"]: [.dot, .dot, .dash, .dot, .dot],
        ["Ü", "Ю"]: [.dot, .dot, .dash, .dash],
        ["Ä", "Я"]: [.dot, .dash, .dot, .dash],
        ["."]: [.dot, .dot, .dot, .dot, .dot, .dot],
        [","]: [.dot, .dash, .dot, .dash, .dot, .dash],
        ["?"]: [.dot, .dot, .dash, .dash, .dot, .dot],
        ["'"]: [.dot, .dash, .dash, .dash, .dash, .dot],
        ["!"]: [.dash, .dot, .dash, .dot, .dash, .dash],
        ["/"]: [.dash, .dot, .dot, .dash, .dot],
        ["("]: [.dash, .dot, .dash, .dash, .dot],
        [")"]: [.dash, .dot, .dash, .dash, .dot, .dash],
        ["&"]: [.dot, .dash, .dot, .dot, .dot],
        [":"]: [.dash, .dash, .dash, .dot, .dot, .dot],
        [";"]: [.dash, .dot, .dash, .dot, .dash, .dot],
        ["="]: [.dash, .dot, .dot, .dot, .dash],
        ["+"]: [.dot, .dash, .dot, .dash, .dot],
        ["-"]: [.dash, .dot, .dot, .dot, .dot, .dash],
        ["_"]: [.dot, .dot, .dash, .dash, ],
        ["\""]: [.dot, .dash, .dot, .dot, .dash, .dot],
        ["$"]: [.dot, .dot, .dot, .dash, .dot, .dot, .dash],
        ["@"]: [.dot, .dash, .dash, .dot, .dash, .dot],
        ["À"]: [.dot, .dash, .dash, .dot, .dash],
        ["Å"]: [.dot, .dash, .dash, .dot, .dash],
        ["Ą"]: [.dot, .dash, .dot, .dash],
        ["Æ"]: [.dot, .dash, .dot, .dash],
        ["Ć"]: [.dash, .dot, .dash, .dot, .dot],
        ["Ĉ"]: [.dash, .dot, .dash, .dot, .dot],
        ["Ç"]: [.dash, .dot, .dash, .dot, .dot],
        ["Đ"]: [.dot, .dot, .dash, .dot, .dot],
        ["Ð"]: [.dot, .dot, .dash, .dash, .dot],
        ["È"]: [.dot, .dash, .dot, .dot, .dash],
        ["Ę"]: [.dot, .dot, .dash, .dot, .dot],
        ["Ĝ"]: [.dash, .dash, .dot, .dash, .dot],
        ["Ĥ"]: [.dash, .dash, .dash, .dash],
        ["Ĵ"]: [.dot, .dash, .dash, .dash, .dot],
        ["Ł"]: [.dot, .dash, .dot, .dot, .dash],
        ["Ń"]: [.dash, .dash, .dot, .dash, .dash],
        ["Ñ", "Ъ"]: [.dash, .dash, .dot, .dash, .dash],
        ["Ó"]: [.dash, .dash, .dash, .dot],
        ["Ø"]: [.dash, .dash, .dash, .dot],
        ["Ś"]: [.dot, .dot, .dot, .dash, .dot, .dot, .dot],
        ["Ŝ"]: [.dot, .dot, .dot, .dash, .dot],
        ["Š", "Ĥ", "Š"]: [.dash, .dash, .dash, .dash],
        ["Þ"]: [.dot, .dash, .dash, .dot, .dot],
        ["Ŭ"]: [.dot, .dot, .dash, .dash],
        ["Ź"]: [.dash, .dash, .dot, .dot, .dash, .dot],
        ["Ż"]: [.dash, .dash, .dot, .dot, .dash]
    ]
    
    public static func morse(_ special: MorseSpecial, dashDuration: TimeInterval = 0.3, level: Float = 1.0) {
        let dotDuration = dashDuration / 4
        var pattern: [State] = []
        morseSpecialCode[special]?.forEach {
            switch $0 {
            case .dot:
                pattern.append(.on(dotDuration, level))
            case .dash:
                pattern.append(.on(dashDuration, level))
            }
            pattern.append(.off(dotDuration))
        }
        pattern.append(.off(dashDuration))
        blink(pattern: pattern)
    }

    public static func morse(_ text: String, isRepeat: Bool = false, dashDuration: TimeInterval = 0.3, level: Float = 1.0) {
        let dotDuration = dashDuration / 4
        var pattern: [State] = []
        text.uppercased().forEach {
            for (letters, code) in morseCode {
                if (letters.contains("\($0)")) {
                    code.forEach {
                        switch $0 {
                        case .dot:
                            pattern.append(.on(dotDuration, level))
                        case .dash:
                            pattern.append(.on(dashDuration, level))
                        }
                        pattern.append(.off(dotDuration))
                    }
                    pattern.append(.off(dashDuration))
                }
            }
        }
        blink(pattern: pattern, isRepeat: isRepeat)
    }
    
    // MARK: - Builder
    
    public init() {}

    @discardableResult
    public func on(level: Float = 1.0) -> Self {
        Torch.on(level: level)
        return self
    }
    
    @discardableResult
    public func off() -> Self {
        Torch.off()
        return self
    }
    
    @discardableResult
    public func toggle() -> Self {
        Torch.toggle()
        return self
    }

    @discardableResult
    public func blink() -> Self {
        Torch.blink()
        return self
    }
    
    @discardableResult
    public func blink(pattern: [State], isRepeat: Bool = false) -> Self {
        Torch.blink(pattern: pattern, isRepeat: isRepeat)
        return self
    }
    
    @discardableResult
    public func morse(_ special: MorseSpecial, dashDuration: TimeInterval = 0.3, level: Float = 1.0) -> Self {
        Torch.morse(special, dashDuration: dashDuration, level: level)
        return self
    }
    
    @discardableResult
    public func morse(_ text: String, isRepeat: Bool = false, dashDuration: TimeInterval = 0.3, level: Float = 1.0) -> Self {
        Torch.morse(text, isRepeat: isRepeat, dashDuration: dashDuration, level: level)
        return self
    }
}
