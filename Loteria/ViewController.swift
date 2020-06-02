import UIKit
import Intents
import IntentsUI
import CoreSpotlight
import CoreServices

struct UserActivity {
    static let randomGame = "com.ericbrito.loteria.randomgame"
}

class ViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet var balls: [UIButton]!
    
    // MARK: Properties
    lazy var activity: NSUserActivity = {
        let activity = NSUserActivity(activityType: UserActivity.randomGame)
        activity.title = "Gerar número da megasena"
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = UserActivity.randomGame
        activity.suggestedInvocationPhrase = "Gerar números da mega sena"
        activity.userInfo = ["name": "megasena"]
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        attributes.contentDescription = "Gerar número da mega sena"
        attributes.thumbnailData = UIImage(named: "loteria")!.jpegData(compressionQuality: 0.8)
        attributes.keywords = ["gerar", "sena", "megasena", "loteria"]
        
        activity.contentAttributeSet = attributes
        return activity
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNumbers()
    }
    
    // MARK: IBActions
    @IBAction func generateGame() {
        showNumbers()
    }
    
    @IBAction func addSiriShortcut(_ sender: Any) {
        let shortcut = INShortcut(userActivity: activity)
        let vc  = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: Methods
    func showNumbers() {
        var game: Set<Int> = []
        while game.count < 6 {
            game.insert(Int.random(in: 1...60))
        }
        for (index, game) in game.enumerated() {
            balls[index].setTitle("\(game)", for: .normal)
        }
        userActivity = activity
        userActivity?.becomeCurrent()
    }
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if let error = error {
            print("ruim", error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        print("Usuário cancelou")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
