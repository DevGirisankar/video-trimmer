//
//  AVPlayer+isPlaying.swift
//  VideoTrimmer
//
//  Created by Giri on 12/10/21.
//

import Foundation
import AVFoundation
extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
