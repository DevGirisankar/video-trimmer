//
//  TrimHelper.swift
//  VideoTrimmer
//
//  Created by Giri on 12/10/21.
//

import Foundation
import Photos
import AssetsLibrary
import CoreMedia
import MobileCoreServices
import UIKit

extension VideoTrimmerViewController {
    //Trim Video Function
    func cropVideo(asset:AVAsset, startTime:CMTime, endTime:CMTime,completion:  @escaping  (Bool) -> ()) {
        let manager = FileManager.default
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true) else {completion(false);return}
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("trimmed.mp4")
        } catch let error {
            print(error)
            completion(false)
        }
        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                self.saveToCameraRoll(url: outputURL, completion:{ status in
                    completion(status)
                })
            case .failed:
                completion(false)
                print("failed \(String(describing: exportSession.error))")
            case .cancelled:
                completion(false)
                print("cancelled \(String(describing: exportSession.error))")
            default:
                completion(false)
            }
        }
    }
    //Save Video to Photos Library
    func saveToCameraRoll(url:URL,completion:  @escaping  (Bool) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, _ in
            completion(saved)
        }
    }
}
extension TimeInterval {
    var positionalTime: String {
        guard !self.isNaN else {return "00:00"}
        Formatter.positional.allowedUnits = self >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        let string = Formatter.positional.string(from: self)!
        return string.hasPrefix("0") && string.count > 4 ? .init(string.dropFirst()) : string
    }
}
extension Formatter {
    static let positional: DateComponentsFormatter = {
        let positional = DateComponentsFormatter()
        positional.unitsStyle = .positional
        positional.zeroFormattingBehavior = .pad
        return positional
    }()
}
extension UIButton {
    func loadingIndicator(_ show: Bool,color:UIColor = .white) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            indicator.color = color
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
