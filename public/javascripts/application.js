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
    $(".cell.weight.first_hoq").click(rating_clicked);
    $(".num").mouseup(num_clicked); 
    editable_init();
    column_context_menu_init();
    row_context_menu_init();
    hide_hidden_primary_requirements();
    hide_hidden_secondary_requirements();
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
	onblur: "submit",
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
	onblur: "submit",
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
	    enable_pasting_for_columns();
	    break;
	case "delete":
	    delete_requirement(sibling_id);
	    break;
	case "hide":
	    hide_secondary_requirement(element);
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
	    disable_pasting_for_columns();
	    break;
	case "paste_before":
	    requested_position = parseInt($(element).text());
	    paste_requirement(cut_req_id, requested_position - 1);
	    disable_pasting_for_columns();
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
    });
    disable_pasting_for_columns();
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
	    enable_pasting_for_rows();
	    break;
	case "delete":
	    delete_requirement(sibling_id);
	    break;
	case "hide":
	    hide_primary_requirement(element);
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
	    disable_pasting_for_rows();
	    break;
	case "paste_below":
	    requested_position = parseInt($(element).text()) + 1;
	    paste_requirement(cut_req_id, requested_position);
	    disable_pasting_for_rows();
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
    });
    disable_pasting_for_rows();
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

function hide_primary_requirement(cell) {
    cell = $(cell);
    var row = cell.parents(".row");
    var hidden_pri_req_id = parseInt($(".req_id", row).eq(0).text());

    set_hidden_primary_requirement(hidden_pri_req_id);
    row.hide();
    cell.parents(".row").after(make_hidden_row_placeholder(cell.row().length));
    $(".row.click_to_show_row").click(function () {
	$(this).prev().show();
	unset_hidden_primary_requirement(hidden_pri_req_id);
	$(this).remove();
    });
}

function hide_secondary_requirement(cell) {
    cell = $(cell);
    var col = cell.col();
    var hidden_sec_req_id = parseInt(col.filter(".cell.name").find(".req_id").text());

    set_hidden_secondary_requirement(hidden_sec_req_id);
    col.hide();
    make_hidden_col_placeholder(cell.col());
    $(".cell.click_to_show_col").click(function () {
	$.each($(this).prev().col(), function () {
	    $(this).show();
	});
	unset_hidden_secondary_requirement(hidden_sec_req_id);
	$(this).col().remove();
    });
}

function set_hidden_primary_requirement(hidden_pri_req_id) {
    var hidden_reqs = $.cookie("hidden_primary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));
    } else {
	hidden_reqs = new Array();
    }

    if (-1 == $.inArray(hidden_pri_req_id, hidden_reqs)) {
	hidden_reqs.push(hidden_pri_req_id);
	$.cookie("hidden_primary_requirements", JSON.stringify(hidden_reqs));
    }
}

function set_hidden_secondary_requirement(hidden_sec_req_id) {
    var hidden_reqs = $.cookie("hidden_secondary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));
    } else {
	hidden_reqs = new Array();
    }

    if (-1 == $.inArray(hidden_sec_req_id, hidden_reqs)) {
	hidden_reqs.push(hidden_sec_req_id);
	$.cookie("hidden_secondary_requirements", JSON.stringify(hidden_reqs));
    }
}

function unset_hidden_primary_requirement(hidden_pri_req_id) {
    var hidden_reqs = $.cookie("hidden_primary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));

	var idx = $.inArray(hidden_pri_req_id, hidden_reqs);
	if (0 <= idx) {
	    hidden_reqs = $.grep(hidden_reqs, function (e, i) {
		return i != idx;
	    });
	}

	$.cookie("hidden_primary_requirements", JSON.stringify(hidden_reqs));
    }
}

function unset_hidden_secondary_requirement(hidden_sec_req_id) {
    var hidden_reqs = $.cookie("hidden_secondary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));

	var idx = $.inArray(hidden_sec_req_id, hidden_reqs);
	if (0 <= idx) {
	    hidden_reqs = $.grep(hidden_reqs, function (e, i) {
		return i != idx;
	    });
	}

	$.cookie("hidden_secondary_requirements", JSON.stringify(hidden_reqs));
    }
}

function hide_hidden_primary_requirements() {
    var hidden_reqs = $.cookie("hidden_primary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));
	$(".matrix .row").each(function (i, e) {
	    var req_span = $(".req_id", e).eq(0);
	    var id = parseInt(req_span.text());

	    if (-1 != $.inArray(id, hidden_reqs)) {
		hide_primary_requirement(req_span);
	    }
	});
    }
}

function hide_hidden_secondary_requirements() {
    var hidden_reqs = $.cookie("hidden_secondary_requirements");

    if (hidden_reqs) {
	hidden_reqs = $.makeArray(JSON.parse(hidden_reqs));
	$(".matrix .row:lt(5)").each(function (i, e) {
	    var req_spans = $(".req_id", e);

	    req_spans.each(function () {
		var id = parseInt($(this).text());
		if (-1 != $.inArray(id, hidden_reqs)) {
		    hide_secondary_requirement($(this).parents(".cell").eq(0));
		}
	    });

	});
    }
}

function make_hidden_row_placeholder(cols) {
    var cells = "";

    for (var x = 0; x < cols; x++) {
	cells += "<div class=\"cell\"></div>";
    }

    return $("<div class=\"row click_to_show_row\" title=\"Click to show\">" + cells + "</div>");
}

function make_hidden_col_placeholder(cols) {
    var cells = "";

    $.each(cols, function () {
	$(this).after("<div class=\"cell click_to_show_col\" title=\"Click to show\"></div>");
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
	onblur: "submit",
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

    $(".cell", matrix).removeClass("highlight").
	removeClass("highlight_border").
	removeClass("backlight");

    cell.row().filter(".num").addClass("highlight");
    cell.col().filter(".num").addClass("highlight");
    cell.addClass("highlight_border");
}

function num_clicked(event) {
    var cell = $(this);
    var matrix = cell.parents(".matrix");

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
}

function paste_requirement(req_id, pos) {
    $.post("/requirements/" + req_id, {
	"_method": "PUT",
	"requirement[requested_position]": pos
    }, function (data) {
	inject_script(data);
    });
}

function disable_pasting_for_columns() {
    $("#column_menu").disableContextMenuItems("#paste_after,#paste_before");
}

function enable_pasting_for_columns() {
    disable_pasting_for_rows();
    $("#column_menu").enableContextMenuItems("#paste_after,#paste_before");
}

function disable_pasting_for_rows() {
    $("#row_menu").disableContextMenuItems("#paste_below,#paste_above");
}

function enable_pasting_for_rows() {
    disable_pasting_for_columns();
    $("#row_menu").enableContextMenuItems("#paste_below,#paste_above");
}
