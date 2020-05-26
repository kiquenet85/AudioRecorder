//
//  PlayerView.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/15/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    
    @ObservedObject var uiModel = PlayerUiModel()
    @EnvironmentObject var audioGlobalContext: AudioGlobalContext
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            ForEach(uiModel.imageFilenames, id: \.self) { buttonImageFileName in
                Group {
                    Spacer()
                    HStack {
                        Spacer()
                        ButtonSoundVariation(file: buttonImageFileName.left){
                            self.loadAudioFromGlobalContext()
                            self.uiModel.executeAction(using : buttonImageFileName.left)
                        }.disabled(self.uiModel.areButtonsVariationsDisabled)
                            .accentColor(self.buttonVariantsColor)
                        Spacer()
                        ButtonSoundVariation(file: buttonImageFileName.right){
                            self.loadAudioFromGlobalContext()
                            self.uiModel.executeAction(using : buttonImageFileName.right)
                        }.disabled(self.uiModel.areButtonsVariationsDisabled)
                            .accentColor(self.buttonVariantsColor)
                        Spacer()
                    }
                    Spacer()
                }
            }
            Spacer()
            ButtonStop(uiModel: uiModel)
                .disabled(self.uiModel.isDisabledStopButton)
                .accentColor(self.buttonStopColor)
            
            Spacer()
        }
    }
    
    var buttonVariantsColor: Color {
        return uiModel.areButtonsVariationsDisabled ? .gray : .clear
    }
    
    var buttonStopColor: Color {
        return uiModel.isDisabledStopButton ? .gray : .clear
    }
    
    func loadAudioFromGlobalContext(){
        self.uiModel.viewModel.recordedAudioURL = self.audioGlobalContext.fileURL
        self.uiModel.loadAudioFile()
    }
}

struct ButtonStop: View {
    private var buttonImageFileName: String
    private var uiModel : PlayerUiModel
    
    init(uiModel: PlayerUiModel){
        buttonImageFileName = uiModel.getStopButtonName()
        self.uiModel = uiModel
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.executeAction(using : self.buttonImageFileName)
        }) {
            Image("Stop")
                .renderingMode(.original)
                .resizable()
                .frame(width: 64, height: 64)
        }
    }
}

struct ButtonSoundVariation: View {
    private var buttonImageFileName: String
    private var customAction: () -> Void
    
    init(file imageName: String, action: @escaping () -> Void){
        self.buttonImageFileName = imageName
        self.customAction = action
    }
    
    var body: some View {
        Button(action: customAction){
            Image(buttonImageFileName)
                .renderingMode(.original)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
