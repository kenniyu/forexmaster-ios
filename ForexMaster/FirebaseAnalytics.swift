//
//  FirebaseAnalytics.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/21/16.
//  Copyright © 2016 ken. All rights reserved.
//

import Foundation

public struct FirebaseAnalytics {
    public struct EventKeys {
        public static let kPositionsScreenPageView = "positions_screen_pv"
        public static let kHistoryScreenPageView = "history_screen_pv"
        public static let kNotificationScreenPageView = "notification_screen_pv"
        public static let kPerformanceScreenPageView = "performance_screen_pv"
        public static let kSettingsScreenPageView = "settings_screen_pv"
        public static let kOpenedAppThroughPushNotification = "app_opened_via_push_notification"
        public static let kReceivedPushNotification = "app_received_push_notification"
        public static let kRegisteredForPushNotification = "register_push_success"
        public static let kFailedRegisterForPushNotification = "register_push_failure"
        public static let kAppTerminated = "app_terminated"
        public static let kAppDidBecomeActive = "app_active"
        public static let kAppEnteredForeground = "app_entered_foreground"
        public static let kAppEnteredBackground = "app_entered_background"
        public static let kFilteredHistory = "filtered_history"
    }
}
