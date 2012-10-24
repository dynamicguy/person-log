$(document).ready(function () {
    $('.typeahead').typeahead({
        source:function (query, process) {
            return $.get('/users/typeahead.json', { query:query }, function (data) {
                return process(data.options);
            });
        }
    });
});