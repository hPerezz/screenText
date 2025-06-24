# screenText

A macOS utility that captures a selected area of your screen and extracts text from it using OCR (Optical Character Recognition). The extracted text is automatically copied to your clipboard for easy use.

## Features

- **Screen Area Selection**: Interactive screen capture using macOS's built-in screencapture tool
- **OCR Processing**: Uses Apple's Vision framework for accurate text recognition
- **Clipboard Integration**: Automatically copies recognized text to clipboard
- **Fast Processing**: Optimized for quick text extraction
- **Error Handling**: Comprehensive error messages and validation

## Requirements

- **macOS 10.15 (Catalina) or newer** - Required for Vision framework OCR
- **Xcode Command Line Tools** - For compiling Swift code
- **Screen Recording Permission** - macOS will prompt for this on first run

## Installation & Usage

### Method 1: Direct Compilation (Recommended)

1. **Clone or download the project**:
   ```bash
   git clone <repository-url>
   cd screen2text
   ```

2. **Compile the Swift file**:
   ```bash
   swiftc MyApp.swift -o screen2text
   ```

3. **Run the application**:
   ```bash
   ./screen2text
   ```

### Method 2: Create an Executable Script

1. **Make the script executable**:
   ```bash
   chmod +x MyApp.swift
   ```

2. **Run directly** (requires Swift to be in PATH):
   ```bash
   swift MyApp.swift
   ```

## How to Use

1. **Run the application** using one of the methods above
2. **Select screen area**: A crosshair cursor will appear - click and drag to select the area containing text
3. **Wait for processing**: The app will process the image and extract text
4. **Text is copied**: The recognized text is automatically copied to your clipboard
5. **View results**: The extracted text is also displayed in the terminal

## Example Output

```
✅ OCR result copied to clipboard:

Hello World!
This is some sample text
that was captured from the screen.
```

## Troubleshooting

### Permission Issues
- **Screen Recording**: If prompted, grant screen recording permission in System Preferences > Security & Privacy > Privacy > Screen Recording
- **Accessibility**: May need accessibility permissions for clipboard access

### Compilation Issues
- **Xcode Command Line Tools**: Install with `xcode-select --install`
- **Swift version**: Ensure you have a recent version of Swift installed

### OCR Issues
- **No text found**: Ensure the selected area contains clear, readable text
- **Poor recognition**: Try selecting a larger area or ensure text has good contrast
- **Language support**: Currently optimized for English (en-US)

## Technical Details

- **Screen Capture**: Uses macOS `screencapture` command-line tool
- **OCR Engine**: Apple's Vision framework with VNRecognizeTextRequest
- **Image Processing**: Converts NSImage to CGImage for Vision processing
- **Threading**: Uses DispatchSemaphore for synchronous OCR processing
- **Error Handling**: Comprehensive validation and error reporting

## Customization

### Change Recognition Language
Edit line 58 in `MyApp.swift`:
```swift
request.recognitionLanguages = ["pt-BR"] // For Portuguese
```

### Adjust Recognition Level
Edit line 56 in `MyApp.swift`:
```swift
request.recognitionLevel = .accurate  // For better accuracy (slower)
```

## License

This project is open source. Feel free to modify and distribute as needed.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
