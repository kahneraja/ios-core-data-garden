import UIKit

class ViewController: UIViewController {
    var personCount = 1;
    var peopleContainer : [Person] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        reloadDataChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addClick(_ sender: Any) {
        appDelegate.persistentContainer.performBackgroundTask{(backgroundContext) in
            let personEntity = Person(context: backgroundContext)
            personEntity.firstName = "Person \(self.personCount)"
            personEntity.age = Int32(self.personCount)
            self.personCount += 1
            do {
                try backgroundContext.save()
                self.reloadDataChanges()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func reloadDataChanges() {
        peopleContainer.removeAll()
        
        do {
            try peopleContainer += appDelegate.persistentContainer.viewContext.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleContainer.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = peopleContainer[indexPath.row].firstName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
}
