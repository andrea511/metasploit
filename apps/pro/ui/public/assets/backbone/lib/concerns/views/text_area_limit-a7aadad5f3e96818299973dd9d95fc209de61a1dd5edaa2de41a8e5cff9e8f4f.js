(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.TextAreaLimit = {
        _bindTextArea: function($elem, maxRows, modalView, model) {
          var _this = this;
          return $elem.on('input', function(e) {
            return _this._textEnteredHandler(e, maxRows, modalView, model);
          });
        },
        _unbindTextArea: function($elem) {
          return $elem.off('input');
        },
        _textEnteredHandler: function(e, maxRows, modalView, model) {
          var lines, text;
          text = $(e.target).val();
          lines = text.split('\n');
          if (lines.length > 100) {
            this._truncateTextArea($(e.target), maxRows, lines);
            if (modalView) {
              return this._showLimitModal(modalView, model);
            }
          }
        },
        _truncateTextArea: function($elem, maxRows, lines) {
          var buffer, index, _i;
          buffer = '';
          for (index = _i = 0; _i <= 98; index = ++_i) {
            buffer = buffer.concat("" + lines[index] + "\n");
          }
          buffer = buffer.concat("" + lines[index]);
          $elem.val(buffer);
          return $elem.trigger('keyup');
        },
        _showLimitModal: function(View, model) {
          var view;
          view = new View({
            model: model
          });
          return App.execute('showModal', view, {
            modal: {
              title: '',
              description: '',
              width: 200,
              height: 200
            },
            buttons: [
              {
                name: 'OK',
                "class": 'btn primary'
              }
            ],
            loading: false
          });
        }
      };
    });
  });

}).call(this);
