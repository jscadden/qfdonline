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
	type: "select",
	data: function (value, settings) {
	    var sel = $($(value).children()[2]).text();
	    return {"": null, "1": 1, "3": 3, "9": 9, "selected": sel};
	},
	event: "dblclick",
	method: "post", // this might be an issue
	submitdata: function (value, settings) {
	    var pri_req_id = $(".pri_req_id", $(value)).html();
	    var sec_req_id = $(".sec_req_id", $(value)).html();

	    return {
		"rating[primary_requirement_id]": pri_req_id,
		"rating[secondary_requirement_id]": sec_req_id
	    };
	},
	name: "rating[value]"
    });
}

function editable_name_init() {
    $(".cell.name").editable("/requirements", {
	data: function (value, settings) {
	    return $($(value).children()[1]).text();
	},
	type: "text",
	select: true,
	event: "dblclick",
	method: "PUT", 
	name: "requirement[name]",
	submitdata: function (value, settings) {
	    var req_id = $($(value).children()[0]).text();
	    settings.target = "/requirements/" + req_id;
	    return {id: req_id};
	}
    });
}

function rating_clicked() {
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