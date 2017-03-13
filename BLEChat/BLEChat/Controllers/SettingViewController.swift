import UIKit

class SettingViewController: UIViewController {
    var isResetName: Bool = false
    @IBOutlet weak var nameTextField: UITextField!
    /**
     * 設定ボタンをタップ
     */
    @IBAction func settingAction(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(nameTextField.text, forKey: "name")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        /// ユーザーデフォルトに名前が設定されていてリセットしない場合はChat画面に遷移する
        if userDefaults.string(forKey: "name") != nil && isResetName == false {
            moveChat()
        }
    }
    /**
     * Caht画面に遷移する
     */
    private func moveChat() {
        let storyboard: UIStoryboard = self.storyboard!
        let vc = storyboard.instantiateViewController(withIdentifier: "chat")
        present(vc, animated: true, completion: nil)
    }
}
