//
//  ToDoTableViewController.swift
//  ToDoApplication
//
//  Created by Dheeraj Arora on 08/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    
    //MARK: Outlets
    //@IBOutlet var tableView: UITableView!
    
    //MARK: Property
    var resultController: NSFetchedResultsController<ToDo>!
    let coreDataStack = CoreDataStack()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Request
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "date", ascending: true)
        
        //Init
        request.sortDescriptors = [sortDescription]
        resultController = NSFetchedResultsController(fetchRequest: request,managedObjectContext: coreDataStack.manageContext,
                                                      sectionNameKeyPath: nil, cacheName: nil)
        
        resultController.delegate = self
        
        //Fetch
        do {
            try resultController.performFetch()
        } catch  {
            print("Perform fetch error: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func goAddToDoVC(_ sender: UIBarButtonItem) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoViewController") as! AddToDoViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultController.sections?[section].numberOfObjects ?? 0
        //return 10

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        let todo = resultController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        return cell
    }
   
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //TODO: Delete todo
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do{
                try self.resultController.managedObjectContext.save()
                completion(true)
            }catch{
                print("Delete faield: \(error)")
                completion(false)
            }
            
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        return UISwipeActionsConfiguration.init(actions: [action])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do{
                try self.resultController.managedObjectContext.save()
                completion(true)
            }catch{
                print("Delete faield: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "check")
        action.backgroundColor = .green
        return UISwipeActionsConfiguration.init(actions: [action])
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowToDo", sender: tableView.cellForRow(at: indexPath))
      
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController{
            vc.manageContext = resultController.managedObjectContext
        }
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddToDoViewController{
            if let indexPath = tableView.indexPath(for: cell){
                let todo = resultController.object(at: indexPath)
                  vc.todo = todo
            }
        }
    }
}

extension ToDoTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = newIndexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let todo = resultController.object(at: indexPath)
                cell.textLabel?.text = todo.title
                
            }
        default:
            break
        }
    }
}
