//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit
import ShortLayout

class ViewController: UIViewController {
    override func loadView() {
        super.loadView()

        self.view.backgroundColor = UIColor.white
        let redView: UIView = UIView(frame: CGRect.zero)
        redView.backgroundColor = UIColor.red

        self.view.addSubview(redView, layouts: [
            redView.layout.left.equal(to: self.view.layout.left).constant(20.0),
            redView.layout.top.equal(to: self.view.layout.top).constant(20.0),
            redView.layout.right.equal(to: self.view.layout.right).constant(-20.0),
            redView.layout.height.equal(to: 120.0),
        ])

        let label: UILabel = UILabel(frame: CGRect.zero)
        label.text = "test label"
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        ShortLayout.activate([
            label.layout.left.equal(to: self.view.layout.left).constant(20.0),
            label.layout.right.equal(to: self.view.layout.right).constant(-20.0),
            label.layout.top.equal(to: redView.layout.bottom).constant(20.0),
        ])

        let blueView: UIView = UIView(frame: CGRect.zero)
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)
        ShortLayout.activate([
            blueView.layout.left.equal(to: self.view.layout.left).constant(20.0),
            blueView.layout.top.equal(to: label.layout.bottom).constant(20.0),
            blueView.layout.right.equal(to: self.view.layout.right).constant(-20.0),
            blueView.layout.height.equal(to: 120.0)
        ])

        let yellowView: UIView = UIView(frame: CGRect.zero)
        yellowView.backgroundColor = UIColor.yellow
        self.view.addSubview(yellowView)

        let greenView: UIView = UIView(frame: CGRect.zero)
        greenView.backgroundColor = UIColor.green
        self.view.addSubview(greenView)

        ShortLayout.activate([
            yellowView.layout.top.equal(to: blueView.layout.bottom).constant(10.0),
            yellowView.layout.left.equal(to: self.view.layout.left).constant(10.0),
            yellowView.layout.height.equal(to: 120.0),
        ])

        ShortLayout.activate([
            greenView.layout.top.equal(to: yellowView.layout.top),
            greenView.layout.left.equal(to: yellowView.layout.right).constant(10.0),
            greenView.layout.width.equal(to: yellowView.layout.width),
            greenView.layout.right.equal(to: self.view.layout.right).constant(-10.0),
            greenView.layout.height.equal(to: yellowView.layout.height)
        ])
    }
}

let viewController: ViewController = ViewController(nibName: nil, bundle: nil)
viewController.view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 375.0, height: 487.0))

PlaygroundPage.current.liveView = viewController.view
