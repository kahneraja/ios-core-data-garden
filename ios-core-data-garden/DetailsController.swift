import UIKit
import CoreData

class DetailsController: UIViewController {
    
    let white = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    let hotPink = UIColor.init(red: 255/255.0, green: 3/255.0, blue: 79/255.0, alpha: 1).cgColor
    let softBlue = UIColor.init(red: 15/255.0, green: 112/255.0, blue: 231/255.0, alpha: 1).cgColor
    
    var cgPoints: [CGPoint] = []
    var lastPoint: CGPoint = CGPoint(x:0, y:0)
    
    
    @IBOutlet weak var UIImageView1: UIImageView!
    
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (person.drawing != nil && person.drawing!.points != nil){
            for point in person.drawing!.points?.array as! [Point] {
                cgPoints.append(point.toCGPoint)
            }
        }
        
        for cgPoint in self.cgPoints {
            drawLine(point: cgPoint)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        savePointsToPerson()
    }
    
    func savePointsToPerson(){
        if (person.drawing == nil) {
            let drawing = Drawing(context: CoreDataHelper.sharedInstance.viewContext())
            person.drawing = drawing
        }
        
        person.drawing?.points = []
        
        for cgPoint in self.cgPoints {
            let point = Point(context: CoreDataHelper.sharedInstance.viewContext())
            point.x = Float(cgPoint.x)
            point.y = Float(cgPoint.y)
            person.drawing?.addToPoints(point)
        }
        
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Click(_ sender: Any) {
        let point = Point(context: CoreDataHelper.sharedInstance.viewContext())
        point.x = 12.2
        point.y = 234.3
        
        if (person.drawing == nil) {
            let drawing = Drawing(context: CoreDataHelper.sharedInstance.viewContext())
            person.drawing = drawing
        }
        person.drawing?.addToPoints(point)
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func getPixelColorAtPoint(point:CGPoint) -> UIColor{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        UIImageView1.layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate(capacity: 4)
        return color
    }
    
    func drawDot(point: CGPoint){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: point.x, y: point.y), radius: CGFloat(2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        let color = getColor(point: point)
        shapeLayer.fillColor = color
        shapeLayer.strokeColor = color
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func getColor(point: CGPoint) -> CGColor{
        let offset = UIImageView1.frame.origin
        let offsetPoint = CGPoint(x: point.x - offset.x, y: point.y - offset.y)
        let pixelColor = getPixelColorAtPoint(point: offsetPoint)
        
        var color = softBlue
        
        if (pixelColor.cgColor.isWhite){
            color = hotPink
        }
        return color
    }
    
    func drawLine(point: CGPoint){
        
        if (lastPoint.x == 0 && lastPoint.y == 0){
            lastPoint = point
        }
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: lastPoint)
        linePath.addLine(to: point)
        line.path = linePath.cgPath
        line.strokeColor = getColor(point: point)
        line.lineWidth = 3
        line.lineJoin = kCALineJoinRound
        view.layer.addSublayer(line)
        lastPoint = point
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let cgPoint = touch.location(in: view)
            drawLine(point: cgPoint)
            self.cgPoints.append(cgPoint)
        }
    }
}

extension Point {
    var toCGPoint: CGPoint {
        get {
            return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
        }
    }
}

extension CGColor {
    
    var isWhite: Bool {
        get {
            return (self.components![0] == 1 &&
                self.components![1] == 1 &&
                self.components![2] == 1)
        }
    }
}
