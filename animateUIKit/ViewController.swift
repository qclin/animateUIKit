//
//  ViewController.swift
//  animateUIKit
//
//  Created by Qiao Lin on 3/2/17.
//  Copyright © 2017 Qiao Lin. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController{
    let colors: [UIColor] = [
        .red,
        .blue,
        .yellow,
        .orange,
        .green,
        .brown
    ]
    @IBOutlet weak var animatingView: UIView!
    @IBOutlet weak var mockImage: UIImageView!

    @IBOutlet weak var purpleView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    
    struct Notification {
        
        struct Category {
            static let tutorial = "tutorial"
        }
        
        struct Action {
            static let readLater = "readLater"
            static let showDetails = "showDetails"
            static let unsubscribe = "unsubscribe"
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mockImage.image = UIImage(named: "mock")
        
        btn2.leadingAnchor.constraint(equalTo: btn1.trailingAnchor, constant: 10).isActive = true
        purpleView.widthAnchor.constraint(equalTo: btn2.widthAnchor, constant: 0).isActive = true

        UNUserNotificationCenter.current().delegate = self

        configureUserNotificationsCenter()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func animatingViewTapped(_ sender: Any) {
        let animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn){
            [weak animatingView, weak self] in
            
            guard
                let view = animatingView,
                let strongSelf = self,
                let viewBackgroundColor = view.backgroundColor
                else {return}
            
            view.backgroundColor = strongSelf.randomColor(noEqualTo: viewBackgroundColor)
        }
        
        animator.startAnimation()
    }
    
    
    func randomColor(noEqualTo currentColor: UIColor) -> UIColor{
        var foundColor = currentColor
        
        repeat{
            let index = Int(arc4random_uniform(UInt32(colors.count)))
            foundColor = colors[index]
        } while foundColor.isEqual(currentColor)
        
        return foundColor
    }

    
    private func configureUserNotificationsCenter() {
        // Configure User Notification Center
        
        // Define Actions
        let actionReadLater = UNNotificationAction(identifier: Notification.Action.readLater, title: "Read Later", options: [])
        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.showDetails, title: "Show Details", options: [.foreground])
        let actionUnsubscribe = UNNotificationAction(identifier: Notification.Action.unsubscribe, title: "Unsubscribe", options: [.destructive, .authenticationRequired])
        
        // Define Category
        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionReadLater, actionShowDetails, actionUnsubscribe], intentIdentifiers: [], options: [])
        
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
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "title"
        notificationContent.subtitle = "subtitle"
        
        notificationContent.body = "In this tutorial, you learn how to schedule local notifications with the User Notifications framework."
     
        
        // set category identifier 
        notificationContent.categoryIdentifier = Notification.Category.tutorial
        
        // add Trigger 
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        // create notification request
        let notificationRequest = UNNotificationRequest(identifier: "animateUIKit_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // add request to user Notification center 
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error{
                print("unable to add notification request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case Notification.Action.readLater:
            print("Save Tutorial For Later")
        case Notification.Action.unsubscribe:
            print("Unsubscribe Reader")
        default:
            print("Other Action")
        }
        
        completionHandler()
    }

}



extension ViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}

