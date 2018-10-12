function commit_message(containerID, data) {
    var num_bad_commits = data.bad_commits;
    var types = data.type_counting;

    if (num_bad_commits > 0) {
        var plotdata = [{'type': 'untyped', 'number': num_bad_commits}];
    } else {
        var plotdata = [];
    }
    var sum = parseInt(num_bad_commits);
    Object.keys(types).forEach(function (t) {
        if (parseInt(types[t]) != 0) {
            plotdata.push({'type': t, 'number': types[t]});
            sum += parseInt(types[t]);
        }
    });

    var color = function (d) {
        if (d.type === 'untyped') {
            return '#ED561B';
        } else {
            return '#058DC7';
        }
    };
    if (sum > 0) {
        d3.select('#' + containerID)
            .style('width', '100%')
            .style('background-color', '')
            .html('')
            .selectAll('div')
            .data(plotdata)
            .enter()
            .append('div')
            .style('background-color', color)
            .style('border-style', 'solid')
            .style('border-width', '1px')
            .style('border-color', 'black')
            .style('width', function (d) {
                return 95 * parseInt(d.number) / sum + '%';
            })
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', function (d) {
                return d.type;
            })
            .html(function (d) {
                return parseInt(d.number) > 0 ? d.number : '';
            });
        $('[data-toggle="tooltip"]').tooltip();
    } else {
        d3.select('#' + containerID)
            .html('')
            .append('div')
            .style('width', '100%')
            .html('No Data');
    }
}