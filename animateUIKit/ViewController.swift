//
//  ViewController.swift
//  animateUIKit
//
//  Created by Qiao Lin on 3/2/17.
//  Copyright © 2017 Qiao Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mockImage.image = UIImage(named: "mock")
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
    
}

