//
//  AI.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

final public class AI {

    private static var speechRecgnize: Any?
    
    @available(iOS 10.0, *)
    public static func recognizeSpeech(language: String? = nil, recognize: SpeechRecognize.ResultClosure? = nil) {
        speechRecgnize = SpeechRecognize(language: language, recognize: recognize)
        (speechRecgnize as! SpeechRecognize).start()
    }
    
    @available(iOS 10.0, *)
    public static func stopRecognizeSpeech() {
        (speechRecgnize as? SpeechRecognize)?.stop()
        speechRecgnize = nil
    }

}
