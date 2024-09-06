//
//  HabitListViewController.swift
//  habitTracker
//
//  Created by Djordje Arandjelovic on 20.8.24..
//

import UIKit

class HabitListViewController: UITableViewController {
    
    var habits: [Habit] = []
    
    @IBOutlet weak var motivationalQuoteLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHabitsFromUserDefaults()
        
        QuoteFetcher.fetchMotivationalQuote { [weak self] quoteText in
            DispatchQueue.main.async {
                self?.motivationalQuoteLabel.text = quoteText
            }
        }
        
        self.title = "Habits"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HabitCell")
    }
    
    func saveHabitsToUserDefaults() {
        if let encodedData = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encodedData, forKey: "habits")
        }
    }
    
    func loadHabitsFromUserDefaults() {
        if let savedDate = UserDefaults.standard.data(forKey: "habits"),
           let decodedData = try? JSONDecoder().decode([Habit].self, from: savedDate) {
            habits = decodedData
        }
    }

}


//MARK: - TableView Data Soure and Delegate
extension HabitListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath)
        let habit = habits[indexPath.row]
        
        cell.textLabel?.text = habit.name
        
        let completionSwitch = UISwitch()
        completionSwitch.isOn = habit.isCompleted
        completionSwitch.tag = indexPath.row
        completionSwitch.addTarget(self, action: #selector(completionSwitchToggled(_:)), for: .valueChanged)
        
        cell.accessoryView = completionSwitch
        
        return cell
    }
    
    @objc func completionSwitchToggled(_ sender: UISwitch) {
        let habitIndex = sender.tag
        habits[habitIndex].isCompleted = sender.isOn
        
        if sender.isOn {
            habits[habitIndex].completionCount += 1
        }
        
        tableView.reloadRows(at: [IndexPath(row: habitIndex, section: 0)], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHabit = habits[indexPath.row]
        print("Selected habit: \(selectedHabit)")
        performSegue(withIdentifier: "showHabitDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let habitToDelete = habits[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Habit", message: "Are you sure you want to delete \(habitToDelete.name)?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                self.habits.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.saveHabitsToUserDefaults()
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
}

extension HabitListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHabitDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedHabit = habits[indexPath.row]
                
                let detailVC = segue.destination as! HabitDetailViewController
                detailVC.habit = selectedHabit
                
                detailVC.onSave = { [weak self] updatedHabit in
                    self?.habits[indexPath.row] = updatedHabit
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self?.saveHabitsToUserDefaults()
                }
            }
        }
        
        if segue.identifier == "showAddHabit" {
            let addHabitVC = segue.destination as! AddHabitViewController
            addHabitVC.onSave = { [weak self] newHabit in
                self?.habits.append(newHabit)
                self?.tableView.reloadData()
                self?.saveHabitsToUserDefaults()
            }
        }
    }
}
