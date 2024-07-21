//
//  BatteryNotifier.swift
//  BatteryChargingAlarm
//
//  Created by Jungjin Park on 2024-07-21.
//

import Cocoa
import IOKit.ps
import UserNotifications

class BatteryNotifier {
    var timer: Timer?
    
    init() {
        requestNotificationPermission()
    }
    
    func startMonitoring() {
        // check battery every 1 minute
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(checkBatteryStatus), userInfo: nil, repeats: true)
    }
    
    func stopMonitoring() {
        // stop timer
        timer?.invalidate()
        timer = nil
    }
    
    @objc func checkBatteryStatus() {
        print("Check")
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        if let source = sources.first {
            if let info = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as? [String: Any] {
                if let currentCapacity = info[kIOPSCurrentCapacityKey] as? Int, let maxCapacity = info[kIOPSMaxCapacityKey] as? Int, let isCharging = info[kIOPSIsChargingKey] as? Bool {
                    if isCharging {
                        print("charging")
                        let batteryLevel = (Double(currentCapacity) / Double(maxCapacity)) * 100
                        if batteryLevel >= 80 {
                            sendNotification()
                        }
                    } else {
                        print("no charging")
                        sendNotification()
//                        stopMonitoring()
                    }
                }
            }
        }
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Battery Alert"
        content.body = "Battery level has reached 80%."
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
        })
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
