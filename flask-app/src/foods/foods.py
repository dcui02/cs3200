from flask import Blueprint, request, jsonify, make_response
import json
from src import db


foods = Blueprint('foods', __name__)

# Get all food items
@foods.route('/items/all', methods=['GET'])
def get_fooditems():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM FoodItems')
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

# Get all foods of a type by given ID
@foods.route('/items/foodTypeID=<foodTypeID>', methods=['GET'])
def get_foodtype_fooditems(foodTypeID):
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM FoodItems WHERE foodTypeID = {0}'.format(foodTypeID))
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

# Get all foods, grouped by foodTypeID
@foods.route('/items/grouped=true', methods=['GET'])
def get_foodtypes_fooditems():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM FoodTypes')
    json_data = {}
    foodtypes = cursor.fetchall()
    for foodtype in foodtypes:
        foodtype_data = []
        cursor.execute('SELECT * FROM FoodItems WHERE foodTypeID = {0}'.format(foodtype[0]))
        row_headers = [x[0] for x in cursor.description]
        theData = cursor.fetchall()
        for row in theData:
            foodtype_data.append(dict(zip(row_headers, row)))
        json_data[foodtype[1]] = foodtype_data
    
    # construct response
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all ingredients
@foods.route('/ingredients', methods=['GET'])
def get_ingredients():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM Ingredients')
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

# Get all ingredients in a food by given ID
@foods.route('/ingredients/foodItemID=<foodItemID>', methods=['GET'])
def get_fooditem_ingredients(foodItemID):
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM Ingredients WHERE ingredientID IN\
        (SELECT DISTINCT ingredientID FROM FoodIngredients WHERE foodItemID = {0})'.format(foodItemID))
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

# Get all food tags
@foods.route('/tags', methods=['GET'])
def get_tags():
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM ItemTags')
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

# Get all tags of a food by given ID
@foods.route('/tags/foodItemID=<foodItemID>', methods=['GET'])
def get_fooditem_tags(foodItemID):
    cursor = db.get_db().cursor()

    # reformat returned rows to JSON objects
    cursor.execute('SELECT * FROM ItemTags WHERE tagID IN\
        (SELECT DISTINCT tagID FROM FoodTags WHERE foodItemID = {0})'.format(foodItemID))
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

# Get all ingredients and tags of a food by given ID
@foods.route('/items/details/foodItemID=<foodItemID>', methods=['GET'])
def get_fooditem_details(foodItemID):
    json_data = {}
    cursor = db.get_db().cursor()

    # reformat returned ingredient rows to JSON objects
    cursor.execute('SELECT * FROM Ingredients WHERE ingredientID IN\
        (SELECT DISTINCT ingredientID FROM FoodIngredients WHERE foodItemID = {0})'.format(foodItemID))
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    ingredient_data = []
    for row in theData:
        ingredient_data.append(dict(zip(row_headers, row)))
    json_data["Ingredients"] = ingredient_data

    # reformat returned tag rows to JSON objects
    cursor.execute('SELECT * FROM ItemTags WHERE tagID IN\
        (SELECT DISTINCT tagID FROM FoodTags WHERE foodItemID = {0})'.format(foodItemID))
    row_headers = [x[0] for x in cursor.description]
    theData = cursor.fetchall()
    tag_data = []
    for row in theData:
        tag_data.append(dict(zip(row_headers, row)))
    json_data["Tags"] = tag_data
    
    # construct response
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

