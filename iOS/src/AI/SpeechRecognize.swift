//
//  SpeechRecognize.swift
//  iOS
//
//  Created by R on 01.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import AVFoundation
import Speech

@available(iOS 10.0, *)
final public class SpeechRecognize {
    
    public enum Error: Swift.Error {
        case unavailable
        case unauthorized
        case unrecognized
        case startFailed
    }

    public enum Result {
        case start
        case stop
        case recognized(String)
        case error(Error)
    }

    public typealias ResultClosure = (_ result: Result) -> Void

    private var speechRecognizer: SFSpeechRecognizer!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    private let audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechResult: SFSpeechRecognitionResult?
    private var previousText: String = ""
    private var onRecognize: ResultClosure?

    public private(set) static var isRecognizing = false
    public static var isCheckAvailability = false

    public var text: String {
        get {
            let text = speechResult?.bestTranscription.formattedString ?? ""
            return previousText + (previousText.count > 0 && text.count > 0 ? " " + text : text)
        }
    }
    public var language: String {
        get {
            return Locale.current.languageCode!
        }
        set {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: newValue))
        }
    }

    
    public init(language: String? = nil, recognize: ResultClosure? = nil) {
        onRecognize = recognize
        speechRecognizer = SFSpeechRecognizer(locale: language != nil ? Locale(identifier: language!) : Locale.current)
        if speechRecognizer == nil
            && language != nil {
            speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
            if speechRecognizer == nil {
                recognize?(.error(.unavailable))
            }
        }
    }
    
    public func start() {
        previousText = ""
        speechResult = nil
        
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                if status == .authorized {
                    if !SpeechRecognize.isCheckAvailability
                        || self?.speechRecognizer.isAvailable == true {
                        self?.onRecognize?(.start)
                        self?.recognize()
                    } else {
                        self?.onRecognize?(.error(.unavailable))
                    }
                } else {
                    self?.onRecognize?(.error(.unauthorized))
                }
            }
        }
    }
    
    public func recognize() {
        do {
            if audioEngine.isRunning {
                stop()
            }
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .measurement, options: [.mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            
            recognitionRequest.shouldReportPartialResults = true
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                
                DispatchQueue.main.async {
                    if result != nil {
                        if result!.isFinal == true {
                            self?.previousText = self!.text
                            self?.recognize()
                        } else {
                            self?.speechResult = result
                            self?.onRecognize?(.recognized(result!.bestTranscription.formattedString))
                        }
                    }
                    
                    if error != nil
                        && self?.recognitionTask != nil {
                        self?.stop()
                        self?.onRecognize?(.error(.unrecognized))
                    }
                }
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self?.recognitionRequest.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            SpeechRecognize.isRecognizing = true
        } catch {
            self.onRecognize?(.error(.startFailed))
        }
    }
    
    public func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        if recognitionTask != nil {
            recognitionTask!.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default, options: [.mixWithOthers])
        } catch {}
        SpeechRecognize.isRecognizing = false
        self.onRecognize?(.stop)
    }
}
