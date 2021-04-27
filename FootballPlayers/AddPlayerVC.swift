import UIKit

class AddPlayerVC: UIViewController
{
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    var PlayerList : PlayerList?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let passItem = PlayerList
        {
            print("Update Button Clicked")
            nameTF.text = passItem.playername!
            ageTF.text = passItem.playerage!
            countryTF.text = passItem.playercountry!
            addBtn.setTitle("UPDATE PLAYER", for: .normal)
            self.navigationItem.title = "Update Football Player"
        }
    }
    
    @IBAction func addUpdPress(_ sender: UIButton)
    {
        let ctx = appDel.persistentContainer.viewContext
        
        if let passItem = PlayerList
        {
            passItem.playername = nameTF.text!
            passItem.playerage = ageTF.text!
            passItem.playercountry = countryTF.text!
        }else{
            let item = FootballPlayers.PlayerList(context: ctx)
            item.playername = nameTF.text!
            item.playerage = ageTF.text!
            item.playercountry = countryTF.text!
        }
        appDel.saveContext()
        nameTF.text = ""
        ageTF.text = ""
        countryTF.text = ""
    }
}
