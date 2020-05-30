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
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    Spacer()
                    ForEach(self.uiModel.imageFilenames, id: \.self) { buttonImageFileName in
                        Group {
                            Spacer()
                            HStack {
                                Spacer()
                                ButtonSoundVariation(geometry: geometry, file: buttonImageFileName.left){
                                    self.loadAudioFromGlobalContext()
                                    self.uiModel.executeAction(using : buttonImageFileName.left)
                                }.disabled(self.uiModel.areButtonsVariationsDisabled)
                                    .accentColor(self.buttonVariantsColor)
                                Spacer()
                                ButtonSoundVariation(geometry: geometry, file: buttonImageFileName.right){
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
                    ButtonStop(uiModel: self.uiModel, geometry: geometry)
                        .disabled(self.uiModel.isDisabledStopButton)
                        .accentColor(self.buttonStopColor)
                    Spacer()
                }.padding(16)
                    .frame(width: geometry.size.width - 32, height: geometry.size.height - 32)
                .alert(isPresented: self.$uiModel.showingAlert) {
                    Alert(title: Text(self.uiModel.alertTitle), message: Text(self.uiModel.alertMessage), dismissButton: .default(Text(self.uiModel.alertDismissText)))
                }
            }
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
    private var geometry : GeometryProxy
    
    init(uiModel: PlayerUiModel, geometry: GeometryProxy){
        buttonImageFileName = uiModel.getStopButtonName()
        self.uiModel = uiModel
        self.geometry = geometry
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.executeAction(using : self.buttonImageFileName)
        }) {
            Image("Stop")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width - 32) * 0.171, height: (geometry.size.height - 32) * 0.171)
        }
    }
}

struct ButtonSoundVariation: View {
    private var buttonImageFileName: String
    private var customAction: () -> Void
    private var geometry : GeometryProxy
    
    init(geometry: GeometryProxy, file imageName: String, action: @escaping () -> Void){
        self.buttonImageFileName = imageName
        self.customAction = action
        self.geometry = geometry
    }
    
    var body: some View {
        Button(action: customAction){
            Image(buttonImageFileName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width - 32) * 0.26, height: (geometry.size.height - 32) * 0.26)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
