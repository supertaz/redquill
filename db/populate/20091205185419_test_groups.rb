Group.create(:name =>'Administrators')
u = User.first
u.groups << Group.create(:name => 'Owner')
u.save