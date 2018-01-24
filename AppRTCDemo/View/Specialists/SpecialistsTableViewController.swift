//
//  SpecialistsTableViewController.swift
//  AppRTCDemo
//
//  Created by Maksim Kita on 1/23/18.
//  Copyright © 2018 Maksim Kita. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class SpecialistsTableViewController: UITableViewController,SpecialistsViewModelDelegate {
  
    
    
    private var specialists:[SpecialistModel] = Authorization.instance.getSpecialists()
    private var viewSignal:Signal<SpecialistsViewActions,NoError>
    private var specialistsViewModel:SpecialistsViewModel
    private var specialistViewModelObserver:Signal<SpecialistsViewModelActions,NoError>.Observer
//    private var videoViewModelObserver:Signal<Speciali,NoError>.Observer
//    private var videoCallSignal:Signal<VideoCallViewActions,NoError>
    
    convenience override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let (signal,observer) = Signal<SpecialistsViewActions,NoError>.pipe()
        viewSignal = signal
        specialistsViewModel = SpecialistsViewModel(viewObserver: observer)
        specialistViewModelObserver = specialistsViewModel.getViewModelObserver()
        specialistsViewModel.connectToSocketServer()
    }
    
    required init(coder aDecoder: NSCoder) {
        let (signal,observer) = Signal<SpecialistsViewActions,NoError>.pipe()
        viewSignal = signal
        specialistsViewModel = SpecialistsViewModel(viewObserver: observer)
        specialistViewModelObserver = specialistsViewModel.getViewModelObserver()
        specialistsViewModel.connectToSocketServer()
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialistsViewModel.setDelegate(delegate: self)
        viewSignal.observeValues() { [weak self] value in
            switch (value) {
                
            case .log_in(let id):
//                print("RECEIVE VIEW LOG IN MESSAGE FOR ID \(id)")
                guard let index = self?.specialists.getIndex(id: id),
                    let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SpecialistTableViewCell else {
                    break
                }
                cell.setAvailableStatus()
                break
            case .log_out(let id):
//                print("RECEIVE VIEW LOG OUT MESSAGE FOR ID \(id)")
                guard let index = self?.specialists.getIndex(id: id),
                    let cell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SpecialistTableViewCell else {
                        break
                }
                cell.setBusyStatus()
                break
            case .callOffer(let idFrom):
                guard let index = self?.specialists.getIndex(id: idFrom) else {
                        break
                }
//                print("RECEIVE VIEW CALL OFFER MESSAGE WITH ID FROM \(idFrom)")
//                print("RECEIVE VIEW MAKE ANSWER FOR ID FROM \(idFrom)")
                self?.specialistViewModelObserver.send(value: SpecialistsViewModelActions.callAnswer(idFrom))
            case .callAnswer(let roomId):
//                print("RECEIVE VIEW CALL ANSWER MESSAGE WITH ID \(roomId)")
                self?.toRoom(roomID: roomId)
            }
        }
        
    }
    
    func toRoom(roomID: String) {
        print("VIEW SHOULD TO ROOM \(roomID)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoCallVC") as? VideoCallViewController else {
            return
        }
        vc.roomID = roomID
//        vc.setRoomId(roomID: roomID)
        self.present(vc, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialistCell", for: indexPath) as? SpecialistTableViewCell else {
            fatalError()
        }
        cell.setContent(specialist: specialists[indexPath.row])
        cell.updateStatus()
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialist = specialists[indexPath.row]
        print("VIEW MAKE OFFER FOR \(specialist.id)")
        specialistViewModelObserver.send(value: SpecialistsViewModelActions.callOffer(specialist.id))
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
