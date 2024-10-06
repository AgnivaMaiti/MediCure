import pymongo, shutil

myclient = pymongo.MongoClient("mongodb://localhost:27017/")
mydb = myclient["vitron"]
mycol = mydb["history"]

db_img = [i["img"] for i in mycol.find()]

for i in os.listdir("static")
	if i not in db_img:
		shutil.remove(f"static/{i}")
