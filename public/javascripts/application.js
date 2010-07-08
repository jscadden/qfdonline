KEY_LEFT = 37;
KEY_UP = 38;
KEY_RIGHT = 39;
KEY_DOWN = 40;
BUTTON_MOUSE_RIGHT = 2;
CUT_REQ_IDS = "cut_req_ids";


$(qfdonline_init);

function qfdonline_init() {
    try {
	$(".cell.rating").click(rating_clicked);
	$(".cell.name").click(rating_clicked);
	$(".cell.weight.first_hoq").click(rating_clicked);
	$(".num").mouseup(num_clicked);
	add_requirements_arrows_init();
    } catch (x) {
	alert("Error initializing matrix " + x);
    }
}

function add_requirements_arrows_init() {
    $(".row:first-child .num:last-child")
	.hover(show_add_row_or_column_arrow,
	       hide_add_row_or_column_arrow);
    $("#add_column_arrow").click(add_column_clicked);
    $(".row:last-child .num:first-child")
	.hover(show_add_row_or_column_arrow,
	       hide_add_row_or_column_arrow);
    $("#add_row_arrow").click(add_row_clicked);
}

function updates_permitted_init() {
    selectable_init();
    ajax_loading_init();
    editable_init();
    column_context_menu_init();
    row_context_menu_init();
    hide_hidden_primary_requirements();
    hide_hidden_secondary_requirements();
    rename_hoq_init();
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
	var cut_req_ids = matrix.data(CUT_REQ_IDS);
	var req_list_id = parseInt($(element).col().filter(".cell").find(".req_list_id").text());

	switch (action) {
	case "cut":
	    cut_selected_requirements();
	    enable_pasting_for_columns();
	    break;
	case "delete":
	    delete_selected_requirements();
	    break;
	case "hide":
	    hide_secondary_requirements();
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
	    paste_requirements(req_list_id, cut_req_ids, requested_position);
	    disable_pasting_for_columns();
	    break;
	case "paste_before":
	    requested_position = parseInt($(element).text());
	    paste_requirements(req_list_id, cut_req_ids, requested_position);
	    disable_pasting_for_columns();
	    break;
	case "unhide":
	    show_secondary_requirements();
	    force_clear_selections();
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
	disable_unhiding_for_columns();
    });
    disable_pasting_for_columns();
    disable_unhiding_for_columns();
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
	var cut_req_ids = matrix.data(CUT_REQ_IDS);
	var req_list_id = parseInt($(element).row().filter(".cell").find(".req_list_id").text());

	switch (action) {
	case "cut":
	    cut_selected_requirements();
	    enable_pasting_for_rows();
	    break;
	case "delete":
	    delete_selected_requirements();
	    break;
	case "hide":
	    hide_primary_requirements();
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
	    paste_requirements(req_list_id, cut_req_ids, requested_position);
	    disable_pasting_for_rows();
	    break;
	case "paste_below":
	    requested_position = parseInt($(element).text()) + 1;
	    paste_requirements(req_list_id, cut_req_ids, requested_position);
	    disable_pasting_for_rows();
	    break;
	case "unhide":
	    show_primary_requirements();
	    force_clear_selections();
	    break;
	default:
	    alert("Unhandled context menu action: " + action);
	    break;
	}
	disable_unhiding_for_rows();
    });
    disable_pasting_for_rows();
    disable_unhiding_for_rows();
}

function selectable_init() {
    $(".matrix").selectable({
	distance: 5,
	filter: ".num", 
	start: clear_selections,
	stop: backlight_row_or_column
    });
}

function backlight_row_or_column(event, ui) {
    $(".num.ui-selected").each(function (e, i) {
	var cell = $(this);

	if (cell.prev().length) {
	    cell.col().addClass("backlight");
	} else {
	    cell.row().addClass("backlight");
	}
    });

    disable_unhiding_for_rows();
    disable_unhiding_for_columns();
    if (selection_includes_hidden_rows()) {
	enable_unhiding_for_rows();
    } else if (selection_includes_hidden_columns()) {
	enable_unhiding_for_columns();
    }
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

function delete_selected_requirements() {
    var ids = [];
    var list_id = -1;

    $(".matrix .num.backlight").each(function () {
	var self = $(this);
	var row_div = null;

	if (self.prev().length) {
	    var req_id = parseInt(self.col().filter(".cell").find(".req_id").text());
	    list_id = parseInt(self.col().filter(".cell").find(".req_list_id").text());
	} else {
	    row_div = self.parents(".row");
	    var req_id = parseInt($(".req_id", row_div).eq(0).text());
	    list_id = parseInt($(".req_list_id", row_div).eq(0).text());
	}

	ids.push(req_id);
    });

    delete_requirements(list_id, ids);
}

function delete_requirements(list_id, ids) {
    var args = {
	"_method": "PUT",
	"requirements_list": {
	    "requirements_attributes": []
	}
    };

    $.each(ids, function (idx, value) {
	args["requirements_list"]["requirements_attributes"].push({
	    "id": value,
	    "_delete": "1"
	});
    });

    $.post("/requirements_lists/" + list_id, args, function (data) {
	inject_script(data);
    });    
}

function hide_primary_requirements() {
    $(".matrix .num.backlight").each(function () {
	var self = $(this);
	var row_div = self.parents(".row");
	var req_id = parseInt($(".req_id", row_div).eq(0).text());

	row_div.hide();
	row_div.after(make_hidden_row_placeholder(self.row().length));
	set_hidden_primary_requirement(req_id);
    });

    $(".row.click_to_show_row").each(function () {
	$(this).click(function () {
	    var self = $(this);
	    var pri_req_id = parseInt($(".req_id", self.prev()).eq(0).text());

	    self.prev().show();
	    unset_hidden_primary_requirement(pri_req_id);
	    self.remove();
	});
    });

    force_clear_selections();
}

function hide_secondary_requirements() {
    $(".matrix .num.backlight").each(function () {
	var self = $(this);
	var req_id = parseInt(self.col().filter(".cell").find(".req_id").text());

	self.col().hide();
	make_hidden_col_placeholder(self.col());
	set_hidden_secondary_requirement(req_id);
    });

    $(".cell.click_to_show_col").each(function () {
	$(this).click(function () {
	    var self = $(this);
	    var req_id = parseInt(self.prev().col().filter(".name").find(".req_id").text());

	    self.prev().col().show();
	    unset_hidden_secondary_requirement(req_id);
	    self.col().remove();
	});
    });

    force_clear_selections();
}

function show_primary_requirements() {
    var matrix = $(".matrix");
    var within_selection = false;

    $(".row", matrix).each(function() {
	var self = $(this);
	if (!within_selection && $(".num.ui-selected", self).length) {
	    within_selection = true;
	}

	if (within_selection && neither_selected_nor_hidden(self)) {
	    within_selection = false;
	}

	if (within_selection && self.hasClass("click_to_show_row")) {
	    self.click();
	}
    });
}

function selection_includes_hidden_rows() {
    var matrix = $(".matrix");
    var within_selection = false;
    var ret = false;

    $(":visible.row", matrix).each(function() {
	var self = $(this);
	if (within_selection && neither_selected_nor_hidden(self)) {
	    within_selection = false;
	}

	if (!within_selection && (0 < $(".num.ui-selected", self).length)) {
	    within_selection = true;
	}

	if (within_selection && self.hasClass("click_to_show_row")) {
	    ret = true;
	}
    });

    return ret;
}

function neither_selected_nor_hidden(row) {
    return !row.hasClass("click_to_show_row") && 
	    !("none" == row.css("display")) &&
	    (0 == $(".num.ui-selected", row).length);
}

function show_secondary_requirements() {
    var matrix = $(".matrix");
    var within_selection = false;

    $(".row:first-child .num", matrix).each(function() {
	var self = $(this);
	if (!within_selection && self.hasClass("highlight")) {
	    within_selection = true;
	}

	if (within_selection && !self.hasClass("highlight")) {
	    within_selection = false;
	}

	if (within_selection) {
	    self.col().each(function () {
		if ($(this).hasClass("click_to_show_col")) {
		    $(this).click();
		}
	    });
	}
    });
}

function selection_includes_hidden_columns() {
    var matrix = $(".matrix");
    var within_selection = false;
    var ret = false;

    $(".row:first-child .num", matrix).each(function() {
	var self = $(this);
	if (!within_selection && self.hasClass("highlight")) {
	    within_selection = true;
	}

	if (within_selection && !self.hasClass("highlight")) {
	    within_selection = false;
	}

	if (within_selection) {
	    self.col().each(function () {
		if ($(this).hasClass("click_to_show_col")) {
		    ret = true;
		}
		
	    });
	}
    });

    return ret;
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
	    var req_id = parseInt(req_span.text());

	    if (-1 != $.inArray(req_id, hidden_reqs)) {
		$(".num", req_span.parents(".row")).addClass("backlight");
	    }
	});
	hide_primary_requirements();
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
		    $(this).parents(".cell").col().filter(".num").addClass("backlight");
		    hide_secondary_requirements();
		}
	    });

	});
    }
}

function rename_hoq_init() {
    $(".rename_link").click(rename_hoq);
}

function rename_hoq() {
    var data = $($("#content > h1").clone());
    $("span", data).remove();
    var cur_name = $.trim($(data).text());
    var new_name = prompt("New name", cur_name);

    if (null != new_name) {
	$.post(location.href, {
            "_method": "PUT",
	    "hoq[name]": new_name
	}, function (data) {
	    inject_script(data);
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
	onerror: function (form, args) {
	    $("#flash_wrapper").append("<div class=\"flash error\">Permission denied</div>");
	    $("#flash_wrapper").show();
	},
	type: "text"
    });
}

function rating_clicked(event) {
    var cell = $(this);
    var matrix = cell.parents(".matrix");

    clear_selections(event);

    cell.row().filter(".num").addClass("highlight");
    cell.col().filter(".num").addClass("highlight");
    cell.addClass("highlight_border");
}

function clear_selections(event) {
    if (0 == event.button) {
	force_clear_selections();
    }
}

function force_clear_selections() {
    var matrix = $(".matrix");

    $("*", matrix).removeClass("ui-selected");
    $(".cell", matrix).removeClass("highlight").
	removeClass("highlight_border").
	removeClass("backlight");
}

function num_clicked(event) {
    var cell = $(this);
    var matrix = cell.parents(".matrix");

    clear_selections_unless_current(cell);

    cell.addClass("highlight");
    if (cell.closest(".header").length > 0) {
	cell.col().addClass("backlight");
    } else {
	cell.row().addClass("backlight");
    }
}

function clear_selections_unless_current(cell) {
    if (!cell.hasClass("ui-selected")) {
	force_clear_selections();
    }
}

function show_add_row_or_column_arrow() {
    var arrow = null;

    if ($(this).closest(".header").length > 0) {
	arrow = $("#add_column_arrow");
	position_add_column_arrow();
    } else {
	arrow = $("#add_row_arrow");
	position_add_row_arrow();
    }
    arrow.show();
}

function position_add_column_arrow() {
    var left = $(".num:last-child").parents(".row").offset().left;
    left += $(".num:last-child").parents(".row").width();
    left += parseInt($("$.num:last-child").parents(".row").css("border-right-width"));


    var top = $(".num:last-child").offset().top;
    top += ($(".num:last-child").height() / 2.0); 
    top += parseInt($("$.num:last-child").css("border-bottom-width"));
    top += parseInt($("$.num:last-child").css("padding-top"));
    top -= ($("#add_column_arrow").height() / 2.0);

    $("#add_column_arrow").css("left", left);
    $("#add_column_arrow").css("top", top);
}

function position_add_row_arrow() {
    var left = $(".row:last-child .num:first-child").offset().left;
    left += $(".row:last-child .num:first-child").width() / 2.0;
    left += parseInt($(".row:last-child .num:first-child").css("padding-left"));
    left += parseInt($(".row:last-child .num:first-child").css("border-right-width"));
    left -= ($("#add_row_arrow").width() / 2.0);

    var top = $(".row:last-child .num:first-child").offset().top;
    top += ($(".row:last-child .num:first-child").parents(".row").height());

    $("#add_row_arrow").css("left", left);
    $("#add_row_arrow").css("top", top);
}

function hide_add_row_or_column_arrow() {
    $("#add_column_arrow").hide();
    $("#add_row_arrow").hide();	
}

function add_column_clicked() {
    var sibling_id = $(".req_id", $(this).parents(".cell").col()[4]).text();
    var requested_position = parseInt($(this).parents(".num").text()) + 1;
    insert_requirement(sibling_id, "New Requirement", requested_position);
}

function add_row_clicked() {
    var sibling_id = $(".req_id", $(this).parents(".cell").row()[4]).text();
    var requested_position = parseInt($(this).parents(".num").text()) + 1;
    insert_requirement(sibling_id, "New Requirement", requested_position);
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

function cut_selected_requirements() {
    var ids = [];
    var list_id = null;

    $(".matrix .num.backlight").each(function () {
	var self = $(this);
	var row_div = null;
	var req_id = null;

	if (self.prev().length) {
	    req_id = parseInt(self.col().filter(".cell").find(".req_id").text());
	    list_id = parseInt(self.col().filter(".cell").find(".req_list_id").text());
	} else {
	    row_div = self.parents(".row");
	    req_id = parseInt($(".req_id", row_div).eq(0).text());
	    list_id = parseInt($(".req_list_id", row_div).eq(0).text());
	}

	ids.push(req_id);
    });
    $(".matrix").data(CUT_REQ_IDS, ids);
}

function paste_requirements(req_list_id, req_ids, pos) {
    var args = {
	"_method": "PUT",
	"requirements_list": {"requirements_attributes": []}
    };

    $.each(req_ids, function (idx, req_id) {
	args["requirements_list"]["requirements_attributes"].push({
            id: req_id,
	    requested_position: pos + idx
	});
    });

    $.post("/requirements_lists/" + req_list_id, args, function (data) {
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

function disable_unhiding_for_rows() {
    $("#row_menu").disableContextMenuItems("#unhide");
}

function enable_unhiding_for_rows() {
    $("#row_menu").enableContextMenuItems("#unhide");
}

function disable_unhiding_for_columns() {
    $("#column_menu").disableContextMenuItems("#unhide");
}

function enable_unhiding_for_columns() {
    $("#column_menu").enableContextMenuItems("#unhide");
}

function ajax_loading_init() {
    $.loading({onAjax: true, text: "Working…"});
}
