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
    
    var body: some View {
        VStack {
            ForEach(uiModel.imageFilenames, id: \.self) { buttonImageFileName in
                Group {
                    Spacer()
                    HStack {
                        Spacer()
                        ButtonSoundVariation(file: buttonImageFileName.left){
                            self.uiModel.executeAction(using : buttonImageFileName.left)
                        }
                        Spacer()
                        ButtonSoundVariation(file: buttonImageFileName.right){
                            self.uiModel.executeAction(using : buttonImageFileName.right)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            Spacer()
            ButtonStop(uiModel: uiModel)
            Spacer()
        }
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
