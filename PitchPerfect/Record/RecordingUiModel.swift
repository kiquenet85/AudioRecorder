//
//  RecordingModel.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/25/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

class RecordingUiModel : ObservableObject, SaveAudioListener {
    
    //MARK: Recording state
    enum RecordingState: String {
        case STARTED = "Tap to Record"
        case RECORDING = "Recording in progress."
        case STOPPED = "Tap to record again."
    }
    
    //MARK: Constants adn variables
    let navigationBarTitle = "Save your Audio"
    
    //audio
    var delegateAudio : RecordingViewModel
    var fileURL : URL? = nil
    
    //recording state
    var recordState : RecordingState
    
    //MARK: Values to observe by the view
    @Published var fireNavigation = false
    @Published var labelName : String
    @Published var isDisabledRecordButton : Bool
    @Published var isDisabledStopButton : Bool
   
    // Alert varaiables
    @Published var showingAlert : Bool
    @Published var alertTitle : String
    @Published var alertMessage : String
    @Published var alertDismissText : String
    
    init() {
        recordState = RecordingState.STARTED
        isDisabledRecordButton = false
        isDisabledStopButton = true
        labelName = recordState.rawValue
        
        showingAlert = false
        alertTitle = "Error"
        alertMessage = "There was an error"
        alertDismissText = "Ok"
        
        delegateAudio = RecordingViewModel()
        delegateAudio.audioListener = self
    }
    
    func updateStateTo(on recordingState: RecordingState) {
        switch recordingState {
        case .STARTED:
            self.labelName = recordingState.rawValue
            self.isDisabledRecordButton = false
            self.isDisabledStopButton = true
        case .RECORDING:
            fileURL = delegateAudio.prepareAudio()
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
    
    func onAudioProblem(title: String, message: String) {
        print("There was an error saving the audio file.")
        showingAlert = true
        alertTitle = title
        alertMessage = message
    }
}
