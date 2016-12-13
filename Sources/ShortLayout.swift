//
//  Layout.swift
//  Layout
//
//  Created by Kazuya Ueoka on 2016/12/12.
//
//

import UIKit

public protocol LayoutConstrainable: class {
    func constant(_ constant: CGFloat) -> LayoutConstrainable
    func multiplier(_ multiplier: CGFloat) -> LayoutConstrainable
    func priority(_ priority: Float) -> LayoutConstrainable
}

public protocol LayoutComparable: class {
    func equal(to: LayoutAttributable) -> LayoutConstrainable
    func equal(to: CGFloat) -> LayoutConstrainable
    func greather(than: LayoutAttributable) -> LayoutConstrainable
    func greather(than: CGFloat) -> LayoutConstrainable
    func less(than: LayoutAttributable) -> LayoutConstrainable
    func less(than: CGFloat) -> LayoutConstrainable
}

public protocol LayoutAttributable: LayoutComparable {}

internal protocol LayoutBasic: LayoutAttributable {
    var view: UIView! { get set }
    var attribute: NSLayoutAttribute { get set }
    init(view: UIView, attribute: NSLayoutAttribute)
}

class LayoutBase: LayoutBasic {
    weak var view: UIView!
    var attribute: NSLayoutAttribute
    var to: LayoutAttributable? = nil
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
    public func equal(to: LayoutAttributable) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.equal
        self.to = to
        return self
    }

    public func equal(to: CGFloat) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.equal
        self.constant = to
        return self
    }

    public func greather(than: LayoutAttributable) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.greaterThanOrEqual
        self.to = than
        return self
    }

    public func greather(than: CGFloat) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.greaterThanOrEqual
        self.constant = than
        return self
    }

    public func less(than: LayoutAttributable) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.lessThanOrEqual
        self.to = than
        return self
    }

    public func less(than: CGFloat) -> LayoutConstrainable {
        self.relatition = NSLayoutRelation.lessThanOrEqual
        self.constant = than
        return self
    }
}

extension LayoutBase: LayoutConstrainable {
    public func constant(_ constant: CGFloat) -> LayoutConstrainable {
        self.constant = constant
        return self
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
    public static func activate(_ constraints: [LayoutConstrainable]) {
        let actives: [NSLayoutConstraint] = constraints.flatMap { (constraint: LayoutConstrainable) in
            guard let item: LayoutBase = constraint as? LayoutBase else {
                return nil
            }

            item.view.translatesAutoresizingMaskIntoConstraints = false
            return item.layoutConstraint
        }
        NSLayoutConstraint.activate(actives)
    }
}

extension ShortLayout {
    public var left: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.left) }
    public var right: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.right) }
    public var top: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.top) }
    public var bottom: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.bottom) }
    public var leading: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leading) }
    public var trailing: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.trailing) }
    public var width: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.width) }
    public var height: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.height) }
    public var centerX: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerX) }
    public var centerY: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerY) }
    public var lastBaseline: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.lastBaseline) }

    @available(iOS 8.0, *)
    public var firstBaseline: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.firstBaseline) }

    @available(iOS 8.0, *)
    public var leftMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leftMargin) }

    @available(iOS 8.0, *)
    public var rightMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.rightMargin) }

    @available(iOS 8.0, *)
    public var topMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.topMargin) }

    @available(iOS 8.0, *)
    public var bottomMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.bottomMargin) }

    @available(iOS 8.0, *)
    public var leadingMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.leadingMargin) }

    @available(iOS 8.0, *)
    public var trailingMargin: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.trailingMargin) }

    @available(iOS 8.0, *)
    public var centerXWithinMargins: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerXWithinMargins) }

    @available(iOS 8.0, *)
    public var centerYWithinMargins: LayoutAttributable { return LayoutBase(view: self.view, attribute: NSLayoutAttribute.centerYWithinMargins) }
}

extension UIView {
    public static var layout: ShortLayout.Type { return ShortLayout.self }
    public var layout: ShortLayout { return ShortLayout(view: self) }
    public func addSubview(_ view: UIView, layouts: [LayoutConstrainable]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let actives: [NSLayoutConstraint] = layouts.flatMap {
            guard let layout: LayoutBase = $0 as? LayoutBase else {
                return nil
            }
            return layout.layoutConstraint
        }
        NSLayoutConstraint.activate(actives)
    }
}
