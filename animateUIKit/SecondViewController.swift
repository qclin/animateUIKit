//
//  SecondViewController.swift
//  animateUIKit
//
//  Created by Qiao Lin on 3/3/17.
//  Copyright © 2017 Qiao Lin. All rights reserved.
//

import UIKit
import UserNotifications

class SecondViewController: UIViewController {
    struct Notification {
        
        struct Category {
            static let tutorial = "tutorial"
        }
        
        struct Action {
            static let readLater = "readLater"
            static let showDetails = "showDetails"
            static let unsubscribe = "unsubscribe"
            static let reply = "reply"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        configureUserNotificationsCenter()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapForNotification(_ sender: Any) {
        
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings{ (notificationSettings) in
            switch notificationSettings.authorizationStatus{
            case .notDetermined:
                self.requestAuthorization(completionHandler: {(success) in
                    guard success else { return }
                    // schedule local Notficationn
                    self.scheduleLocalNotification()
                })
            case .authorized:
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not allowed to dispaly notifications")
            }
        }
    }

    private func configureUserNotificationsCenter() {
        // Configure User Notification Center
        
        // Define Actions
        let actionReadLater = UNNotificationAction(identifier: Notification.Action.readLater, title: "Read Later", options: [])
        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.showDetails, title: "Show Details", options: [.foreground])
        let actionUnsubscribe = UNNotificationAction(identifier: Notification.Action.unsubscribe, title: "Unsubscribe", options: [.destructive, .authenticationRequired])
        
        let actionReply = UNTextInputNotificationAction(identifier: Notification.Action.reply, title: "Reply", options:[], textInputButtonTitle: "Send", textInputPlaceholder: "Type your message")
        
        // Define Category
        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionReadLater, actionShowDetails, actionUnsubscribe, actionReply], intentIdentifiers: [], options: [])
        
        // Register Category
        UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
    }
    
    
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("request authorization failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
            
        }
        
    }
    private func scheduleLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle"
        
        content.body = "Some notification body information to be displayed."
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        // set category identifier
        content.categoryIdentifier = Notification.Category.tutorial
        
        // add Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
        
/* 
    1- trigger by time intervals / depending on scheduled time, an hour from now
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0 * 60.0, repeats: false)
        
    2- trigger by calendar dates regardless of scheduled time / upcoming events/ appointments everyday at 10pm
        var date = DateComponents()
        date.hour = 22
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

    3- trigger by location whenever user enters a geographical region, like a weather forecast/ local news

        let center = CLLocationCoordinate2D(latitude: 40.0, longitude: 120.0)
        let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Location")
        region.notifyOnEntry = true;
        region.notifyOnExit = false;
        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)

 */
        
        // create notification request
        let request = UNNotificationRequest(identifier: "animateUIKit_local_notification", content: content, trigger: trigger)
        
        // add request to user Notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("unable to add notification request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    /// handle response here 
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let actionIdentifier = response.actionIdentifier
        let content = response.notification.request.content
        
        switch actionIdentifier {
        case Notification.Action.readLater:
            print("Save Tutorial For Later")
        case Notification.Action.unsubscribe:
            print("Unsubscribe Reader")
        case Notification.Action.reply:
            if let textResponse = response as? UNTextInputNotificationResponse {
                let reply = textResponse.userText
                // send reply message 
                print("user response \(reply) content looks like this : \(content)")
            }
        default:
            print("Other Action")
        }
        
        completionHandler()
    }

}





extension SecondViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
