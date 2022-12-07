from flask import Blueprint, request, jsonify, make_response
import json
from src import db


orders = Blueprint('orders', __name__)

# Get all orders
@orders.route('/all', methods=['GET'])
def get_orders():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM Orders')
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

# Get all orders, grouped by whether they are completed or not
@orders.route('/grouped=true', methods=['GET'])
def get_orders_grouped():
    json_data = {}
    cursor = db.get_db().cursor()

    # reformat returned upcoming order rows to JSON objects
    cursor.execute('SELECT * FROM Orders WHERE backWorkerID IS NULL')
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    upcoming_data = []
    for row in theData:
        upcoming_data.append(dict(zip(row_headers, row)))
    json_data["Upcoming"] = upcoming_data

    # reformat returned completed order rows to JSON objects
    cursor.execute('SELECT * FROM Orders WHERE backWorkerID IS NOT NULL')
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    completed_data = []
    for row in theData:
        completed_data.append(dict(zip(row_headers, row)))
    json_data["Completed"] = completed_data

    # construct response
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# update the backWorkerID column of an order
@orders.route('/update/backWorkerID', methods=['POST'])
def update_orders():
    cursor = db.get_db().cursor()
    cursor.execute('UPDATE Orders SET backWorkerID = {0} WHERE orderID = {1}'.format(
        request.form['backWorkerID'], request.form['orderID']))
    db.get_db().commit()
    return "OrderID: " + request.form['orderID'] + ", backWorkerID: " + request.form['backWorkerID']
    # return get_orders_grouped()