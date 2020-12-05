//
//  HomeViewController.swift
//  MotivationalAppUsingSharingAndNotifications
//
//  Created by Nikolas Aggelidis on 30/11/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteImageView: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    var sharedQuote: Quote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if allowed {
                configureAlerts()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateQuote()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuote()
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender: UIButton) {
        guard let quote = sharedQuote else { fatalError("Attempting to share a non-existing quote.") }
        let sharedMessage = "\"\(quote.text)\" - \(quote.author)"
        let activityViewController = UIActivityViewController(activityItems: [sharedMessage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        present(activityViewController, animated: true)
    }
    
    private func updateQuote() {
        guard let backgroundImageName = images.randomElement() else { fatalError("Unable to load an image.") }
        backgroundImageView.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else { fatalError("Unable to read a quote.") }
        sharedQuote = selectedQuote
        let drawBounds = quoteImageView.bounds.inset(by: UIEdgeInsets(top: 250, left: 250, bottom: 250, right: 250))
        var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        var fontSize: CGFloat = 120
        var font: UIFont!
        var stringAttributes: [NSAttributedString.Key: Any]!
        var attributedString: NSAttributedString!
        
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            stringAttributes = [.font: font, .foregroundColor: UIColor.white]
            attributedString = NSAttributedString(string: selectedQuote.text, attributes: stringAttributes)
            quoteRect = attributedString.boundingRect(with: CGSize(width: drawBounds.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
            
            let graphicsImageRendererFormat = UIGraphicsImageRendererFormat()
            graphicsImageRendererFormat.opaque = false
            let graphicsImageRenderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: graphicsImageRendererFormat)
            
            quoteImageView.image = graphicsImageRenderer.image { context in
                for i in 1...5 {
                    context.cgContext.setShadow(offset: .zero, blur: CGFloat(i) * 2, color: UIColor.black.cgColor)
                    attributedString.draw(in: quoteRect)
                }
            }
        }
    }
    
    private func configureAlerts() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let shuffledQuotes = quotes.shuffled()
        
        for i in 1...7  {
            let mutableNotificationContent = UNMutableNotificationContent()
            mutableNotificationContent.title = "Inner Peace"
            mutableNotificationContent.body = shuffledQuotes[i].text
            
            var dateComponents = DateComponents()
            dateComponents.day = i
            
            if let alertDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
                var alertComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
                alertComponents.hour = 10
                let timeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * 5, repeats: false)
                let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: mutableNotificationContent, trigger: timeIntervalNotificationTrigger)
                
                UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }
    }
}
