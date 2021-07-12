
import UIKit
import AVFoundation
import Photos

public enum RRDevicePrivacyType {
    case camera
    case photo
}

public enum RRDeviceAuthorizationStatus {
    case unknow
    case notDetermined
    case restricted
    case denied
    case authorized
    case limited
}

public typealias authorizationResult = (RRDevicePrivacyType, RRDeviceAuthorizationStatus) -> Void

public class RRDeviceAuthorizationTools : NSObject {
    public class func deviceAuthorization(_ isRequset : Bool, _ mediaType: RRDevicePrivacyType, _ result : @escaping authorizationResult) {
        switch mediaType {
        case .camera:
            RRDeviceAuthorizationTools.cameraAuthorization(isRequset, result: result)
        case .photo:
            RRDeviceAuthorizationTools.photoAuthorization(isRequset, result: result)
        }
    }
    
    private class func cameraAuthorization(_ isrequset : Bool, result: @escaping authorizationResult) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
                case .notDetermined:
                    if isrequset {
                        AVCaptureDevice.requestAccess(for: .video) { (agree) in
                            if agree {
                                result(.camera, .authorized)
                            }
                            else {
                                result(.camera, .denied)
                            }
                        }
                    }
                    else {
                        result(.camera, .notDetermined)
                }
                case .authorized:
                    result(.camera, .authorized)
                case .denied:
                    result(.camera, .denied)
                case .restricted:
                    result(.camera, .restricted)
                @unknown default:
                    result(.camera, .unknow)
            }
        }
        else {
            result(.camera, .unknow)
        }
    }
    
    private class func photoAuthorization(_ isrequset : Bool, result: @escaping authorizationResult) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
                case .notDetermined:
                    if isrequset {
                        PHPhotoLibrary.requestAuthorization { (Status) in
                            switch Status {
                                case .authorized:
                                    result(.photo, .authorized)
                                case .denied:
                                    result(.photo, .denied)
                                case .notDetermined:
                                    result(.photo, .notDetermined)
                                case .restricted:
                                    result(.photo, .restricted)
                                case .limited :
                                    result(.photo, .limited)
                                @unknown default:
                                    result(.photo, .unknow)
                            }
                        }
                    }
                    else {
                        result(.photo, .notDetermined)
                }
                case .authorized:
                    result(.photo, .authorized)
                case .denied:
                    result(.photo, .denied)
                case .restricted:
                    result(.photo, .restricted)
                case .limited :
                    result(.photo, .limited)
                @unknown default:
                    result(.photo, .unknow)
            }
        }
        else {
            result(.photo, .unknow)
        }
    }
}

public func albumLimitAuthorisa() -> Bool {
    if #available(iOS 14.0, *) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return status == .limited
    } else {
        return false
    }
}
