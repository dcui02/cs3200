from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint('customers', __name__)

# Get all customers
@customers.route('/all', methods=['GET'])
def get_customers():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM Customers')
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

# Get all food items on the menu
@customers.route('/waitlist', methods=['GET'])
def get_fooditems():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM Waitlist')
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