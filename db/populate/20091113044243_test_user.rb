u = User.new(:username => 'test', :firstname => "Test", :lastname => 'Test', :nickname => 'Test',
             :email => 'test@test.com', :twitter_username => 'test', :user_url => 'www.test.com',
             :password => 'testpass', :password_confirmation => 'testpass')
u.save
u.is_admin
u.is_poster
