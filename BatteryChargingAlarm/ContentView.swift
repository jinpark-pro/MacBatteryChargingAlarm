//
//  ContentView.swift
//  BatteryChargingAlarm
//
//  Created by Jungjin Park on 2024-07-21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var batteryNotifier =  BatteryNotifier()
    
    var body: some View {
        VStack {
            if batteryNotifier.isMonitoring {
                Text("Monitoring Battery Charging")
                    .foregroundStyle(.green)
            } else {
                Text("Monitoring Stop")
                    .foregroundStyle(.red)
            }
            Button(action: {
                if batteryNotifier.isMonitoring {
                    // monitoring stop
                    batteryNotifier.stopMonitoring()
                } else {
                    // monitoring start
                    batteryNotifier.startMonitoring()
                }
            }) {
                Text(batteryNotifier.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
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
