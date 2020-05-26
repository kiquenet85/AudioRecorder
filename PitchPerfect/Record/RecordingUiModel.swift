//
//  RecordingModel.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/25/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

class RecordingUiModel : ObservableObject, AudioListener {
    
    //Recording state
    enum RecordingState: String {
        case STARTED = "Tap to Record"
        case RECORDING = "Recording in progress."
        case STOPPED = "Tap to record again."
    }
    
    let navigationBarTitle = "Save your Audio"
    
    //audio
    var delegateAudio : RecordingUiModelAudio
    
    //recording state
    var recordState : RecordingState
    
    //Values to observe by the view
    @Published var fireNavigation = false
    @Published var labelName : String
    @Published var isDisabledRecordButton : Bool
    @Published var isDisabledStopButton : Bool
    
    init() {
        recordState = RecordingState.STARTED
        isDisabledRecordButton = false
        isDisabledStopButton = true
        labelName = recordState.rawValue
        
        delegateAudio = RecordingUiModelAudio()
        delegateAudio.audioListener = self
    }
    
    func updateStateTo(on recordingState: RecordingState) {
        switch recordingState {
        case .STARTED:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = false
            self.isDisabledStopButton = true
        case .RECORDING:
            delegateAudio.prepareAudio()
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = true
            self.isDisabledStopButton = false
        case .STOPPED:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = false
            self.isDisabledStopButton = true
            delegateAudio.stopAudioRecording()
        }
    }
    
    //Listener to know if Audio was saved
    func onAudioSavedOnSystem() {
        fireNavigation = true
    }
    
    func onAudioProblemSaving() {
        print("There was an error saving the audio file.")
    }
}
