import UIKit
import Foundation
// CALayers

// CA = Core Animation

// Views are anything you render to the screen such as: UIView, UILabel, UIImageView, UIButton...
// Views are backed by a CALayer which represents what will be drawn to the screen
// Views act as a wrapper for the Layer

// We want to upgrade the looks of our views within our app


//---------------------------------------------------------------------------------------

// Basics

// every view has a layer that can be accessed with the layer property

let view = UIView()
view.layer
// self.layer

//--------------------
// CALayer Properties

// Rounded corners: cornerRadius
view.layer.cornerRadius = 22
// To create a circle:
view.layer.cornerRadius = view.bounds.height / 2.0

// Borders: borderWidth, borderColor
view.layer.borderWidth = 1.0
view.layer.borderColor = UIColor.blue.cgColor // add .cgColor

// Shadows: shadowOpacity, shadowRadius, shadowOffset, shadowColor, shadowPath
view.layer.shadowRadius = 4.0 // how wide we want the shadow to spread out 
view.layer.shadowOpacity = 0.5 // 1 is completely opaque, 0 is completely transparent
view.layer.shadowOffset = CGSize.zero // specifies the location of the shadow,.zero places a shadow all around the image; default is 0 - 3 will place shadow 0 pixels to the right and 3 pixels above the image


// Mask: mask, masksToBounds
// for hiding parts of the layer

// Contents: contents, contentsGravity
// can be set to an image and how it is sized according to the bounds

// layer properties can be animated
// use CAAnimation code


// CALayer has many subclasses, 2 basic ones:
// CAGradientLayer
// CAShapeLayer
// Default backing layer for every View is the CALayer, but can be changed:

//override class func layerClass() -> AnyClass {
//    return CAShapeLayer.self
//}


// Layers can have sublayers


//---------------------------------------------------------------------------------------

// Working with CAGradientLayer


// Gradient Layers have a certain bounds within a coordinate system:
/*
 
 (0, 0)----------------------------(1, 0)
    |  /                             |
    | s(0.25. 0.25)                 /|
    |/                  e(0.75, 0.75)|
    |                             /  |
 (0, 1)----------------------------(1, 1)
 
 to draw a gradient, we need to specify start and end points with start and end colors and possibly add colors in between
*/

let layerGradient = CAGradientLayer()
layerGradient.colors = [
    UIColor.black.cgColor,
    UIColor.red.cgColor, // to add a red color between
    UIColor.white.cgColor
]
layerGradient.startPoint = CGPoint(x: 0.25, y: 0.25)
layerGradient.endPoint = CGPoint(x: 0.75, y: 0.75)

// if we want to customize the gradient behavior, use the locations property
// ex black at 0%, red to be at 80% and white at 100%
layerGradient.locations = [0, 0.8, 1]


//---------------------------------------------------------------------------------------

// Layers and Sublayers

let layer = CALayer()
layer.addSublayer(layerGradient)

// we MUST set the layer's and sublayer's frames, best place to do that is in layoutSubviews()
// layoutSubviews() method gets called everytime our view's bounds change



//---------------------------------------------------------------------------------------

// Working with CAShapeLayer

// lets you draw and stroke arbitrary parts
// great animation support

// Properties:

// Path itself to draw: path
// Fill: fillColor, fillRule
// Stroke follows the path: strokeColor, stokeStart, strokeEnd
// Line (that is being drawn) Tweaks: lineCap, lineDashPattern, lineDashPhase, lineJoin, lineWidth, miterLimit

//--------------
// UIBezierPath

// easier way to create CGPaths
// has initializers for rects, ovals, rounded rects, arcs
let bounds = view.bounds
UIBezierPath(rect: bounds)
UIBezierPath(ovalIn: bounds)
UIBezierPath(roundedRect: bounds, cornerRadius: 10.0)

// supports custom paths:
let path = UIBezierPath()
let top = CGPoint(x: 0, y: 0.5)
path.move(to: top)
path.addLine(to: view.rightAnchor.accessibilityActivationPoint) // not sure if this works for "right"
path.addArc(withCenter: view.center, radius: view.bounds.width * 0.35, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
path.close()


// Create a custom shape:

@IBDesignable // so it shows in the storyboard
class CustomCircleView: UIView {
    
    let percentLabel = UILabel()
    let captionLabel = UILabel()
    
    var range: CGFloat = 10
    var curValue: CGFloat = 0 {
        didSet {
            animate()
        }
    }
    let margin: CGFloat = 10
    
    let backgroundLayer = CAShapeLayer()
    @IBInspectable var bgColor: UIColor = UIColor.gray {
        didSet {
            configure()
        }
    }
    let foregroundLayer = CAShapeLayer()
    @IBInspectable var fgColor: UIColor = UIColor.black {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        configure()
    }
    
    func setup() {
        
        // setup background layer
        backgroundLayer.lineWidth = 20.0
        backgroundLayer.fillColor = nil
        backgroundLayer.strokeEnd = 1
        layer.addSublayer(backgroundLayer)
        
        // Do pretty much the same thing for the foreground
        foregroundLayer.lineWidth = 20.0
        foregroundLayer.fillColor = nil
        foregroundLayer.strokeEnd = 0.5
        layer.addSublayer(foregroundLayer)
        
        // Setup constraints
        let percentLabelCenterX = percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let percentLabelCenterY = percentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -margin)
        NSLayoutConstraint.activate([percentLabelCenterX, percentLabelCenterY])
        
        let captionLabelCenterX = captionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -margin)
        let captionLabelBottom = captionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin)
        NSLayoutConstraint.activate([captionLabelCenterX, captionLabelBottom])
    }
    
    // setup user interaction methods
    func configure() {
        
        backgroundLayer.strokeColor = UIColor.gray.cgColor
        foregroundLayer.strokeColor = UIColor.black.cgColor
    }
    
    // layoutSubviews() gets called whenever the bounds of a view change and is a good place to add the path of the layer bc the path in this case depends on the width of the bounds
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShapeLayer(shapeLayer: backgroundLayer)
        setupShapeLayer(shapeLayer: foregroundLayer)
    }
    
    private func setupShapeLayer(shapeLayer: CAShapeLayer) {
        shapeLayer.frame = self.bounds
        let startAngle = DegreesToRadians(135.0)
        let endAngle = DegreesToRadians(45.0)
        let center = view.center
        let radius = view.bounds.width * 0.35
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    // Helper functions
    func DegreesToRadians (_ value:CGFloat) -> CGFloat {
        return value * CGFloat(M_PI) / 180.0
    }
    
    func RadiansToDegrees (_ value:CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(M_PI)
    }
    
    fileprivate func animate() {
        percentLabel.text = String(format: "%.0f/%.0f", curValue, range)
        
        var fromValue = foregroundLayer.strokeEnd
        let toValue = curValue / range
        if let presentationLayer = foregroundLayer.presentation() as CAShapeLayer? {
            fromValue = presentationLayer.strokeEnd
        }
        let percentChange = abs(fromValue - toValue)
        
        // 1
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        // 2
        animation.duration = CFTimeInterval(percentChange * 4)
        
        // 3
        foregroundLayer.removeAnimation(forKey: "stroke")
        foregroundLayer.add(animation, forKey: "stroke")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        foregroundLayer.strokeEnd = toValue
        CATransaction.commit()
    }
}



//---------------------------------------------------------------------------------------

// Masking Layers

// every layer has a mask property that you can set to be another layer

// create a mask layer, this would be used in the Storyboard, setting a VC's Top View to this CocoaTouchClass
@IBDesignable // makes it viewable in the storyboard
class RoundedView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30.0, height: 30.0)).cgPath
        layer.mask = shapeLayer
    }
}
// this will round the corners of a view




//---------------------------------------------------------------------------------------

// Other Layers:
/*
 
 CAScrollLayer
 CATextLayer
 CATiledLayer
 CATransformLayer
 CAEmitterLayer
 CAMetalLayer
 AVPlayerLayer
 CAReplicatorLayer

More info on these found here:
 
 http://www.raywenderlich.com/90488/calayer-in-ios-with-swift-10-examples
 
*/



















