//
//  PlayerViewUi.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/25/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import Foundation

//As touples seems to have problems to be iterated in SwiftUi.
struct HorizontalButtonNames<A, B> {
    var left: A
    var right: B
    init(_ one: A, _ two: B) {
        self.left = one
        self.right = two
    }
}
extension HorizontalButtonNames: Encodable where A: Encodable, B: Encodable { }
extension HorizontalButtonNames: Decodable where A: Decodable, B: Decodable { }
extension HorizontalButtonNames: Equatable where A: Equatable, B: Equatable { }
extension HorizontalButtonNames: Hashable where A: Hashable, B: Hashable { }


class PlayerUiModel : ObservableObject, AudioListener {
    
    //MARK: enums
    enum SoundButton: String {
           case SLOW = "Slow"
           case FAST = "Fast"
           case HIGH_PITCH = "HighPitch"
           case LOW_PITCH = "LowPitch"
           case ECHO = "Echo"
           case REVERB = "Reverb"
           case STOP = "Stop"
       }
    
    //MARK: Variables and constants
    var imageFilenames: [HorizontalButtonNames<String, String>]
    var viewModel : PlayerViewModel
    
    //MARK: Observerd UI variables
    @Published var areButtonsVariationsDisabled : Bool
    @Published var isDisabledStopButton : Bool
    
    // Alert varaiables
    @Published var showingAlert : Bool
    @Published var alertTitle : String
    @Published var alertMessage : String
    @Published var alertDismissText : String
    
    init() {
        imageFilenames = [HorizontalButtonNames( SoundButton.SLOW.rawValue, SoundButton.FAST.rawValue),
                          HorizontalButtonNames( SoundButton.HIGH_PITCH.rawValue, SoundButton.LOW_PITCH.rawValue),
                          HorizontalButtonNames( SoundButton.ECHO.rawValue, SoundButton.REVERB.rawValue)]
        
        areButtonsVariationsDisabled = false
        isDisabledStopButton = true
        
        showingAlert = false
        alertTitle = "Error"
        alertMessage = "There was an error"
        alertDismissText = "Ok"
        
        viewModel = PlayerViewModel()
        viewModel.audioListener = self
    }
    
    private func findButtonFromName(_ fileName: String) -> SoundButton {
        SoundButton(rawValue: fileName)!
    }
    
    func loadAudioFile(){
        viewModel.setupAudio()
    }
    
    func getStopButtonName() -> String{
        SoundButton.STOP.rawValue
    }
    
    func onAudioFinished() {
        areButtonsVariationsDisabled = false
        isDisabledStopButton = true
    }
    
    func onAudioPlayerProblem(title: String, message: String) {
         showingAlert = true
         alertTitle = title
         alertMessage = message
     }
    
    private func beforeAudioStarting() {
        areButtonsVariationsDisabled = true
        isDisabledStopButton = false
    }
    
    func executeAction(using buttonName: String){
        switch findButtonFromName(buttonName) {
        case .SLOW:
            print("s")
            beforeAudioStarting()
            viewModel.playSound(rate: 0.5)
        case .FAST:
            print("f")
            beforeAudioStarting()
            viewModel.playSound(rate: 1.5)
        case .HIGH_PITCH:
            print("hp")
            beforeAudioStarting()
            viewModel.playSound(pitch: 1000)
        case .LOW_PITCH:
            print("lp")
            beforeAudioStarting()
            viewModel.playSound(pitch: -1000)
        case .ECHO:
            print("e")
            beforeAudioStarting()
            viewModel.playSound(echo : true)
        case .REVERB:
            print("r")
            beforeAudioStarting()
            viewModel.playSound(reverb : true)
        case .STOP:
            print("stop")
            viewModel.stopAudio()
        }
    }
    
}
