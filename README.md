# Short Layout with Swift

Short Layout is library of AutoLayout with syntax sugar.

## Required

- iOS 8 or greather
- Xcode 7 or greather
- Carthage

---

## Install

Add `github "fromkk/ShortLayout"` to **Cartfile** and execute `carthage update` command on your terminal in project directory.  

Add **Carthage/Build/{Platform}/ShortLayout.framework** to **Link Binary with Libralies** in you project.  
If you doesn't use Carthage, add **New Run Script Phase** and input `/usr/local/bin/carthage copy-frameworks` in **Build Phases** tab.  
Add `$(SRCROOT)/Carthage/Build/{Platform}/ShortLayout.framework` to **Input Files**.

---

## Usage

```swift
let redView: UIView = UIView(frame: CGRect.zero)
redView.backgroundColor = UIColor.red
self.view.addSubview(redView, layouts: [
    redView.layout.width.equal(to: self.view.layout.width).constant(0.0),
    redView.layout.height.equal(to: self.view.layout.height).constant(0.0),
    redView.layout.centerX.equal(to: self.view.layout.centerX).constant(0.0),
    redView.layout.centerY.equal(to: self.view.layout.centerY).constant(0.0)
])

let blueView: UIView = UIView(frame: CGRect.zero)
blueView.backgroundColor = UIColor.blue
redView.addSubview(blueView, layouts: [
    blueView.layout.left.equal(to: redView.layout.left).constant(10.0),
    blueView.layout.top.equal(to: redView.layout.top).constant(10.0),
    blueView.layout.right.equal(to: redView.layout.right).constant(-10.0),
    blueView.layout.bottom.equal(to: redView.layout.bottom).constant(-10.0),
])
```
