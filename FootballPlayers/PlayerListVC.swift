import UIKit
import CoreData

class PlayerListVC: UIViewController
{
    @IBOutlet weak var playerSB: UISearchBar!
    @IBOutlet weak var playerTV: UITableView!
    
    var playerArr = [PlayerList]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
    }
    
    func getData()
    {
        let ctx = appDel.persistentContainer.viewContext
        do{
            playerArr = try ctx.fetch(PlayerList.fetchRequest())
            print("Player length \(playerArr.count)")
            playerTV.reloadData()
        }catch{
            print("Exception")
        }
    }
    
    func filterRecords()
    {
        let ctx = appDel.persistentContainer.viewContext
        do{
            let fetcgReq : NSFetchRequest<PlayerList> = PlayerList.fetchRequest()
            fetcgReq.predicate = NSPredicate(format: "playername CONTAINS %@", playerSB.text!)
            playerArr = try ctx.fetch(fetcgReq)
            print("Player length \(playerArr.count)")
            playerTV.reloadData()
        }catch{
            print("Exception")
        }
    }
}

extension PlayerListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return playerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let item = playerArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListTVC") as! PlayerListTVC
        cell.nameLbl.text = item.playername!
        cell.ageLbl.text = item.playerage!
        cell.countryLbl.text = item.playercountry!
        
        cell.updateBtn.tag = indexPath.row
        cell.updateBtn.addTarget(self, action: #selector(updatePress(sender:)), for: .touchUpInside)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deletePress(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.1
    }
    
    @objc func updatePress(sender:UIButton)
    {
        print("Update Press \(sender.tag)")
        let item = playerArr[sender.tag]
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddPlayerVC") as! AddPlayerVC
        vc.PlayerList = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deletePress(sender:UIButton)
    {
        let alert = UIAlertController(title: "DELETE ALERT", message: "Are you sure you want to delete", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancel Press")
        }
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            print("Player Deleted")
            
            let ctx = self.appDel.persistentContainer.viewContext
            let item = self.playerArr[sender.tag]
            ctx.delete(item)
            self.appDel.saveContext()
            self.playerArr.remove(at: sender.tag)
            self.playerTV.reloadData()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension PlayerListVC: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print("User has entered \(searchText)")
        searchText.count == 0 ? getData() : filterRecords()
    }
}

class PlayerListTVC: UITableViewCell
{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
}
