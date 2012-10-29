$(document).ready(function () {
    $('.typeahead').typeahead({
        source:function (query, process) {
            return $.get('/users/typeahead.json', { query:query }, function (data) {
                return process(data.options);
            });
        }
    });
    $(window).resize(); //on page load
});

$(window).resize(function(){
    var height = $(this).height() - $(".blue.navbar").height() + $("#footer").height()
    $('#content').css('min-height', height);
});
