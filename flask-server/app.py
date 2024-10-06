from flask import*
from flask_cors import CORS
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import os,datetime,requests, shutil

app = Flask(__name__, static_folder="static")

CORS(app)
YOUR_Gemini_API_HERE="YOUR_GEMINI_API_KEY"

def save_screenshot_from_html(filename):
	options = webdriver.ChromeOptions()
	options.add_argument('--headless')
	options.add_argument('--no-sandbox')
	options.add_argument('--disable-dev-shm-usage')
	with webdriver.Chrome(options=options, executable_path="chromedriver.exe") as driver:
		driver.get(f"file://{os.path.abspath(filename)}")
		screenshot_filename = filename.replace('.html', '.png')
		driver.save_screenshot(screenshot_filename)

def gemini_response(prompt):
	return str(requests.post("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=" + YOUR_Gemini_API_HERE, headers={"Content-Type": "application/json"}, json={"contents": [{"parts": [{"text": prompt}]}]}).json()["candidates"][0]["content"]["parts"][0]["text"]).replace("*","")

def rndm():
	return str(datetime.datetime.now()).replace(":","").replace(".","").replace("-","").replace(" ","")

@app.route("/", methods=["POST"])
def index():
	prompt = request.form["data"]+"write the data in html format and medicine routine in <table> with perfect arrangement and css design, only give html structure code, no extra comments or description"
	k= rndm()
	open(k+".html","a").write(gemini_response(prompt).replace("```html","").replace("```",""))
	save_screenshot_from_html(k+".html")
	shutil.move(k+".png","static/"+k+".png")
	os.remove(k+".html")
	return k+".png"

if __name__ == '__main__':
	app.run(debug=True)