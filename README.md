# Microverse Project Title - Building with Active Record
Ruby on Rails
Let’s build Reddit. Well, maybe a very junior version of it called micro-reddit. In this project, you’ll build the data structures necessary to support link submissions and commenting. We won’t build a front end for it because we don’t need to… you can use the Rails console to play around with models without the overhead of making HTTP requests and involving controllers or views.

Full task description: https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-with-active-record-ruby-on-rails.

# TO GET STARTED

This README would normally document whatever steps are necessary to get the
application up and running.

###  Ruby version

rbenv 2.6.5


###  System dependencies

Rails 6.0.1

Yarn 1.19.1

Ubuntu 18.04 & below

###  Database creation
sqlite3

###  Database initialization

###  How to run the test suite
1. Go to "rails console"
2. Rails test

###  Services (job queues, cache servers, search engines, etc.)

###  Deployment instructions

1. Open the terminal.

2. Enter git clone https://github.com/geraldgsh/micro-reddit/

3. Navigate to the cloned repository.

4. Enter command "rails console" to start the backend 


### ...

### Instructions

1. Just like in the warmup, plan out what data models you would need to allow users to be on the site (don’t worry about login/logout or securing the passwords right now), to submit links (“posts”), and to comment on links. Users do NOT need to be able to comment on comments… each comment refers to a Post.

```sh
USER
    username:string [uniq, max:25 ,present]
    email:string  [uniq, present]
    password:string [uniq, range:5..16, present ] 
    
    has_many :posts
    has_many :comments

POST
    title:string [present]
    body:text [present]

    belongs_to :user
    has_many :comments

COMMENT 
    body:text [present]

    belongs_to :user
    belongs_to :post 
```
2.  Generate a new rails app from the command line ($ rails new reddit) and open it up. We’ll use the default SQLite3 database so you shouldn’t have to change anything on that front.

3. Generate your User model and fill out the migration to get the columns you want.