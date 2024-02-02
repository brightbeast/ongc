import pyrebase

# config={
#     "apiKey": "AIzaSyBYINCCIaFdjEqotI-EaKqCmyZSWP3d_qw",
#   "authDomain": "ongcfirebase.firebaseapp.com",
#   "projectId": "ongcfirebase",
#   "storageBucket": "ongcfirebase.appspot.com",
#   "messagingSenderId": "933026045781",
#   "appId": "1:933026045781:web:2595b16f024abbe92599dc",
#   "measurementId": "G-NFM5C89GYJ",
#   "databaseURL":"https://ongcfirebase-default-rtdb.firebaseio.com/"
# }

config= {
      "apiKey": "AIzaSyASs6jErWzvKoLhP3EdyCiuLUdvQnsfmfY",
      "authDomain": "fir-ofongc.firebaseapp.com",
      "databaseURL": "https://fir-ofongc-default-rtdb.firebaseio.com",
      "projectId": "fir-ofongc",
      "storageBucket": "fir-ofongc.appspot.com",
      "messagingSenderId": "612044536550",
      "appId": "1:612044536550:web:456d48c8fe1614ceca5927",
      "measurementId": "G-FGDYWW255D",
      "databaseURL":"https://fir-ofongc-default-rtdb.firebaseio.com/"
}
firebase= pyrebase.initialize_app(config)
database= firebase.database()

from flask import Flask, request, jsonify
import json
app= Flask(__name__)

id=1
@app.route("/api", methods=['POST'])
def storeInFirebase():
      print("Running")
      global id
      if request.method == 'POST':
            request_data = request.data
            request_data = json.loads(request_data.decode('utf-8'))
            
            inputName = request_data['name']
            inputAge = request_data['age']
            inputCanteen = request_data['canteen']

            inputData = {'Name': inputName, 'Age': inputAge, 'Like Canteen': inputCanteen}
            database.child("Employee").child(f"User{id}").set(inputData)
            print("RUNNING FINE")

            print(inputData)
            id += 1
            return jsonify(inputData)

@app.route("/data", methods=['POST'])
def getData():
      try:
            data = [doc.val() for doc in database.child('Employee').get().each()]
            # print(jsonify(data))
            return jsonify(data)
            
      except Exception as e:
            return f"Error: ${e}"

@app.route("/localDatabase", methods=['POST'])
def storeToFirebase():
  print("done")
  global id
  if request.method =='POST':
    request_data= request.data
    request_data= json.loads(request_data.decode('utf-8'))

    inputName= request_data['Name']
    inputAge = request_data['Age']
    inputCanteen = request_data['Canteen']
    
    print(request_data)

    inputData={"Age": inputAge, "Name": inputName, "Like Canteen": inputCanteen}
      # database.child(f"User${id}").set(data)
    database.child("Employee").child(f"User{id}").set(inputData)
    print(inputData)
    id+=1
    return "Successful"

@app.route("/")
def search():
#     ref= database.child("/")
#     res= ref.get().val()
#     return res
      return "Hello"

if __name__== "__main__":
      app.run(port=5000,debug= True)