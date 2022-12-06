from flask import Blueprint, request, jsonify, make_response
import json
from src import db


backworkers = Blueprint('backworkers', __name__)

# Get all back workers
@backworkers.route('/all', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM BackWorkers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get back worker by given ID
@backworkers.route('/backWorkerID=<backWorkerID>', methods=['GET'])
def get_customer(backWorkerID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM BackWorkers WHERE backWorkerID = {0}'.format(backWorkerID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response