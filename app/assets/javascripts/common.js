$(document).ready(function () {
    $('.typeahead').typeahead({
        source:function (query, process) {
            return $.get('/users/typeahead.json', { query:query }, function (data) {
                return process(data.options);
            });
        }
    });
    $(window).resize(); //on page load

    $('.bottom_tooltip').tooltip({
        placement: 'bottom'
    });
    $('.left_tooltip').tooltip({
        placement: 'left'
    });
    $('.right_tooltip').tooltip({
        placement: 'right'
    });
    $('.top_tooltip').tooltip();
});

$(window).resize(function(){
    var height = $(this).height() - $(".blue.navbar").height() + $("#footer").height()
    $('#content').css('min-height', height);
});
