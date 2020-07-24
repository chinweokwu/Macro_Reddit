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

## Playing with Associations
1. Create your Post model by referencing your data plan from the first step above, migrate the database, and add its validations.

```sh
morah@morah-HP-2000-Notebook-PC:~/reddit$ rails generate model Post title:string body:text user:references

Running via Spring preloader in process 14569
      invoke  active_record
      create    db/migrate/20200724013723_create_posts.rb
      create    app/models/post.rb
      invoke    test_unit
      create      test/models/post_test.rb
      create      test/fixtures/posts.yml
```
```sh
 morah@morah-HP-2000-Notebook-PC:~/reddit$ rails db:migrate

 == 20200724013723 CreatePosts: migrating ======================================
-- create_table(:posts)
  -> 0.0102s
== 20200724013723 CreatePosts: migrated (0.0103s) =============================
```

```sh
class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

end
```

2. Test your validations from the console, remembering to reload or relaunch it between changes.

```sh
irb(main):021:0> reload!
Reloading...
=> true
irb(main):022:0> Post.all
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation []>
irb(main):023:0> p = Post.new
irb(main):024:0> p.valid?
=> false
```

3. Now set up your associations between User and Post models. Did you remember to include the foreign key column (user_id) in your posts table? If not, you can just add a new migration ($ rails generate migration yourmigrationname) and use the #add_column method mentioned above.
 
```sh
class User < ApplicationRecord
   ...

    has_many :posts
end
```
```sh
class Post < ApplicationRecord
  ...  

  belongs_to :user
end
```
4. If you’ve properly set up your associations, you should be able to use a few more methods in the console, including finding a User’s Posts and finding the Post’s User. First test finding your lonely User’s Posts – > User.first.posts. It should be an empty array since you haven’t created posts, but it shouldn’t throw an error at you.

```sh
irb(main):033:0> Post.all
  Post Load (14.5ms)  SELECT  "posts".* FROM "posts" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation []>

irb(main):034:0> p = Post.new(title: 'First Post', body: 'It gonna be a bright, bright sunshining day', user_id: 1)

irb(main):035:0> p.save
   (0.1ms)  begin transaction
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Create (16.3ms)  INSERT INTO "posts" ("title", "body", "user_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["title", "First Post"], ["body", "It gonna be a bright, bright sunshining day"], ["user_id", 1], ["created_at", "2020-07-24 02:08:27.954229"], ["updated_at", "2020-07-24 02:08:27.954229"]]
   (91.2ms)  commit transaction
=> true

irb(main):036:0> User.first.posts
  User Load (0.6ms)  SELECT  "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT ?  [["LIMIT", 1]]
  Post Load (0.3ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."user_id" = ? LIMIT ?  [["user_id", 1], ["LIMIT", 11]]
=> #<ActiveRecord::Associations::CollectionProxy [#<Post id: 1, title: "First Post", body: "It gonna be a bright, bright sunshining day", user_id: 1, created_at: "2020-07-24 02:08:27", updated_at: "2020-07-24 02:08:27">]>

irb(main):037:0> Post.first.user
  Post Load (0.3ms)  SELECT  "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT ?  [["LIMIT", 1]]
  User Load (0.1ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> #<User id: 1, username: "Morah", email: "paul@email.com", password: "123456", created_at: "2020-07-24 01:13:56", updated_at: "2020-07-24 01:13:56">
```
6. Create more user and posts, don't forget to add  a user_id in post.

## Add in Commenting

1. You’ve now got a User and a Post and they’ve been linked. Commenting will look quite similar to your Post model but will be related not just to the post who is its “parent” but also to the user who has authored it. Set up the migration and migrate the database for your Comment model.

```sh
morah@morah-HP-2000-Notebook-PC:~/reddit$ rails generate model Comment body:string user:references post:references

Running via Spring preloader in process 17915
      invoke  active_record
      create    db/migrate/20200724033009_create_comments.rb
      create    app/models/comment.rb
      invoke    test_unit
      create      test/models/comment_test.rb
      create      test/fixtures/comments.yml

rails db:migrate
```
2. As before, add validations into your model and test them out in the console (refresh it!). Make sure you’ve required the two foreign keys (for posts and users) to be submitted, otherwise you could potentially have an orphan comment. You should not be able to save an invalid Comment and be able to save a valid Comment.

```sh
class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :post
end

class User < ApplicationRecord
    validates :username, presence: true, length: { maximum: 25 }
    validates :email, presence: true
    validates :password, presence: true, length: { in: 5..16 }

    has_many :posts
    has_many :comments
end

class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  belongs_to :user
  has_many :comments
end
```
3. Build a second user and create a new comment which represents this user commenting on the first user’s post.

```sh
irb(main):051:0> com1 = Comment.new( body: "great jobs guys", user_id: 1, post_id:1)
irb(main):052:0> com1.save
  User Load (0.6ms)  SELECT  "users".* FROM "users" WHERE "users"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
  Comment Create (1.4ms)  INSERT INTO "comments" ("body", "user_id", "post_id", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["body", "
   (165.4ms)  commit transaction
=> true
```