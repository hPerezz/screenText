import Foundation
import Cocoa
import Vision

// MARK: - Capture screen area and return CGImage
func captureSelectedArea() -> CGImage? {
    let tempFile = "\(NSTemporaryDirectory())/\(UUID().uuidString).png"
    
    let task = Process()
    task.launchPath = "/usr/sbin/screencapture"
    task.arguments = ["-i", tempFile]
    task.launch()
    task.waitUntilExit()
    
    guard FileManager.default.fileExists(atPath: tempFile) else {
        print("❌ Failed: No file captured.")
        return nil
    }
    
    guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: tempFile)),
          let nsImage = NSImage(data: imageData) else {
        print("❌ Failed: Could not read image data.")
        return nil
    }
    var rect = NSRect.zero
    guard let cgImage = nsImage.cgImage(forProposedRect: &rect, context: nil, hints: nil) else {
        print("❌ Failed: Could not convert to CGImage.")
        return nil
    }
    
    try? FileManager.default.removeItem(atPath: tempFile)
    return cgImage
}

// MARK: - Perform OCR using Vision
@available(macOS 10.15, *)
func recognizeText(from image: CGImage) -> String {
    var recognizedText = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    let request = VNRecognizeTextRequest { request, error in
        defer { semaphore.signal() }
        
        if let error = error {
            recognizedText = "❌ Vision error: \(error.localizedDescription)"
            return
        }
        
        guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
            recognizedText = "⚠️ OCR found no text in the image."
            return
        }
        
        for observation in observations {
            if let candidate = observation.topCandidates(1).first {
                recognizedText += candidate.string + "\n"
            }
        }
    }
    
    request.recognitionLevel = .accurate 
    request.usesLanguageCorrection = true
    request.recognitionLanguages = ["pt-BR", "en-US"]

    let handler = VNImageRequestHandler(cgImage: image, options: [:])
    do {
        try handler.perform([request])
        semaphore.wait()
    } catch {
        return "❌ OCR processing error: \(error.localizedDescription)"
    }
    
    return recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
}

// MARK: - Copy result to clipboard
func copyToClipboard(_ text: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(text, forType: .string)
}

// MARK: - Main program flow
func main() {
    guard let image = captureSelectedArea() else {
        print("❌ Error: Could not capture screen selection.")
        return
    }

    if #available(macOS 10.15, *) {
        let text = recognizeText(from: image)
        
        if text.isEmpty || text.hasPrefix("⚠️") || text.hasPrefix("❌") {
            print(text)
        } else {
            copyToClipboard(text)
            print("✅ OCR result copied to clipboard:\n")
            print(text)
        }
    } else {
        print("❌ Error: OCR requires macOS 10.15 or newer.")
    }
}

main()