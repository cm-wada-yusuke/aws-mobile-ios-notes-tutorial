//
//  AWSAnalyticsService.swift
//  MyNotes
//
//  Created by wada.yusuke on 2018/12/19.
//  Copyright © 2018 Hall, Adrian. All rights reserved.
//

import Foundation
import AWSCore
import AWSPinpoint

class AWSAnalyticsService : AnalyticsService {
    var pinpoint: AWSPinpoint?
    
    init() {
        let config = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil)
        pinpoint = AWSPinpoint(configuration: config)
    }
    
    func recordEvent(_ eventName: String, parameters: [String : String]?, metrics: [String : Double]?) {
        let event = pinpoint?.analyticsClient.createEvent(withEventType: eventName)
        if (parameters != nil) {
            for (key, value) in parameters! {
                event?.addAttribute(value, forKey: key)
            }
        }
        if (metrics != nil) {
            for (key, value) in metrics! {
                event?.addMetric(NSNumber(value: value), forKey: key)
            }
        }
        pinpoint?.analyticsClient.record(event!)
        pinpoint?.analyticsClient.submitEvents()
        print("send analytics: \(eventName)")
    }

    func registerDevice(_ deviceToken: Data) {
        pinpoint?.notificationManager.interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("deviceToken: \(token)")
    }
}

