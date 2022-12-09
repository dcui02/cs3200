from flask import Blueprint, request, jsonify, make_response
import json
from src import db


tables = Blueprint('tables', __name__)

# Get all tables
@tables.route('/all', methods=['GET'])
def get_tables():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute("SELECT tableID, Tables.frontWorkerID, workerName, Tables.customerID, capacity, typeName, seatingTime\
        FROM ((((Tables NATURAL JOIN TableTypes) LEFT JOIN\
        (SELECT customerID, seatingTime FROM Customers) AS seats ON Tables.customerID = seats.customerID)) LEFT JOIN\
        (SELECT frontWorkerID, CONCAT(firstName, ' ', lastName) AS workerName FROM FrontWorkers)\
            AS workers ON Tables.frontWorkerID = workers.frontWorkerID)\
        ORDER BY tableID")
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

# clear a table
@tables.route('/clear', methods=['POST'])
def clear_table():
    cursor = db.get_db().cursor()
    cursor.execute('UPDATE Tables SET frontWorkerID = NULL, customerID = NULL WHERE tableID = {0}'.format(
        request.form['tableID']))
    db.get_db().commit()
    
    # construct response
    the_response = make_response()
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response