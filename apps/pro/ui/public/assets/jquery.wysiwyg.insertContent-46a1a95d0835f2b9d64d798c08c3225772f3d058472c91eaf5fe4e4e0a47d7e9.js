/**
 * insertContent puts html at the current caret position
 * Depends on jWYSIWYG
 */

(function ($) {
	"use strict";

	if (undefined === $.wysiwyg) {
		throw "wysiwyg.table.js depends on $.wysiwyg";
	}

	if (!$.wysiwyg.controls) {
		$.wysiwyg.controls = {};
	}


	$.wysiwyg.insertContent = function (object, content) {
		return object.each(function () {
			var Wysiwyg = $(this).data("wysiwyg");
			if (!Wysiwyg) {
				return this;
			}
			Wysiwyg.insertHtml(content)
			//Wysiwyg.editorDoc.execCommand("insertHTML", true, content)
			//$(Wysiwyg.editorDoc).trigger("editorRefresh.wysiwyg");

			return this;
		});
	};
})(jQuery);
