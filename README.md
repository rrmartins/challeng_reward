# Coding Challenge Reward System

I did the project using each line of the file as an access node, and so each node has its characteristics, and with that it was doing the calculations.

To simplify and to see the need to have a database for future queries, some kind of data base was not used. Staying 100% with ruby and rails.

I have only 1 controller (`Invites::CalculatesController`) to call 1 service (`app/services/invites`), which I had similarity to a template structure is inside the `lib` folder, since they are not in themselves Rails ActiveRecord templates.

We created a simple structure, where each node knows about the parent node, so when we have the acceptance check of the invitation or not, we only update the parent node and look for levels (1 point, 0.5 points, 0.25 points , and so on).

Follow my instructions for setup, tests and run.

### Requirements:
 - `Ruby version >= 2.5.1`

### Installing:
 - `bundle install`

### Testing:
 - `bundle exec rspec`

### Running with success:
 - `bundle exec rails s -p 3000`
 - `curl -i -H "Accept: application/json" -X GET -F 'file=@invites_ok.txt' http://localhost:3000/invites/calculate`

### Running with any error:
 - `bundle exec rails s -p 3000`
 - `curl -i -H "Accept: application/json" -X GET -F 'file=@README.md' http://localhost:3000/invites/calculate`

PS: In order to better visualize the json output, [Postman](https://www.getpostman.com/) was used.


regards,

Rodrigo Martins

email: rrmartinsjg@gmail.com

phone: +55 11 99483-3250
