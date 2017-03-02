//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

import UIKit
import PlaygroundSupport


// ask for infinite execution time
PlaygroundPage.current.needsIndefiniteExecution = false


// subclass UIView and add tap gesture upon initializer once mounted execute finishExecution()
class TappableView : UIView{
    @objc func handleTabs(_ sender: UITapGestureRecognizer){
        PlaygroundPage.current.finishExecution()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TappableView.handleTabs(_:)))
        addGestureRecognizer(recognizer)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

// instantiate view and set it as the liveView of playground

extension Double{
    var toSize: CGSize{
            return .init(width: self, height: self)
        }
}

extension CGSize{
    var toRectWithZeroOrigin: CGRect{
        return CGRect(origin: .zero, size: self)
    }
}

let view = TappableView(frame: 600.toSize.toRectWithZeroOrigin)
view.backgroundColor = .yellow
PlaygroundPage.current.liveView = view




