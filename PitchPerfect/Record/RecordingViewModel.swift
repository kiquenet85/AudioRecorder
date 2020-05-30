//
//  PlayerViewModel.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/26/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation
import AVFoundation

protocol SaveAudioListener: class {
    func onAudioSavedOnSystem()
    func onAudioProblem(title: String, message:String)
}

class RecordingViewModel : NSObject, AVAudioRecorderDelegate {
    
    //MARK: alerts error title and messages
    struct Alerts {
        static let errorSavingFileTitle = "Problem saving audio file."
        static let errorSavingFileMessage = "There was a problem saving the audio file \(RecordingViewModel.audioFileName)"
        
        static let errorStoppingFileTitle = "Problem stopping audio file."
        static let errorStoppingFileMessage = "There was a stopping saving the audio file \(RecordingViewModel.audioFileName)"
        
        static let errorAudioFilePathTitle = "Problem on path file"
        static let errorAudioFilePathMessage = "There was a problem on path file and settings."
        
        static let errorAudioSessionTitle = "Problem on Audio Session"
        static let errorAudioSessionMessage = "There was a problem opening recording audio session."
    }
    
    static let audioFileName = "recordedVoice.wav"
    var audioRecorder: AVAudioRecorder!
    weak var audioListener: SaveAudioListener? = nil
    
    //MARK: Prepare Audio Logic.
    func prepareAudio() -> URL? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]  as String
        let recordingName = RecordingViewModel.audioFileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord,
                                    mode: AVAudioSession.Mode.default,
                                    options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch {
            showAlert(title: Alerts.errorAudioSessionTitle, message: Alerts.errorAudioSessionMessage)
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        } catch {
            showAlert(title: Alerts.errorAudioFilePathTitle, message: Alerts.errorAudioFilePathMessage)
        }
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        return filePath
    }
    
    func stopAudioRecording() {
        audioRecorder.stop()
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            showAlert(title: Alerts.errorStoppingFileTitle, message: Alerts.errorStoppingFileMessage)
        }
    }
    
    // Audio Recorder delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if flag {
            audioListener?.onAudioSavedOnSystem()
        } else {
            showAlert(title: Alerts.errorSavingFileTitle, message: Alerts.errorSavingFileMessage)
        }
    }
    
    func showAlert(title: String, message: String){
        print("There was an error \(title) with the message \(message)")
        audioListener?.onAudioProblem(title: title, message: message)
    }
}
