$(qfdonline_init);


function qfdonline_init() {
    $(".cell.rating").click(cell_clicked);
}

function cell_clicked() {
    var cell = $(this);
    var matrix = cell.parents(".matrix");
    var row = cell.parents(".row");
    var col = column_of(cell);

    $(".num", matrix).removeClass("highlight");
    $(".num", row).addClass("highlight");
    col.filter(".num").addClass("highlight");

    $(".cell", matrix).removeClass("highlight_border");
    cell.addClass("highlight_border");
}

function column_of(jq_elem) {
    var row = jq_elem.parents(".row");
    var col_idx = row.children().index(jq_elem);
    var matrix = jq_elem.parents(".matrix");
    var n_cols = row.children().size();

    return $(".row", matrix).children().filter(function (index) {
	return col_idx == index % n_cols;
    });
}