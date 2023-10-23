(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery'], function($) {
    var RainbowProgressBar;
    return RainbowProgressBar = (function() {

      RainbowProgressBar.UPDATE_THRESHOLD = 0.000001;

      RainbowProgressBar.prototype._percentage = 0;

      RainbowProgressBar.prototype._text = 0;

      RainbowProgressBar.prototype._stroke = 3;

      RainbowProgressBar.prototype._canvas = null;

      RainbowProgressBar.prototype._percentFill = '#cccccc';

      RainbowProgressBar.prototype._percentFillHover = '#cccccc';

      RainbowProgressBar.prototype._innerFill = "#666666";

      RainbowProgressBar.prototype._innerFillHover = '#666666';

      RainbowProgressBar.prototype._textFill = "#cccccc";

      RainbowProgressBar.prototype._textFillHover = "#cccccc";

      RainbowProgressBar.prototype._fontSize = '28px';

      RainbowProgressBar.prototype._fontFamily = '"HelveticaNeue-Light", "Helvetica Neue Light",\
                      "Helvetica Neue", "Arial Narrow", Helvetica, san-serif';

      RainbowProgressBar.prototype._fontStyle = '';

      RainbowProgressBar.prototype._animationDuration = 600;

      RainbowProgressBar.prototype._hover = false;

      RainbowProgressBar.prototype._selected = false;

      RainbowProgressBar.prototype._radius = 14;

      RainbowProgressBar.prototype._innerRadius = 6;

      function RainbowProgressBar(args) {
        var $parent,
          _this = this;
        if (args == null) {
          args = {};
        }
        this._fillStyle = __bind(this._fillStyle, this);

        this.update = __bind(this.update, this);

        this.getInnerFill = __bind(this.getInnerFill, this);

        this.setInnerFill = __bind(this.setInnerFill, this);

        this.setSelected = __bind(this.setSelected, this);

        this.setText = __bind(this.setText, this);

        this._setPercentage = __bind(this._setPercentage, this);

        this.setPercentage = __bind(this.setPercentage, this);

        _.each(args, function(v, k) {
          return _this['_' + k] = v;
        });
        $parent = $(this._canvas).parents('.rainbow-progress-wrapper').first();
        this._setDimensions();
        if ($parent.attr('clickable') === 'true') {
          $parent.mouseenter(function() {
            _this._hover = true;
            return _this.update();
          });
          $parent.mouseleave(function() {
            _this._hover = false;
            return _this.update();
          });
        }
      }

      RainbowProgressBar.prototype.setPercentage = function(percentage, opts) {
        if (opts == null) {
          opts = {};
        }
        return this._setPercentage(opts, percentage);
      };

      RainbowProgressBar.prototype._setPercentage = function(_arg, percentage) {
        var shouldAnimate, shouldUpdate,
          _this = this;
        shouldUpdate = _arg.shouldUpdate, shouldAnimate = _arg.shouldAnimate;
        percentage || (percentage = 0);
        if (shouldUpdate == null) {
          shouldUpdate = true;
        }
        if (shouldAnimate == null) {
          shouldAnimate = true;
        }
        if (Math.abs(percentage - this._percentage) < RainbowProgressBar.UPDATE_THRESHOLD && percentage !== 0) {
          return;
        }
        if (shouldAnimate) {
          return $({
            percentage: this._percentage
          }).animate({
            percentage: percentage
          }, {
            duration: this._animationDuration,
            easing: 'easeInExpo',
            step: function(val) {
              return _this.setPercentage(val, {
                shouldAnimate: false
              });
            }
          });
        } else {
          this._percentage = percentage;
          if (shouldUpdate) {
            return this.update();
          }
        }
      };

      RainbowProgressBar.prototype.setText = function(_text, _arg) {
        var shouldUpdate;
        this._text = _text;
        shouldUpdate = _arg.shouldUpdate;
        this._text || (this._text = '');
        if (shouldUpdate == null) {
          shouldUpdate = true;
        }
        if (shouldUpdate) {
          return this.update();
        }
      };

      RainbowProgressBar.prototype.setSelected = function(_selected, _arg) {
        var shouldUpdate;
        this._selected = _selected;
        shouldUpdate = _arg.shouldUpdate;
        if (shouldUpdate == null) {
          shouldUpdate = true;
        }
        if (shouldUpdate) {
          return this.update();
        }
      };

      RainbowProgressBar.prototype.setInnerFill = function(_innerFill, _arg) {
        var shouldUpdate;
        this._innerFill = _innerFill;
        shouldUpdate = _arg.shouldUpdate;
        if (shouldUpdate == null) {
          shouldUpdate = true;
        }
        if (shouldUpdate) {
          return this.update();
        }
      };

      RainbowProgressBar.prototype.getInnerFill = function() {
        return this._innerFill;
      };

      RainbowProgressBar.prototype.update = function() {
        this.context = this._canvas.getContext('2d');
        this.setSelected($(this._canvas).hasClass('selected'), {
          shouldUpdate: false
        });
        this.context.clearRect(0, 0, this._originalWidth, this._originalHeight);
        this.x = this._originalWidth / 4;
        this.y = this._originalHeight / 2 + this._radius / 2;
        this.counterClockwise = false;
        this._fillBackgroundImage();
        this._fillProgressArch();
        this._fillInnerCircle();
        return this._fillPercentText();
      };

      RainbowProgressBar.prototype._fillBackgroundImage = function() {
        this.context.beginPath();
        this.context.lineWidth = 8;
        this.context.strokeStyle = '#cccccc';
        this.context.arc(this.x, this.y, this._radius, Math.PI, 0, this.counterClockwise);
        return this.context.stroke();
      };

      RainbowProgressBar.prototype._fillProgressArch = function() {
        var endAngle, startAngle;
        startAngle = Math.PI;
        endAngle = Math.PI + Math.PI * (this._percentage / 100);
        this.context.beginPath();
        this.context.lineWidth = 8;
        this.context.strokeStyle = this._fillStyle('percentFill');
        this.context.arc(this.x, this.y, this._radius, startAngle, endAngle, this.counterClockwise);
        return this.context.stroke();
      };

      RainbowProgressBar.prototype._fillInnerCircle = function() {
        this.context.beginPath();
        this.context.strokeStyle = this._fillStyle('innerFill');
        this.context.arc(this.x, this.y, this._innerRadius, Math.PI, 0, this.counterClockwise);
        this.context.fillStyle = this._fillStyle('innerFill');
        this.context.fill();
        return this.context.stroke();
      };

      RainbowProgressBar.prototype._fillPercentText = function() {
        this.context.fillStyle = this._fillStyle('textFill');
        this.context.font = this._fontStyle;
        return this.context.fillText("" + (Math.round(this._percentage)) + "%", this.x + this._radius + 8, this.y);
      };

      RainbowProgressBar.prototype._fillStyle = function(attr) {
        if (this._hover) {
          return this['_' + attr + 'Hover'] || this['_' + attr];
        } else if (this._selected) {
          return this['_' + attr + 'Selected'] || this['_' + attr];
        } else {
          return this['_' + attr];
        }
      };

      RainbowProgressBar.prototype._setDimensions = function() {
        var hidefCanvasCssHeight, hidefCanvasCssWidth, hidefCanvasHeight, hidefCanvasWidth;
        this.context || (this.context = this._canvas.getContext('2d'));
        this._originalHeight = this._canvas.height;
        this._originalWidth = this._canvas.width;
        if (window.devicePixelRatio) {
          hidefCanvasCssWidth = this._canvas.width;
          hidefCanvasCssHeight = this._canvas.height;
          hidefCanvasWidth = hidefCanvasCssWidth * window.devicePixelRatio;
          hidefCanvasHeight = hidefCanvasCssHeight * window.devicePixelRatio;
          $(this._canvas).attr('width', hidefCanvasWidth);
          $(this._canvas).attr('height', hidefCanvasHeight);
          $(this._canvas).css('width', hidefCanvasCssWidth);
          $(this._canvas).css('height', hidefCanvasCssHeight);
          return this.context.scale(window.devicePixelRatio, window.devicePixelRatio);
        }
      };

      return RainbowProgressBar;

    })();
  });

}).call(this);
