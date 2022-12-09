# CS3200 Final Project

## Project Overview
This application streamlines restaurant operations. Because of frequently changing menus/prices, a lot of restaurants are phasing out paper menus for online ordering systems which makes data easily accessible. Customers, servers/hosts, and cooks/food workers will each have access to the information they need to do their respective jobs, and updating that information is simple and will be instantly reflected for all affected personas.

A brief demo video: https://drive.google.com/file/d/1nXqdLZWuyPocCbAthhDyM-zAiOchYZCe/view

## Setup Instructions
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the `webapp` user. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 
