from flask import Flask, request, jsonify
import numpy as np
import pickle as pkl
import json
from csv import writer
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score

  
app = Flask(__name__)
app.config["DEBUG"] = True


modelfile = 'C:\\Users\\rocio\\Documents\\RR_DataScience-BootcampTheBridge\\4-Productivizacion\\1-Routing\\ejercicios\\ejercicio 2 Flask_API_retrain_db\\ejercicio\\final_model.pickle'

@app.route('/score', methods=['POST']) 
def score():
    model = pkl.load(open(modelfile, 'rb'))
    adv = request.get_json().values()
    data = np.array(list(adv)).reshape(1, -1)
    prediction = int(model.predict(data)[0])
    return f'<h1>¿Cuáles son las ventas esperadas?</h1><p>Las ventas serán de {prediction}€</p>'

@app.route('/update', methods=['POST']) 
def update():
    file_name = "C:\\Users\\rocio\\Documents\\RR_DataScience-BootcampTheBridge\\4-Productivizacion\\1-Routing\\ejercicios\\ejercicio 2 Flask_API_retrain_db\\ejercicio\\Advertising.csv"
    adv = request.get_json().values()
    list_of_elem = list(adv)
    print("Lista de elementos")
    print(list_of_elem)
    with open(file_name, 'a', newline='') as write_obj:
        csv_writer = writer(write_obj)
        csv_writer.writerow(list_of_elem)
        write_obj.close()
        print(" Ya hemos escrito en el fichero")
    
    return f'<h1>Se han insertado los datos nuevos en el fichero CSV</p>'


@app.route('/retrain', methods=['POST']) 
def retrain():
    adv_retrain = pd.read_csv("C:\\Users\\rocio\\Documents\\RR_DataScience-BootcampTheBridge\\4-Productivizacion\\1-Routing\\ejercicios\\ejercicio 2 Flask_API_retrain_db\\ejercicio\\Advertising.csv")
    X_retrain=adv_retrain[["TV","radio","newspaper"]]
    y_retrain=adv_retrain["sales"]
    model_retrain = LinearRegression()
    model_retrain = model_retrain.fit(X_retrain, y_retrain)
    pkl.dump(model_retrain, open(modelfile, 'wb'))
    
    return f'<h1>Se ha reentrenado el modelo</p>'


    
  
app.run(port=5000)


