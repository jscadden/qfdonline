// Some jquery magic to help with HOQ requirements matrices

// creates a jQuery pseudo-selector, :col(x), for finding a column in a matrix
$.expr[":"].col = function (node, index, args, stack) {
    var jq_elem = $(node);
    var col_desired = parseInt(args[3]);
    var row = jq_elem.parents(".row");

    if (0 == row.length) {
	return false;
    }

    return col_desired == row.children().index(jq_elem);
};

// Given a cell, returns an array of the cells within in the same column
// Given a matrix, returns an array of the cells in column 'index'
$.fn.col = function (index) {
    if (null == index) {
	return this.col_of_cell();
    } else if (this.hasClass("row")) {
	return $(":col(" + index + ")", $(this).parents(".matrix"));
    } else if (this.hasClass("matrix")) {
	return $(":col(" + index + ")", $(this));
    } else {
	alert("I don't know how to return a column for this element " + this);
    }
};

$.fn.col_of_cell = function () {
    var cell = $(this);
    var row = cell.parents(".row");
    var col_idx = row.children().index(cell);
    var matrix = row.parents(".matrix");

    return $(":col(" + col_idx + ")", matrix);
};

// Given a cell, returns an array of the cells within in the same row
// Given a matrix, returns an array of the cells in row 'index'
$.fn.row = function (index) {
    if (null == index) {
	return this.parents(".row").children();
    } else if (this.hasClass(".matrix")) {
	return $(".row:eq(" + index + ")", this).children();
    } else {
	alert("I don't know how to return a row for this element " + this);
    }
};

// Return an array of the ratings found within the element, which should
// probably be a row, column, or an array of cells in order to be useful.
$.fn.ratings = function () {
    var values = this.filter(".rating").find(".value");

    return $.map(values, function (elem, index) {
	var value = parseInt($(elem).text());

	return isNaN(value) ? false : value;
    });
};