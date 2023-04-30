//
//  NearbyInteraction.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity


protocol NearbyInteractionManagerDelegate: class {
func didUpdateNearbyObjects(objects: [NINearbyObject])
}

final class NearbyInteractionManager: NSObject, ObservableObject {
    static let instance = NearbyInteractionManager()
    var session: NISession?
    weak var delegate: NearbyInteractionManagerDelegate?
    @Published var object : NINearbyObject? = nil
    
    func setup() {
        session = NISession()
        session?.delegate = self
    }
        
    public var discoveryTokenData: Data {
        guard let token = session?.discoveryToken,
              let data = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("can't convert token to data")
        }
        
        return data
    }
    
    func start(token: NIDiscoveryToken){
        let configuration = NINearbyPeerConfiguration(peerToken: token)
        session?.run(configuration)
    }
}


extension NearbyInteractionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        delegate?.didUpdateNearbyObjects(objects: nearbyObjects)
        self.object = nearbyObjects[0]
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {}
    func sessionWasSuspended(_ session: NISession) {}
    func sessionSuspensionEnded(_ session: NISession) {}
    func session(_ session: NISession, didInvalidateWith error: Error) {}
}

extension NearbyInteractionManager: NearbyInteractionManagerDelegate {
    func didUpdateNearbyObjects(objects: [NINearbyObject]) {
        DispatchQueue.main.async { [weak self] in
            guard let object = objects.first else { return }
            self?.object = object
        }
    }
}
