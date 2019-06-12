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
    var attribute: NSLayoutConstraint.Attribute { get set }
    init(view: UIView, attribute: NSLayoutConstraint.Attribute)
}

class LayoutBase: LayoutBasic {
    weak var view: UIView!
    var attribute: NSLayoutConstraint.Attribute
    var to: LayoutBasic? = nil
    var relatition: NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal
    var constant: CGFloat = 0.0
    var multiplier: CGFloat = 1.0
    var priority: UILayoutPriority = UILayoutPriority.required

    required init(view: UIView, attribute: NSLayoutConstraint.Attribute) {
        self.view = view
        self.attribute = attribute
    }
}

extension LayoutBase {
    var layoutConstraint: NSLayoutConstraint {
        if let base: LayoutBase = self.to as? LayoutBase {
            let result: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: self.attribute, relatedBy: self.relatition, toItem: base.view, attribute: base.attribute, multiplier: self.multiplier, constant: self.constant)
            result.priority = UILayoutPriority(self.priority.rawValue)
            return result
        } else {
            let result: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: self.attribute, relatedBy: self.relatition, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: self.multiplier, constant: self.constant)
            result.priority = UILayoutPriority(self.priority.rawValue)
            return result
        }
    }
}

extension LayoutBase: LayoutComparable {
    public func equal(to: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutConstraint.Relation.equal
        self.to = to
        return self
    }

    public func greather(than: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutConstraint.Relation.greaterThanOrEqual
        self.to = than
        return self
    }
    
    public func less(than: LayoutBasic?) -> LayoutConstrainable {
        self.relatition = NSLayoutConstraint.Relation.lessThanOrEqual
        self.to = than
        return self
    }
}

extension LayoutBase: LayoutConstrainable {
    func priority(_ priority: Float) -> LayoutConstrainable {
        self.priority = UILayoutPriority(priority)
        return self
    }
    
    public func constant(_ constant: CGFloat) -> NSLayoutConstraint {
        self.constant = constant
        
        guard let to: LayoutBasic = self.to else {
            let result: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: self.attribute, relatedBy: self.relatition, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: self.multiplier, constant: self.constant)
            result.priority = self.priority
            return result
        }
        let result: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: self.attribute, relatedBy: self.relatition, toItem: to.view, attribute: to.attribute, multiplier: self.multiplier, constant: self.constant)
        result.priority = self.priority
        return result
    }

    public func multiplier(_ multiplier: CGFloat) -> LayoutConstrainable {
        self.multiplier = multiplier
        return self
    }

    public func priority(_ priority: UILayoutPriority) -> LayoutConstrainable {
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
    public var left: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.left) }
    public var right: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.right) }
    public var top: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.top) }
    public var bottom: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.bottom) }
    public var leading: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.leading) }
    public var trailing: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.trailing) }
    public var width: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.width) }
    public var height: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.height) }
    public var centerX: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.centerX) }
    public var centerY: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.centerY) }
    public var lastBaseline: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.lastBaseline) }

    @available(iOS 8.0, *)
    public var firstBaseline: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.firstBaseline) }

    @available(iOS 8.0, *)
    public var leftMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.leftMargin) }

    @available(iOS 8.0, *)
    public var rightMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.rightMargin) }

    @available(iOS 8.0, *)
    public var topMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.topMargin) }

    @available(iOS 8.0, *)
    public var bottomMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.bottomMargin) }

    @available(iOS 8.0, *)
    public var leadingMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.leadingMargin) }

    @available(iOS 8.0, *)
    public var trailingMargin: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.trailingMargin) }

    @available(iOS 8.0, *)
    public var centerXWithinMargins: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.centerXWithinMargins) }

    @available(iOS 8.0, *)
    public var centerYWithinMargins: LayoutBasic { return LayoutBase(view: view, attribute: NSLayoutConstraint.Attribute.centerYWithinMargins) }
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
