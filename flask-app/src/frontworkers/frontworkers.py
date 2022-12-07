from flask import Blueprint, request, jsonify, make_response
import json
from src import db


frontworkers = Blueprint('frontworkers', __name__)

# Get all front of house workers
@frontworkers.route('/', methods=['GET'])
def get_frontworkers():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM FrontWorkers')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get front of house worker of given ID
@frontworkers.route('/frontWorkerID=<frontWorkerID>', methods=['GET'])
def get_frontworker(frontWorkerID):
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM FrontWorkers WHERE frontWorkerID = {0}'.format(frontWorkerID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    
    # construct response
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response