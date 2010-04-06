const KEY_LEFT = 37;
const KEY_UP = 38;
const KEY_RIGHT = 39;
const KEY_DOWN = 40;

$(qfdonline_init);

function qfdonline_init() {
    $(".cell.rating").click(rating_clicked);
    $(".cell.name").click(rating_clicked);
    editable_init();
}

function editable_init() {
    editable_rating_init();
    editable_name_init();
}

function editable_rating_init() {
    $(".cell.rating").editable("/ratings", {
	data: function (value, settings) {
	    var rating = $(".value", $(value)).text();
	    return {"": null, "1": 1, "3": 3, "9": 9, "selected": rating};
	},
	event: "dblclick",
	callback: function (content, settings) { 
	    update_max_ratings($(this));
	},
	id: "", // we'll inject the id into the target URL for RESTful style
	name: "rating[value]",
	submitdata: function (cell_contents, settings) {
	    var rating_value = $(":selected", this).val();
	    var pri_req_id = $(".pri_req_id", $(cell_contents)).html();
	    var sec_req_id = $(".sec_req_id", $(cell_contents)).html();
	    var rating_id = $(".rating_id", $(cell_contents)).html();

	    inject_target_and_method(settings, rating_id, rating_value);

	    return {
		"rating[primary_requirement_id]": pri_req_id,
		"rating[secondary_requirement_id]": sec_req_id
	    };
	},
	type: "select"
    });
}

function update_max_ratings(cell) {
    var row = cell.row();
    var col = cell.col();

    set_max_rating(row, Math.max.apply(this, row.ratings()));
    set_max_rating(col, Math.max.apply(this, col.ratings()));
}

function set_max_rating(row_or_col, value) {
    row_or_col.filter(".maximum").html(value > 0 ? value : "");
}

// dynamically set the target (URL), and method to work with rails's RESTful
// resources
function inject_target_and_method(settings, rating_id, rating_value) {
    if (rating_id) {
	if (rating_value) {
	    settings.method = "PUT";
	} else {
	    settings.method = "DELETE";
	}
	settings.target = "/ratings/" + rating_id;
    } else {
	settings.method = "POST";
	settings.target = "/ratings";
    }
}

function editable_name_init() {
    $(".cell.name").editable("/requirements", {
	data: function (value, settings) {
	    return $(".name", value).text();
	},
	event: "dblclick",
	id: "", // we'll inject the id into the target URL for RESTful style
	method: "PUT", 
	name: "requirement[name]",
	select: true,
	submitdata: function (value, settings) {
	    var req_id = $(".req_id", value).text(); 
	    settings.target = "/requirements/" + req_id;
	},
	type: "text"
    });
}

function rating_clicked() {
    var cell = $(this);
    var matrix = cell.parents(".matrix");
    var row = cell.parents(".row");
    var col = cell.col();

    $(".num", matrix).removeClass("highlight");
    $(".cell", matrix).removeClass("highlight_border");

    cell.row().filter(".num").addClass("highlight");
    cell.col().filter(".num").addClass("highlight");
    cell.addClass("highlight_border");
}

function body_onkeypress(event) {
    switch (event.keyCode) {
    case KEY_LEFT:
	console.log("left");
	break;
    case KEY_UP:
	console.log("up");
	break;
    case KEY_RIGHT:
	console.log("right");
	break;
    case KEY_DOWN:
	console.log("down");
	break;
    };
}
