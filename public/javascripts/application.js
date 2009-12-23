$(document).ready(function(){
    var baseURLforJSON = baseURLforSite + "json/";
    var regExp = new RegExp("[0-9]+");

    var opinionURL = baseURLforJSON + "opinion/";
    $(".agree", $("#comments")).click(function(){
        var comment_id = regExp.exec($(this).attr("id"));
        $.getJSON(opinionURL + "?cid=" +comment_id + "&o=a", function (data){
            if ($(data.logged_in)){
                $(data.opinion_div_id).text(data.opinion_data);
            }
        });
    });
    $(".disagree", $("#comments")).click(function(){
        var comment_id = regExp.exec($(this).attr("id"));
        $.getJSON(opinionURL + "?cid=" +comment_id + "&o=d", function (data){
            if ($(data.logged_in)){
                $(data.opinion_div_id).text(data.opinion_data);
            }
        });
    });

    var newURL = baseURLforJSON + "links/";
    var postcount = $(".post").size();
    var postids = new Array();
    $(".post").each(function (i) {
        postids[i] = $(this).attr("id");
    });
    newURL = newURL + "?pc=" + postcount;
    var pi = 0;
    for (pi = 0; pi < postids.length; pi++) {
        newURL = newURL + "&pid" + pi + "=" + regExp.exec(postids[pi]);
    }
    $.getJSON(newURL, function(data){
        $("#usernav", $("#header")).append(data.usernav);
        $("#usernav a.login_link", $("#header"))
                .attr("href", "#")
                .click(function(){
                    $("form:first").submit()
                }
        );
        $("#sitenav .sectbody", $("#sidebar")).append(data.sitenav);
        $.each(data.posts, function(i, post){
            if (post.is_poster){
                $(post.post_div_id + " .poster").show();
            }
            $(post.post_div_id + " .right").html(post.comment_info);
        });
    });
});

$(document).ready(function(){
    var tweetsURL = "http://twitter.com/status/user_timeline/jmischo.json?count=10&callback=?";
     $.getJSON(tweetsURL, function(data){
          $.each(data, function(i, item) {
              $("img#twitterpic", $("#tweetstream"))
                      .attr("src", item.user["profile_image_url"])
                      .show();
              $("#tweetstream", $("#sidebar")).append("<p class='tweet'>"
                        + item.text
                        + "</p>");
          });
      });
});