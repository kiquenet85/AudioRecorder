//
//  RecordingModel.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/25/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

class RecordingUiModel : ObservableObject {
    
    //audio
    let audioFileName = "recordedVoice.wav"
    let navigationBarTitle = "Learning SwiftUI"
    
    //Recording state
    enum RecordingState: String {
        case STARTED = "Tap to Record"
        case RECORDING = "Recording in progress."
        case STOPPED = "Tap to record again."
    }
    
    var recordState : RecordingState
    
    //Values to observe by the view
    @Published var labelName : String
    @Published var isDisabledRecordButton : Bool
    @Published var isDisabledStopButton : Bool
    
    init() {
        recordState = RecordingState.STARTED
        isDisabledRecordButton = false
        isDisabledStopButton = true
        labelName = recordState.rawValue
    }
    
    func updateStateTo(on recordingState: RecordingState) {
        switch recordingState {
        case .STARTED:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = false
            self.isDisabledStopButton = true
        case .RECORDING:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = true
            self.isDisabledStopButton = false
        case .STOPPED:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = false
            self.isDisabledStopButton = true
        }
    }
}
