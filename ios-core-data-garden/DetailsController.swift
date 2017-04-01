import UIKit
import CoreData

class DetailsController: UIViewController {

    @IBOutlet weak var uiLabel: UILabel!
    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiLabel!.text = person!.firstName ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
