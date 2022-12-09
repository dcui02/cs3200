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

# Get all customers in the waitlist
@customers.route('/waitlist/all', methods=['GET'])
def get_waitlist():
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

# Get all customers in the waitlist grouped by whether they are still waiting or not
@customers.route('/waitlist/grouped=true', methods=['GET'])
def get_waitlist_grouped():
    json_data = {}
    cursor = db.get_db().cursor()
    
    # calculate average wait time
    cursor.execute('SELECT AVG(waitTime) FROM (SELECT TIMESTAMPDIFF(SECOND, joinTime, exitTime)\
        AS waitTime FROM Waitlist WHERE exitTime IS NOT NULL) AS avgs')
    json_data["Average Wait"] = cursor.fetchone()

    # reformat returned waiting entry rows to JSON objects
    cursor.execute('SELECT * FROM (Waitlist NATURAL JOIN (SELECT customerID, groupSize FROM Customers as sizes) AS wlist)\
        WHERE exitTime IS NULL')
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    upcoming_data = []
    for row in theData:
        upcoming_data.append(dict(zip(row_headers, row)))
    json_data["Waiting"] = upcoming_data

    # reformat returned seated entry rows to JSON objects
    cursor.execute('SELECT * FROM (Waitlist NATURAL JOIN (SELECT customerID, groupSize FROM Customers AS sizes) AS wlist)\
        WHERE exitTime IS NOT NULL')
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    completed_data = []
    for row in theData:
        completed_data.append(dict(zip(row_headers, row)))
    json_data["Seated"] = completed_data

    # construct response
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Add a new customer to the waitlist
@customers.route('/waitlist/enqueue', methods=['POST'])
def enqueue_waitlist():
    cursor = db.get_db().cursor()

    # create new customer
    cursor.execute('INSERT INTO Customers (groupSize) VALUES ({0})'.format(request.form["groupSize"]))
    db.get_db().commit()
    cursor.execute('SELECT MAX(CustomerID) FROM Customers AS last')
    theData = cursor.fetchone()

    # inserts previously created customer into waitlist
    cursor.execute('INSERT INTO Waitlist (customerID, phoneNumber, firstName, lastName) VALUES ({0}, "{1}", "{2}", "{3}")'
        .format(theData[0], request.form["phoneNumber"], request.form["firstName"], request.form["lastName"]))
    db.get_db().commit()

    # construct response
    the_response = make_response()
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Move a customer from the waitlist to a table
@customers.route('/waitlist/dequeue', methods=['POST'])
def dequeue_waitlist():
    cursor = db.get_db().cursor()

    # remove customer from waitlist
    cursor.execute('UPDATE Waitlist SET exitTime = UTC_TIMESTAMP WHERE customerID = {0}'
        .format(request.form["customerID"]))

    # add customer to table
    if request.form["tableID"] != "null":
        cursor.execute('UPDATE Tables SET customerID = {0}, frontWorkerID = {1} WHERE tableID = {2}'
            .format(request.form["customerID"], request.form["frontWorkerID"], request.form["tableID"]))
        cursor.execute('UPDATE Customers SET seatingTime = (UTC_TIMESTAMP) WHERE customerID = {0}'
            .format(request.form["customerID"]))

    db.get_db().commit()

    # construct response
    the_response = make_response()
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response