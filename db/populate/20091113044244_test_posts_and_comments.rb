post = Post.new(
        :title => 'In which I discuss stuff in the DB with no link',
        :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. [Sed ornare mi eget mi imperdiet varius.](#) Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus.',
        :poster => User.first
)
post.save
post.comments.create(
        :commenter => User.first,
        :title => 'Just a comment title directly',
        :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare mi eget mi imperdiet varius. Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus. Praesent mauris orci, interdum vel malesuada mollis, ultrices a orci. Nulla eget nisl nec velit convallis volutpat non at sapien. Vestibulum pretium mauris lorem. Curabitur mattis ultricies pharetra. Donec consequat vehicula est, nec gravida nunc sagittis porta. Etiam a neque non ligula lacinia ultrices et at nisl. Mauris sed massa leo, quis commodo ipsum. Sed nisl tellus, mattis at ullamcorper eget, tempor sed orci. Nulla posuere mauris vel mauris commodo luctus vestibulum quis justo. Morbi vehicula commodo turpis a interdum. Praesent et quam in sem consequat laoreet.',
        :agreed => 2,
        :disagreed => 1,
        :shared => 2
)
post.reload
post.comments.create(
        :commenter => User.first,
        :title => 'Just a comment title that is a bit longer, since it is a reply to another comment',
        :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare mi eget mi imperdiet varius. Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus. Praesent mauris orci, interdum vel malesuada mollis, ultrices a orci. Nulla eget nisl nec velit convallis volutpat non at sapien. Vestibulum pretium mauris lorem. Curabitur mattis ultricies pharetra. Donec consequat vehicula est, nec gravida nunc sagittis porta. Etiam a neque non ligula lacinia ultrices et at nisl. Mauris sed massa leo, quis commodo ipsum. Sed nisl tellus, mattis at ullamcorper eget, tempor sed orci. Nulla posuere mauris vel mauris commodo luctus vestibulum quis justo. Morbi vehicula commodo turpis a interdum. Praesent et quam in sem consequat laoreet.',
        :in_reply_to_seqno => 1,
        :agreed => 1,
        :disagreed => 2,
        :shared => 1
)
post = Post.new(
        :title => 'A post in which I say absolutely nothing, which is all greek to you anyway, but need a long title',
        :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. [Sed ornare mi eget mi imperdiet varius.](#) Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus. Praesent mauris orci, interdum vel malesuada mollis, ultrices a orci. Nulla eget nisl nec velit convallis volutpat non at sapien. Vestibulum pretium mauris lorem. Curabitur mattis ultricies pharetra. Donec consequat vehicula est, nec gravida nunc sagittis porta. Etiam a neque non ligula lacinia ultrices et at nisl. Mauris sed massa leo, quis commodo ipsum. Sed nisl tellus, mattis at ullamcorper eget, tempor sed orci. Nulla posuere mauris vel mauris commodo luctus vestibulum quis justo. Morbi vehicula commodo turpis a interdum. Praesent et quam in sem consequat laoreet. ',
        :poster => User.first
)
post.save
