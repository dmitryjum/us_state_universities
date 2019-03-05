DOCUMENTATION: http://usastateuniversities.herokuapp.com/api_docs

API server that daily reads Wikipedia page: "https://en.wikipedia.org/wiki/List_of_state_universities_in_the_United_States college", looks up college pages from the list on the page, parses college info into hashes and saves in DB, updates existing and adds new ones. It contains around 600 state colleges. User can query colleges by their name or any additional details as well as update college details. The server is built with Ruby on Rails and PostgreSQL DB with TDD pattern. In current stage database contains one Schools table with 'title:string' and 'details:jsonb' rows. Postgres Jsonb datatype allows the server to update DB with new schools with any possible new attributes and their values without migrations.

## Local Environment Setup

### Local software prerequisites
- Git
- Ruby 2.6.0
- Rails 5.2.1
- PostgreSQL 9.4.4
### Install all gems
```
bundle install
```

### Setup DB
```
rake db:create
```

### Run migrations
```
rake db:migrate
```

### Run tests
```
rspec
```

### Run the application
```
rails s
```

### See available routes
```
rake routes
```

### Check progress
```
git log
```

Use Postman app or similar to make test requests. Read test suite to learn all potential functionality.
The application requires to receive JWT token in Authorization headers to update a school.