const KEY_LEFT = 37;
const KEY_UP = 38;
const KEY_RIGHT = 39;
const KEY_DOWN = 40;
const BUTTON_MOUSE_RIGHT = 2;
const CUT_REQ_ID = "cut_req_id";


$(qfdonline_init);

function qfdonline_init() {
    $(".cell.rating").click(rating_clicked);
    $(".cell.name").click(rating_clicked);
    $(".num").mouseup(num_clicked); 
    editable_init();
    column_context_menu_init();
    row_context_menu_init();
}

function editable_init() {
    editable_rating_init();
    editable_name_init();
    editable_weight_init();
}

function editable_weight_init() {
    $(".cell.first_hoq.weight").editable("/requirements", {
	data: function (value, settings) {
	    return $(".value", $(value)).text();
	},
	event: "dblclick",
	id: "", // we'll inject the id into the target URL for RESTful style
	method: "PUT",
	name: "requirement[weight]",
	select: true,
	submitdata: function (cell_contents, settings) {
	    var req_id = $(".req_id", $(cell_contents)).html();
	    inject_weight_target(settings, req_id);
	    return {};
	}
    });
}

function inject_weight_target(settings, req_id) {
    settings.target = "/requirements/" + req_id;
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

function column_context_menu_init() {
    $(".row:first-child .cell.num").contextMenu({
	menu: "column_menu"
    },
    function (action, element, pos) {
	var sibling_id = $(".req_id", $(element).col()[4]).text();
	var name = "New Requirement";
	var requested_position = 1;
	var matrix = $(element).parents(".matrix").eq(0);
	var cut_req_id = matrix.data(CUT_REQ_ID);

	switch (action) {
	case "cut":
	    cut_requirement(sibling_id, element);
	    break;
	case "delete":
	    delete_requirement(sibling_id);
	    break;
	case "insert_after":
	    requested_position = parseInt($(element).text()) + 1;
	    insert_requirement(sibling_id, name, requested_position);
	    break;
	case "insert_before":
	    requested_position = parseInt($(element).text());
	    insert_requirement(sibling_id, name, requested_position);
	    break;
	case "paste_after":
	    requested_position = parseInt($(element).text()) + 1;
	    paste_requirement(cut_req_id, requested_position);
	    break;
	case "paste_before":
	    requested_position = parseInt($(element).text());
	    paste_requirement(cut_req_id, requested_position - 1);
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
    });

}

function row_context_menu_init() {
    $(".row .num:first-child").contextMenu({
	menu: "row_menu"
    },
    function (action, element, pos) {
	var sibling_id = $(".req_id", $(element).row()[4]).text();
	var name = "New Requirement";
	var requested_position = 1;
	var matrix = $(element).parents(".matrix").eq(0);
	var cut_req_id = matrix.data(CUT_REQ_ID);

	switch (action) {
	case "cut":
	    cut_requirement(sibling_id, element);
	    break;
	case "delete":
	    delete_requirement(sibling_id);
	    break;
	case "insert_above":
	    requested_position = parseInt($(element).text());
	    insert_requirement(sibling_id, name, requested_position);
	    break;
	case "insert_below":
	    requested_position = parseInt($(element).text()) + 1;
	    insert_requirement(sibling_id, name, requested_position);
	    break;
	case "paste_above":
	    requested_position = parseInt($(element).text());
	    paste_requirement(cut_req_id, requested_position - 1);
	    break;
	case "paste_below":
	    requested_position = parseInt($(element).text()) + 1;
	    paste_requirement(cut_req_id, requested_position);
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
    });
}

function insert_requirement(sibling_id, name, requested_position) {
    $.post("/requirements", {
	"requirement[sibling_id]": sibling_id,
	"requirement[name]": name,
	"requirement[requested_position]": requested_position
    }, function (data) {
	inject_script(data);
    });
}

function delete_requirement(req_id) {
    $.post("/requirements/" + req_id, {
	"_method": "DELETE"
    }, function (data) {
	inject_script(data);
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

function num_clicked(event) {
    var cell = $(this);
    var matrix = cell.parents(".matrix");

    if (BUTTON_MOUSE_RIGHT == event.button) {
	$(".num", matrix).removeClass("highlight");
	$(".cell", matrix).removeClass("highlight_border").
	    removeClass("backlight");

	cell.addClass("highlight");

	if (cell.closest(".header").length > 0) {
	    cell.col().addClass("backlight");
	} else {
	    cell.row().addClass("backlight");
	}
    }
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

function inject_script(javascript) {
    var head = document.getElementsByTagName("head")[0];
    var script = document.createElement("script");

    script.onload = function () {
	if (head && script.parentNode) {
	    head.removeChild(script);
	}
    };
    $(script).html(javascript);
    head.appendChild(script);
}

function cut_requirement(req_id, element) {
    var matrix = $(element).parents(".matrix").eq(0);
    matrix.data(CUT_REQ_ID, req_id);
    console.log("set cut_req_id to " + 
		$(element).parents(".matrix").data(CUT_REQ_ID));
}

function paste_requirement(req_id, pos) {
    $.post("/requirements/" + req_id, {
	"_method": "PUT",
	"requirement[requested_position]": pos
    }, function (data) {
	inject_script(data);
    });
}