//
//  HomeViewController.swift
//  MotivationalAppUsingSharingAndNotifications
//
//  Created by Nikolas Aggelidis on 30/11/20.
//  Copyright © 2020 NAPPS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteImageView: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateQuote()
    }
    
    private func updateQuote() {
        guard let backgroundImageName = images.randomElement() else { fatalError("Unable to load an image.") }
        backgroundImageView.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else { fatalError("Unable to read a quote.") }
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
            let graphicsImageRenderer = UIGraphicsImageRenderer(bounds: quoteRect, format: graphicsImageRendererFormat)
            
            quoteImageView.image = graphicsImageRenderer.image { context in
                attributedString.draw(in: quoteRect)
            }
        }
    }
}
