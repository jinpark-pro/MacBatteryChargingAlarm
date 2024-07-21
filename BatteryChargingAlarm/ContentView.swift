//
//  ContentView.swift
//  BatteryChargingAlarm
//
//  Created by Jungjin Park on 2024-07-21.
//

import SwiftUI

struct ContentView: View {
    @State private var isMonitoring = false
    @State private var batteryNotifier: BatteryNotifier?
    
    var body: some View {
        VStack {
            Button(action: {
                if isMonitoring {
                    // monitoring stop
                    batteryNotifier?.stopMonitoring()
                    batteryNotifier = nil
                } else {
                    // monitoring start
                    batteryNotifier = BatteryNotifier()
                    batteryNotifier?.startMonitoring()
                }
                isMonitoring.toggle()
            }) {
                Text(isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(width: 300, height: 200)
        .padding()
    }
}

#Preview {
    ContentView()
}
