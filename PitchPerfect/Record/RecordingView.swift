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
                VStack {
                    Spacer()
                    RecordButton(uiModel: self.uiModel, geometry: geometry)
                    Text(self.uiModel.labelName)
                    NavigationLink(destination: PlayerView().environmentObject(self.audioGlobalContext), isActive: self.$uiModel.fireNavigation) {
                        StopRecordingButton(uiModel: self.uiModel, geometry: geometry)
                    }.disabled(self.uiModel.isDisabledStopButton)
                    Spacer()
                }.padding(16)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .navigationBarTitle(self.uiModel.navigationBarTitle)
                    .alert(isPresented: self.$uiModel.showingAlert) {
                        Alert(title: Text(self.uiModel.alertTitle), message: Text(self.uiModel.alertMessage), dismissButton: .default(Text(self.uiModel.alertDismissText)))
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
    
    func getIsLandscape(geometry: GeometryProxy) -> Bool {
        return geometry.size.width > geometry.size.height
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.updateStateTo(on: .RECORDING)
            self.audioGlobalContext.fileURL = self.uiModel.fileURL
        }){
            if self.getIsLandscape(geometry: self.geometry) {
                image.frame(width: (geometry.size.height - 32) * 0.46, height: (geometry.size.height - 32) * 0.46)
            } else {
                image.frame(width: (geometry.size.width - 32) * 0.46, height: (geometry.size.width - 32) * 0.46)
            }
        }.disabled(self.uiModel.isDisabledRecordButton)
    }
    
    var image: some View  {
        Image("Record")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct StopRecordingButton: View {
    private var uiModel : RecordingUiModel
    private var geometry : GeometryProxy
    
    init(uiModel: RecordingUiModel, geometry: GeometryProxy){
        self.geometry = geometry
        self.uiModel = uiModel
    }
    
    func getIsLandscape(geometry: GeometryProxy) -> Bool {
        return geometry.size.width > geometry.size.height
    }
    
    var body: some View {
        Button(action: {
            self.uiModel.updateStateTo(on: .STOPPED)
        }) {
            if self.getIsLandscape(geometry: self.geometry) {
                image.frame(width: (geometry.size.height - 32) * 0.26, height: (geometry.size.height - 32) * 0.26)
            } else {
                image.frame(width: (geometry.size.width - 32) * 0.26, height: (geometry.size.width - 32) * 0.26)
            }
            
        }.disabled(self.uiModel.isDisabledStopButton)
    }
    
    var image: some View  {
        Image("Stop")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView().environmentObject(AudioGlobalContext())
    }
}

//Force phones to always work on stack mode,
extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
