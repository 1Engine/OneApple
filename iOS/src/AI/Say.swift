//
//  Say.swift
//  iOS
//
//  Created by R on 01.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import AVFoundation
import Speech
import MediaPlayer

public extension AI {

    static var isSayEvents: Bool = false
    private static var synthesizer: AVSpeechSynthesizer?

    static func say(_ text: String, language: String? = nil, rate: Float = 0.45, volume: Float = 1.0, pitchMultiplier: Float = 1.1) {
        synthesizer?.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text.localized)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        utterance.volume = volume
        utterance.pitchMultiplier = pitchMultiplier
        synthesizer = AVSpeechSynthesizer()
        synthesizer!.pauseSpeaking(at: .word)
        synthesizer!.speak(utterance)
    }

}
