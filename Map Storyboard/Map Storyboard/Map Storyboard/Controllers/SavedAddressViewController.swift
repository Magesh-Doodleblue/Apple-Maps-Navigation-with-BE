//
//  SavedAddressViewController.swift
//  Map Storyboard
//
//  Created by DB-MM-011 on 20/06/23.
//

import UIKit
import CoreData

class SavedAddressViewController: UIViewController {

    @IBOutlet weak var tableViewOutlet: UITableView! //table view outlet
    
    var viewController: ViewController?
    var addressEntities: [AddressEntity] = []       //array to show the data in UI
 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //getting the content from Appdelegate to perform CRUD in UI
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressEntities = fetchDataFromDatabase(context: context)  //getting value from db to the array
        
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        tableViewOutlet.reloadData()
    
    }
    
    // MARK: Fetch Database
    func fetchDataFromDatabase(context: NSManagedObjectContext) -> [AddressEntity] {
        var addressEntities: [AddressEntity] = []
        
        let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
        
        do {
            addressEntities = try context.fetch(fetchRequest)
            print("Address count: \(addressEntities.count)")
        } catch {
            print("Failed to fetch data from database: \(error)")
        }
        
        return addressEntities
    }
    
    // MARK: delete the location in UI

    @IBAction func deleteActionButton(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        let point = button.convert(CGPoint.zero, to: tableViewOutlet)
        if let indexPath = tableViewOutlet.indexPathForRow(at: point) {
            let addressEntity = addressEntities[indexPath.row]
            
            context.delete(addressEntity)
            do {
                try context.save()
                print("Deleted address: \(addressEntity.address ?? ""), Latitude: \(addressEntity.lat), Longitude: \(addressEntity.long)")
                
                // Remove the deleted address from the array
                addressEntities.remove(at: indexPath.row)
                
                // Update the table view
                tableViewOutlet.reloadData()
                
            } catch {
                print("Failed to delete data from the database: \(error)")
            }
        }
    }
}


// MARK: Row highlighted
extension SavedAddressViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped button \(indexPath)")
    }
}
// MARK: Data for Table view
extension SavedAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(addressEntities.count)")
        return addressEntities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ONE", for: indexPath) as! AddressTableViewCell
        let addressEntity = addressEntities[indexPath.row]
        cell.addressLabel.text = addressEntity.address ?? "UNKNOWN ADDRESS"
        cell.latitudeLabel.text = "Latitude: \(addressEntity.lat)"
        cell.longitudeLabel.text = "Longitude: \(addressEntity.long)"
        return cell
    }
}

// MARK: Show the data in label - UI
class AddressTableViewCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
}
