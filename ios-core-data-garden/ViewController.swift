import UIKit
import CoreData

class ViewController: UIViewController {
    
    var SEGUE_DETAILS = "segue1"
    
    var peopleContainer: [Person] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadDataChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addClick(_ sender: Any) {
        let person = Person(context: CoreDataHelper.sharedInstance.viewContext())
        person.firstName = "Exercise \(self.peopleContainer.count + 1)"
        person.age = Int32(10)
        CoreDataHelper.sharedInstance.saveContext()
        self.reloadDataChanges()
    }
    
    func reloadDataChanges() {
        peopleContainer.removeAll()
        peopleContainer = CoreDataHelper.sharedInstance.fetchAllPeople() as! [Person]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleContainer.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = peopleContainer[indexPath.row]
        let text = "\(person.firstName ?? "") (\(person.totalPoints))"
        cell?.textLabel?.text = text
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = peopleContainer[indexPath.row]
        performSegue(withIdentifier: SEGUE_DETAILS, sender: person)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == SEGUE_DETAILS){
            let person = sender as! Person
            let destination = segue.destination as! DetailsController
            destination.person = person
        }
    }
}

extension Person {

    var totalPoints: Int {
        
        get {
            if (self.drawing == nil || self.drawing!.points == nil) {
                return 0
            }
            else {
                return (self.drawing?.points?.count)!
            }
        }
        
    }
}
