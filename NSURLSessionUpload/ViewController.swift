import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    var responseData = NSMutableData()
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let path = Bundle.main.path(forResource: "swift", ofType:"png")
        let url = URL(fileURLWithPath: path!)
        let data: Data = try! Data(contentsOf: url) as Data
        let request = NSMutableURLRequest(url: URL(string: "http://127.0.0.1:8000/swift.png")!)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        uploadFiles(request as URLRequest, data: data)
    }
    
    func uploadFiles(_ request: URLRequest, data: Data) {
        let configuration = URLSessionConfiguration.default
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.uploadTask(with: request, from: data)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("session \(session) occurred error \(error?.localizedDescription)")
        } else {
            print("session \(session) upload completed, response: \(NSString(data: responseData as Data, encoding: String.Encoding.utf8.rawValue))")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print("session \(session) uploaded \(uploadProgress * 100)%.")
        progressView.progress = uploadProgress
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("session \(session), received response \(response)")
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData.append(data)
    }
}

