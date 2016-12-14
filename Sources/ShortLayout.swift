//
//  Layout.swift
//  Layout
//
//  Created by Kazuya Ueoka on 2016/12/12.
//
//

import UIKit

public protocol LayoutConstrainable: class {
    func constant(_ constant: CGFloat) -> NSLayoutConstraint
    func multiplier(_ multiplier: CGFloat) -> LayoutConstrainable
    func priority(_ priority: Float) -> LayoutConstrainable
}

public protocol LayoutComparable: class {
    func equal(to: LayoutBasic?) -> LayoutConstrainable
    func greather(than: LayoutBasic?) -> LayoutConstrainable
    func less(than: LayoutBasic?) -> LayoutConstrainable
}

public protocol LayoutAttributable: LayoutComparable {}

public protocol LayoutBasic: LayoutAttributable {
    var view: UIView! { get set }
    var attribute: NSLayoutAttribute { get set }
    init(view: UIView, attribute: NSLayoutAttribute)
}

class LayoutBase: LayoutBasic {
    weak var view: UIView!
    var attribute: NSLayoutAttribute
    var to: LayoutBasic? = nil
    var relatition: NSLayoutRelation = NSLayoutRelation.equal
    var constant: CGFloat = 0.0
    var multiplier: CGFloat = 1.0
    var priority: Float = 999.0

    required init(view: UIView, attribute: NSLayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
}

extension LayoutBase {
    var layoutConstraint: NSLayoutConstraint {
        if let base: LayoutBase = self.to as? LayoutBase {
            let result: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: self.relatition, toItem: base.view, attribute: base.attribute, multiplier: self.multiplier, constant: self.constant)
            result.priority = UILayoutPriority(self.priority)
            return result
        } else {
            let result: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: self.relatition, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: self.multiplier, constant: self.constant)
            result.priority = UILayoutPriority(self.priority)
            return result
        }
    }
}

extension LayoutBase: LayoutComparable {
    public func equal(to: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.equal
        self.to = to
        return self
    }

    public func greather(than: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.greaterThanOrEqual
        self.to = than
        return self
    }
    
    public func less(than: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.lessThanOrEqual
        self.to = than
        return self
    }
}

extension LayoutBase: LayoutConstrainable {
    public func constant(_ constant: CGFloat) -> NSLayoutConstraint {
        self.constant = constant
        
        guard let to: LayoutBasic = self.to else {
            return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: self.relatition, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: self.multiplier, constant: self.constant)
        }
        return NSLayoutConstraint(item: self.view, attribute: self.attribute, relatedBy: self.relatition, toItem: to.view, attribute: to.attribute, multiplier: self.multiplier, constant: self.constant)
    }

    public func multiplier(_ multiplier: CGFloat) -> LayoutConstrainable {
        self.multiplier = multiplier
        return self
    }

    public func priority(_ priority: Float) -> LayoutConstrainable {
        self.priority = priority
        return self
    }
}

public struct ShortLayout {
    var view: UIView!
}

extension ShortLayout {
    public static func activate(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach { (constraint: NSLayoutConstraint) in
            if let view: UIView = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
}

extension ShortLayout {
    public var left: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.left) }
    public var right: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.right) }
    public var top: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.top) }
    public var bottom: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.bottom) }
    public var leading: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leading) }
    public var trailing: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.trailing) }
    public var width: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.width) }
    public var height: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.height) }
    public var centerX: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerX) }
    public var centerY: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerY) }
    public var lastBaseline: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.lastBaseline) }

    @available(iOS 8.0, *)
    public var firstBaseline: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.firstBaseline) }

    @available(iOS 8.0, *)
    public var leftMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leftMargin) }

    @available(iOS 8.0, *)
    public var rightMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.rightMargin) }

    @available(iOS 8.0, *)
    public var topMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.topMargin) }

    @available(iOS 8.0, *)
    public var bottomMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.bottomMargin) }

    @available(iOS 8.0, *)
    public var leadingMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leadingMargin) }

    @available(iOS 8.0, *)
    public var trailingMargin: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.trailingMargin) }

    @available(iOS 8.0, *)
    public var centerXWithinMargins: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerXWithinMargins) }

    @available(iOS 8.0, *)
    public var centerYWithinMargins: LayoutBasic { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerYWithinMargins) }
}

extension UIView {
    public static var layout: ShortLayout.Type { return ShortLayout.self }
    public var layout: ShortLayout { return ShortLayout(view: self) }
    public func addSubview(_ view: UIView, layouts: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        NSLayoutConstraint.activate(layouts)
    }
}
