# MediCure - Your Personal Health Companion

MediCure is a comprehensive health application that combines medical prescription management with food analysis and medical consultation features. The app helps users organize their medical routines, analyze food nutrition, and get AI-powered medical advice.

## Features

- **Medical Prescription Management**: Convert unorganized medical routines into well-formatted, shareable images
- **Food Analysis**: Upload food images to get detailed nutritional information
- **Medical Consultation**: Get AI-powered medical advice based on food analysis and health conditions
- **User Authentication**: Sign up/login to save history and track health data
- **History Management**: View and manage your medical prescriptions, food analyses, and consultations
- **Secure Storage**: All sensitive data is encrypted and stored securely

## Demo

https://github.com/user-attachments/assets/737a68b7-d57e-455b-bead-392e6748a1ca

## Architecture

The application follows a client-server architecture:

- **Frontend**: Flutter mobile application
- **Backend**: Flask server with AI integration
- **Database**: MongoDB for data storage
- **AI Services**: Google Gemini API for text and vision processing

## Workflow

### Medical Prescription Processing
1. User enters unorganized medical routine text
2. Text is sent to Gemini API to generate organized HTML
3. Server converts HTML to screenshot using Selenium/WeasyPrint
4. Image is saved and returned to user
5. If user is logged in, image is saved to history
6. Shareable link is generated for easy sharing

### Food Analysis
1. User uploads food image
2. Image is processed using Gemini Vision API
3. Nutritional information is extracted and formatted
4. Results are displayed with detailed breakdown
5. Option to get medical consultation based on analysis

### Medical Consultation
1. User provides food analysis data and medical conditions
2. AI analyzes compatibility and safety
3. Detailed medical recommendations are provided
4. Consultation is saved to user history

## Setup Instructions

### Prerequisites

- **Flutter**: [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Python 3.8+**: [Download and Install](https://www.python.org/downloads/)
- **MongoDB**: [Installation Guide](https://docs.mongodb.com/manual/installation/)
- **Chrome Browser**: Required for Selenium WebDriver

### MongoDB Setup

1. **Install and Start MongoDB**:
   ```bash
   # Start MongoDB service
   mongod
   ```

2. **Create Database and Collections**:
   ```bash
   # Open MongoDB shell
   mongo
   
   # Create database
   use vitron
   
   # Create collections
   db.createCollection("users")
   db.createCollection("history")
   db.createCollection("food_history")
   db.createCollection("medical_consultations")
   ```

### Flask Server Setup

1. **Navigate to Flask Server Directory**:
   ```bash
   cd flask-server
   ```

2. **Create Virtual Environment** (recommended):
   ```bash
   python -m venv venv
   
   # Activate virtual environment
   # On Windows:
   venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up Environment Variables**:
   ```bash
   # Create .env file from template
   cp .env.example .env
   ```
   
   Edit `.env` file and add your Gemini API key:
   ```env
   GEMINI_API_KEY=your_actual_gemini_api_key_here
   ```

5. **Run the Flask Server**:
   ```bash
   python app.py
   ```

   The server will start on `http://localhost:5000`

### Flutter App Setup

1. **Navigate to Flutter Project Directory**:
   ```bash
   cd /path/to/flutter-vitron
   ```

2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Update Configuration**:
   - Open `lib/variables.dart`
   - Update server URLs and MongoDB connection string as needed
   - Ensure the server URL matches your Flask server address

4. **Run the Flutter App**:
   ```bash
   # For development (Android emulator)
   flutter run
   
   # For specific device
   flutter run -d <device_id>
   
   # To see available devices
   flutter devices
   ```

## API Configuration

### Getting Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Add the key to your `.env` file in the flask-server directory

### Server Endpoints

- `POST /` - Medical prescription processing and food analysis
- `POST /medical_consultation` - AI-powered medical consultation
- `GET /static/<filename>` - Serve generated images

## Project Structure

```
flutter-vitron/
├── lib/                    # Flutter app source code
│   ├── main.dart          # Main application entry point
│   ├── food_analysis.dart # Food analysis screens
│   ├── database.dart      # MongoDB operations
│   ├── services.dart      # API and utility services
│   ├── variables.dart     # Configuration variables
│   └── storage.dart       # Secure local storage
├── flask-server/          # Backend server
│   ├── app.py            # Main Flask application
│   ├── requirements.txt  # Python dependencies
│   ├── .env             # Environment variables (not in git)
│   └── static/          # Generated images storage
├── android/              # Android-specific files
└── README.md            # This file
```

## Security Features

- **Environment Variables**: Sensitive data stored in `.env` files
- **Secure Storage**: Flutter secure storage for local data
- **API Key Protection**: Keys never exposed in client code
- **Data Encryption**: User data encrypted before storage
- **Auto-cleanup**: Temporary files automatically deleted

## Important Security Notes

- **Never commit `.env` files** to version control
- **Keep API keys secure** and rotate them regularly
- **Validate all user inputs** on both client and server
- **Use HTTPS** in production environments
- **Implement rate limiting** for API endpoints

## Development

### Adding New Features

1. **Database Changes**: Update `database.dart` for new collections/operations
2. **API Endpoints**: Add new routes in `flask-server/app.py`
3. **UI Components**: Create new screens in the `lib/` directory
4. **Configuration**: Update `variables.dart` for new settings

### Testing

```bash
# Run Flutter tests
flutter test

# Run Flask tests (if implemented)
cd flask-server
python -m pytest
```

### Building for Production

```bash
# Build Flutter app
flutter build apk --release  # For Android
flutter build ios --release  # For iOS

# Deploy Flask server with proper WSGI server
pip install gunicorn
gunicorn app:app
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Languages and Tools

<p align="left"> 
<a href="https://dart.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/> </a> 
<a href="https://flask.palletsprojects.com/" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/pocoo_flask/pocoo_flask-icon.svg" alt="flask" width="40" height="40"/> </a> 
<a href="https://flutter.dev" target="_blank" rel="noreferrer"> <img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> </a> 
<a href="https://www.mongodb.com/" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-original-wordmark.svg" alt="mongodb" width="40" height="40"/> </a> 
<a href="https://www.python.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg" alt="python" width="40" height="40"/> </a> 
<a href="https://www.selenium.dev" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/detain/svg-logos/780f25886640cef088af994181646db2f6b1a3f8/svg/selenium-logo.svg" alt="selenium" width="40" height="40"/> </a> 
</p>

## Troubleshooting

### Common Issues

1. **MongoDB Connection Error**:
   - Ensure MongoDB service is running
   - Check connection string in `variables.dart`
   - Verify database and collections exist

2. **Flask Server Issues**:
   - Check if all dependencies are installed
   - Verify `.env` file exists with valid API key
   - Ensure port 5000 is not in use

3. **Flutter Build Issues**:
   - Run `flutter clean` and `flutter pub get`
   - Check Android SDK and Flutter SDK paths
   - Update Flutter to latest stable version

4. **API Key Issues**:
   - Verify Gemini API key is valid and active
   - Check API quotas and billing settings
   - Ensure proper permissions are set

### Getting Help

- Check the [Issues](https://github.com/your-username/flutter-vitron/issues) page
- Create a new issue with detailed problem description
- Include logs and error messages when reporting bugs

## Developers

- [Abhineet Raj](https://github.com/abhineetraj1)
- [Agniva](https://github.com/AgnivaMaiti)

## Acknowledgments

- Google Gemini AI for powerful text and vision processing
- Flutter team for the excellent mobile framework
- MongoDB for reliable data storage
- Open source community for various packages and tools used

---

**Note**: This application provides AI-generated medical advice for informational purposes only. Always consult qualified healthcare professionals for medical decisions and treatment.
