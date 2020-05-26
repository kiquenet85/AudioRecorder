//
//  ContentView.swift
//  PitchPerfect
//
//  Created by Nestor Diazgranados on 5/1/20.
//  Copyright © 2020 NesDupier. All rights reserved.
//

import SwiftUI

struct RecordingView: View {
    
    @ObservedObject var uiModel = RecordingUiModel()
    @State var navigationAction: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                recordButton
                Text(self.uiModel.labelName)
                NavigationLink(destination: PlayerView(), tag: 1, selection: $navigationAction) {
                    stopRecordingButton
                }.disabled(self.uiModel.isDisabledStopButton)
                .navigationBarTitle(uiModel.navigationBarTitle)
            }
        }
    }
    
    var recordButton: some View {
        Button(action: {
            self.uiModel.updateStateTo(on: .RECORDING)
        }){
            Image("Record")
                .renderingMode(.original)
        }.disabled(self.uiModel.isDisabledRecordButton)
    }
    
    var stopRecordingButton: some View {
        Button(action: {
            self.navigationAction = 1
            self.uiModel.updateStateTo(on: .STOPPED)
        }) {
            Image("Stop")
                .renderingMode(.original)
                .resizable()
                .frame(width: 100, height: 100)
        }.disabled(self.uiModel.isDisabledStopButton)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}
