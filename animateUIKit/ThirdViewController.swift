//
//  ThirdViewController.swift
//  animateUIKit
//
//  Created by Qiao Lin on 3/3/17.
//  Copyright © 2017 Qiao Lin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var rightStack: UIStackView!
    
    func lblWithIndex(_ idx: Int) -> UILabel{
        let label = UILabel()
        label.text = "Item \(idx)"
        label.sizeToFit()
        return label
    }
    
    func newButton() -> UIButton{
        let btn = UIButton(type: .system)
        btn.setTitle("Add new items...", for: UIControlState())
        btn.addTarget(self, action: #selector(ThirdViewController.addNewItem), for: .touchUpInside)
        return btn
    }
    
    func addNewItem(){
        let n = rightStack.arrangedSubviews.count
        let v = lblWithIndex(n)
        rightStack.insertArrangedSubview(v, at: n - 1 )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightStack = UIStackView(arrangedSubviews: [lblWithIndex(1), lblWithIndex(2), lblWithIndex(3), newButton()])
        view.addSubview(rightStack)
        
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.axis = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.spacing = 5
        rightStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -20).isActive = true
        rightStack.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
