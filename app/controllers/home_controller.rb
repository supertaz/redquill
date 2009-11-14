class HomeController < ApplicationController
  def index
    @post = Post.new(
            :title => '',
            :body => '',
            :poster => User.first
            )
    @comments = Array.new()
    comment = Comment.new(
            :commenter => User.first,
            :seqno => 1,
            :title => 'Just a comment title',
            :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare mi eget mi imperdiet varius. Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus. Praesent mauris orci, interdum vel malesuada mollis, ultrices a orci. Nulla eget nisl nec velit convallis volutpat non at sapien. Vestibulum pretium mauris lorem. Curabitur mattis ultricies pharetra. Donec consequat vehicula est, nec gravida nunc sagittis porta. Etiam a neque non ligula lacinia ultrices et at nisl. Mauris sed massa leo, quis commodo ipsum. Sed nisl tellus, mattis at ullamcorper eget, tempor sed orci. Nulla posuere mauris vel mauris commodo luctus vestibulum quis justo. Morbi vehicula commodo turpis a interdum. Praesent et quam in sem consequat laoreet.',
            :agreed => 2,
            :disagreed => 1,
            :shared => 2,
            :created_at => DateTime::now()
    )
    comment2 = Comment.new(
            :commenter => User.first,
            :seqno => 2,
            :title => 'Just a comment title that is a bit longer, since it is a reply to another comment',
            :body => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ornare mi eget mi imperdiet varius. Pellentesque pretium urna sit amet neque eleifend vestibulum. Vivamus in nibh non lacus dignissim mollis iaculis sed metus. Praesent mauris orci, interdum vel malesuada mollis, ultrices a orci. Nulla eget nisl nec velit convallis volutpat non at sapien. Vestibulum pretium mauris lorem. Curabitur mattis ultricies pharetra. Donec consequat vehicula est, nec gravida nunc sagittis porta. Etiam a neque non ligula lacinia ultrices et at nisl. Mauris sed massa leo, quis commodo ipsum. Sed nisl tellus, mattis at ullamcorper eget, tempor sed orci. Nulla posuere mauris vel mauris commodo luctus vestibulum quis justo. Morbi vehicula commodo turpis a interdum. Praesent et quam in sem consequat laoreet.',
            :in_reply_to_seqno => 1,
            :agreed => 1,
            :disagreed => 2,
            :shared => 1,
            :created_at => DateTime::now()
    )
    comment.save
    comment2.save
    @comments[0] = comment
    @comments[1] = comment2
  end
end
