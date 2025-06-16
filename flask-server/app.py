from flask import Flask, request, jsonify
from flask_cors import CORS
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import os, datetime, requests, shutil, json, base64
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__, static_folder="static")
CORS(app)

# Get API key from environment variables
YOUR_Gemini_API_HERE = os.getenv('GEMINI_API_KEY')

if not YOUR_Gemini_API_HERE:
    raise ValueError("GEMINI_API_KEY environment variable is not set. Please check your .env file.")

def save_screenshot_from_html(filename):
    """Convert HTML file to screenshot"""
    try:
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--disable-gpu')
        options.add_argument('--window-size=1920,1080')
        
        # Use ChromeDriverManager for automatic driver management
        from webdriver_manager.chrome import ChromeDriverManager
        service = Service(ChromeDriverManager().install())
        
        with webdriver.Chrome(service=service, options=options) as driver:
            driver.get(f"file://{os.path.abspath(filename)}")
            screenshot_filename = filename.replace('.html', '.png')
            driver.save_screenshot(screenshot_filename)
            
    except Exception as e:
        print(f"Screenshot error: {e}")
        # Fallback to weasyprint if selenium fails
        try:
            from weasyprint import HTML
            HTML(filename).write_png(filename.replace('.html', '.png'))
        except Exception as fallback_error:
            print(f"Fallback screenshot error: {fallback_error}")

def gemini_response(prompt):
    """Get response from Gemini API"""
    try:
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={YOUR_Gemini_API_HERE}"
        headers = {'Content-Type': 'application/json'}
        data = {
            "contents": [{
                "parts": [{"text": prompt}]
            }]
        }
        response = requests.post(url, headers=headers, json=data)
        return response.json()
    except Exception as e:
        print(f"Gemini API error: {e}")
        return None

def rndm():
    return str(datetime.datetime.now()).replace(":","").replace(".","").replace("-","").replace(" ","")

def gemini_vision_response(image_path, prompt):
    """Analyze image using Gemini Vision API"""
    try:
        with open(image_path, "rb") as image_file:
            image_data = base64.b64encode(image_file.read()).decode('utf-8')
        
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key={YOUR_Gemini_API_HERE}"
        headers = {'Content-Type': 'application/json'}
        data = {
            "contents": [{
                "parts": [
                    {"text": prompt},
                    {
                        "inline_data": {
                            "mime_type": "image/jpeg",
                            "data": image_data
                        }
                    }
                ]
            }]
        }
        response = requests.post(url, headers=headers, json=data)
        return response.json()
    except Exception as e:
        print(f"Gemini Vision API error: {e}")
        return None

@app.route("/", methods=["POST"])
def index():
    # Check if it's a file upload (food analysis) or text data (prescription analysis)
    if 'file' in request.files:
        # Food Analysis
        file = request.files['file']
        if file.filename != '':
            # Save the uploaded file temporarily
            filename = f"temp_{rndm()}.jpg"
            file.save(filename)
            
            # TODO: Replace with actual image analysis
            # Option 1: Use Gemini Vision API
            # Option 2: Use Google Cloud Vision API
            # Option 3: Use other image analysis service
            
            # For now, analyze image content using AI
            food_prompt = f"""
            Analyze this uploaded food image and provide nutritional information.
            If you cannot see the image, return {{"food": "no"}}
            """
            
            # This needs actual image processing
            response = gemini_vision_response(filename, food_prompt)
            os.remove(filename)
            return response
    else:
        # Prescription Analysis (existing functionality)
        prompt = request.form["data"]+"write the data in html format and medicine routine in <table> with perfect arrangement and css design, only give html structure code, no extra comments or description"
        k = rndm()
        open(k+".html","a").write(gemini_response(prompt).replace("```html","").replace("```",""))
        save_screenshot_from_html(k+".html")
        shutil.move(k+".png","static/"+k+".png")
        os.remove(k+".html")
        return k+".png"

@app.route("/medical_consultation", methods=["POST"])
def medical_consultation():
    try:
        food_data = request.form.get('food_data')
        prescription_data = request.form.get('prescription_data')
        
        # Parse food analysis JSON
        try:
            food_analysis = json.loads(food_data)
        except:
            return "Error: Invalid food analysis data", 400
        
        # Create comprehensive medical consultation prompt
        consultation_prompt = f"""
        You are a medical AI assistant. Analyze this food for someone with the following medical conditions and provide detailed health recommendations.

        FOOD NUTRITIONAL DATA:
        - Food: {food_analysis.get('food', 'Unknown')}
        - Calories: {food_analysis.get('calories', 'Unknown')} kcal
        - Sugar: {food_analysis.get('sugar', 'Unknown')}g
        - Ingredients: {', '.join(food_analysis.get('ingredients', []))}
        - Nutrients: {food_analysis.get('nutrients', [])}

        PATIENT'S MEDICAL INFORMATION:
        {prescription_data}

        Please provide a detailed medical analysis covering:

        1. **SAFETY ASSESSMENT**: Is this food SAFE or POTENTIALLY HARMFUL for this person?

        2. **SPECIFIC MEDICAL CONCERNS**: 
           - How does this food interact with their medications?
           - Which nutrients could be problematic given their conditions?
           - Any ingredients to avoid?

        3. **DETAILED RECOMMENDATIONS**:
           - Portion size recommendations
           - Timing considerations (before/after medication)
           - Modifications to make it safer

        4. **ALTERNATIVE SUGGESTIONS**: 
           - Better food options for their condition
           - Nutritional substitutes

        5. **MONITORING ADVICE**:
           - What symptoms to watch for
           - When to consult their doctor

        Provide specific, actionable medical advice while being clear about the limitations of AI medical guidance.
        """
        
        # Get AI response
        medical_advice = gemini_response(consultation_prompt)
        
        return medical_advice
        
    except Exception as e:
        return f"Error in medical consultation: {str(e)}", 500

if __name__ == '__main__':
    app.run(debug=True)