//
//  PlayerViewModel.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/26/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioListener: class {
    func onAudioSavedOnSystem()
    func onAudioProblemSaving()
}

class RecordingUiModelAudio : NSObject, AVAudioRecorderDelegate {
    
    let audioFileName = "recordedVoice.wav"
    var audioRecorder: AVAudioRecorder!
    weak var audioListener: AudioListener? = nil
    
    //MARK: Prepare Audio Logic.
    func prepareAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]  as String
        let recordingName = audioFileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                                 mode: AVAudioSession.Mode.default,
                                 options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopAudioRecording() {
        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    // Audio Recorder delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if flag {
            audioListener?.onAudioSavedOnSystem()
        } else {
            audioListener?.onAudioProblemSaving()
        }
    }
}
