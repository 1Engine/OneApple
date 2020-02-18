//
//  Sound.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import MediaPlayer

final public class Sound {

    public static func setVolume(_ value: Float) {
        let volumeView = MPVolumeView()
        if let view = volumeView.subviews.first as? UISlider {
            view.value = value
        }
    }
}
