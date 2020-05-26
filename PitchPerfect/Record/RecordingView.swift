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
    @EnvironmentObject var audioGlobalContext: AudioGlobalContext
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView(.vertical) {
                    VStack {
                        RecordButton(uiModel: self.uiModel, geometry: geometry)
                        Text(self.uiModel.labelName)
                        NavigationLink(destination: PlayerView().environmentObject(self.audioGlobalContext), isActive: self.$uiModel.fireNavigation) {
                            StopRecordingButton(uiModel: self.uiModel, geometry: geometry)
                        }.disabled(self.uiModel.isDisabledStopButton)
                    }.padding(16)
                        .frame(width: geometry.size.width - 32, height: geometry.size.height - 32)
                        .navigationBarTitle(self.uiModel.navigationBarTitle)
                }
                
                //Default View on big screens.
                Text("Welcome to Audio Recorder")
            }
        }
    }
}

struct RecordButton: View {
    private var uiModel : RecordingUiModel
    private var geometry : GeometryProxy
    @EnvironmentObject var audioGlobalContext: AudioGlobalContext
    
    init(uiModel: RecordingUiModel, geometry: GeometryProxy){
        self.geometry = geometry
        self.uiModel = uiModel
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.updateStateTo(on: .RECORDING)
            self.audioGlobalContext.fileURL = self.uiModel.fileURL
        }){
            Image("Record")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width - 32) * 0.52, height: (geometry.size.height - 32) * 0.52)
        }.disabled(self.uiModel.isDisabledRecordButton)
    }
}

struct StopRecordingButton: View {
    private var uiModel : RecordingUiModel
    private var geometry : GeometryProxy
    
    init(uiModel: RecordingUiModel, geometry: GeometryProxy){
        self.geometry = geometry
        self.uiModel = uiModel
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.updateStateTo(on: .STOPPED)
        }) {
            Image("Stop")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: (geometry.size.width - 32) * 0.26, height: (geometry.size.height - 32) * 0.26)
        }.disabled(self.uiModel.isDisabledStopButton)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
