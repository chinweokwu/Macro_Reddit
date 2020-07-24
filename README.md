# Microverse Project Title - Building with Active Record
Ruby on Rails
Let’s build Reddit. Well, maybe a very junior version of it called micro-reddit. In this project, you’ll build the data structures necessary to support link submissions and commenting. We won’t build a front end for it because we don’t need to… you can use the Rails console to play around with models without the overhead of making HTTP requests and involving controllers or views.

Full task description: https://www.theodinproject.com/courses/ruby-on-rails/lessons/building-with-active-record-ruby-on-rails.

# TO GET STARTED WITH RUBY ON RAILS

This README would normally document whatever steps are necessary to get the
application up and running.

###  Ruby version

rbenv 2.6.5


###  System dependencies

Rails 6.0.1

Yarn 1.19.1

Ubuntu 20.04 & below

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

```sh
rails generate model User username:string email:string password:string

      invoke  active_record
      create    db/migrate/20200724003440_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml
```
4. Run the migration with $ rails db:migrate.

```sh
rails db:migrate
```

5. Comfirm migration files was created in micro-reddit/db/migrate 

```sh
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
```

## Playing with Validations

1. In a new tab, open up the $ rails console. Try asking for all the users with > User.all. You should get back an empty array (no users yet!). Now create a blank new user and store it to a variable with > u = User.new. This user has been created in the ether of Ruby’s memory but hasn’t been saved to the database yet. Remember, if you’d used the #create method instead of the #new method, it would have just gone ahead and tried to save the new user right off the bat. Instead, we now get to play with it.

```sh
morah@morah-HP-2000-Notebook-PC:~/reddit$ rails console
Running via Spring preloader in process 12034
Loading development environment (Rails 5.2.4.3)
irb(main):001:0> User.all
  User Load (2.0ms)  SELECT  "users".* FROM "users" LIMIT ?  [["LIMIT", 11]]
  => #<ActiveRecord::Relation []>
```
```sh
irb(main):002:0> u = User.new
irb(main):003:0> u.valid?
=> true
```

2. Check whether your new user is actually valid (e.g. will it save if we tried?). > u.valid? will run all the validations. It comes up true… surprise! We haven’t written any validations so that’s to be expected. It’s also a problem because we don’t want to have users running around with blank usernames.

```sh
irb(main):002:0> u = User.new
irb(main):003:0> u.valid?
=> true
```

3. Implement the user validations you thought of in the first step in your app/models/user.rb file. These might involve constraints on the size of the username and that it must be present (otherwise you’ll potentially have users with no usernames!) and that it must be unique.

```sh
class User < ApplicationRecord
    validates :username, presence: true, length: { maximum: 25 }
    validates :email, presence: true
    validates :password, presence: true, length: { in: 5..16 } 
end
```
4. Reload your console using > reload!. You’ll need to do this every time you make changes to your app so the console can reload the current version. If it still seems broken, just > quit out of it and relaunch (sometimes #reload! doesn’t seem to do the trick). Build another new user but don’t save it yet by using > u2 = User.new. Run > u2.valid? again to run the validations and it should come up false. Good.

```sh
    irb(main):008:0> reload!
Reloading...
=> true
```
```sh
irb(main):008:0> reload!
Reloading...
=> true
```
```sh
irb(main):009:0> u2 = User.new
irb(main):010:0> u2.valid?
/home/morah/.rbenv/versions/2.7.0/lib/ruby/gems/2.7.0/gems/i18n-1.8.5/lib/i18n.rb:195: warning: The called method `translate' is defined here
=> false
```

5. How do we find out what went wrong? Rails is helpful because it actually attaches error messages directly onto your user object when you fail validations so you can read into them with the #errors method. Try out > u2.errors to see the errors or, better, > u2.errors.full_messages to return a nice friendly array of messages. If you wrote custom messages into your validations, they will show up here as well.

```sh
irb(main):011:0> u2.errors
=> #<ActiveModel::Errors:0x00007f673857d5e0 @base=#<User id: nil, username: nil, email: nil, password: nil, created_at: nil, updated_at: nil>, @messages={:username=>["can't be blank"], :email=>["can't be blank"], :password=>["can't be blank", "is too short (minimum is 5 characters)"]}, @details={:username=>[{:error=>:blank}], :email=>[{:error=>:blank}], :password=>[{:error=>:blank}, {:error=>:too_short, :count=>5}]}>
irb(main):012:0> u2.errors.full_messages
=> ["Username can't be blank", "Email can't be blank", "Password can't be blank", "Password is too short (minimum is 5 characters)"]
```

6. Create a user who will actually save with > u3 = User.new(your_attributes_here) and run the validations. They should come up true. Save your user with the #save method so you’ve got your first user in the database.

```sh
irb(main):015:0> reload!
Reloading...
=> true
irb(main):016:0> u3 = User.new(username: "Odin", email: "odin@email.com", password: "buzzword")
irb(main):017:0>  u3.valid?
=> true
irb(main):018:0> u3 = User.new(username: "Morah", email: "paul@email.com", password: "123456")
irb(main):019:0> u3.valid?
=> true
irb(main):020:0> u3.save
 begin transaction
  User Create (3.3ms)  INSERT INTO "users" ("username", "email", "password", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["username", "Morah"], ["email", "paul@email.com"], ["password", "123456"], ["created_at", "2020-07-24 01:13:56.355877"], ["updated_at", "2020-07-24 01:13:56.355877"]]
   (86.0ms)  commit transaction
=> true
```

