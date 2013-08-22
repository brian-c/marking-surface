// Generated by CoffeeScript 1.6.3
(function() {
  var RectangleTool, ToolControls, TranscriptionControls, TranscriptionTool, _ref, _ref1,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ref = (typeof window !== "undefined" && window !== null ? window.MarkingSurface : void 0) || require('marking-surface'), ToolControls = _ref.ToolControls, RectangleTool = _ref.RectangleTool;

  TranscriptionControls = (function(_super) {
    __extends(TranscriptionControls, _super);

    function TranscriptionControls() {
      this.onKeyDown = __bind(this.onKeyDown, this);
      TranscriptionControls.__super__.constructor.apply(this, arguments);
      this.deleteButton.style.position = 'absolute';
      this.deleteButton.style.right = '0.5em';
      this.deleteButton.style.top = '-1.5em';
      this.textarea = document.createElement('textarea');
      this.textarea.style.height = '3em';
      this.textarea.style.width = '100%';
      this.textarea.addEventListener('keydown', this.onKeyDown, false);
      this.el.appendChild(this.textarea);
    }

    TranscriptionControls.prototype.onKeyDown = function(e) {
      var _this = this;
      return setTimeout(function() {
        return _this.tool.mark.set('content', _this.textarea.value);
      });
    };

    TranscriptionControls.prototype.onToolSelect = function() {
      TranscriptionControls.__super__.onToolSelect.apply(this, arguments);
      return this.textarea.style.display = '';
    };

    TranscriptionControls.prototype.onToolDeselect = function() {
      TranscriptionControls.__super__.onToolDeselect.apply(this, arguments);
      return this.textarea.style.display = 'none';
    };

    TranscriptionControls.prototype.render = function() {
      return this.el.style.width = "" + this.tool.mark.width + "px";
    };

    return TranscriptionControls;

  })(ToolControls);

  TranscriptionTool = (function(_super) {
    __extends(TranscriptionTool, _super);

    function TranscriptionTool() {
      _ref1 = TranscriptionTool.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    TranscriptionTool.Controls = TranscriptionControls;

    TranscriptionTool.prototype.initialize = function() {
      TranscriptionTool.__super__.initialize.apply(this, arguments);
      return this.mark.set('content', '');
    };

    TranscriptionTool.prototype.positionControls = function() {
      return this.controls.moveTo(this.mark.left, this.mark.top + this.mark.height, true);
    };

    return TranscriptionTool;

  })(RectangleTool);

  if (typeof window !== "undefined" && window !== null) {
    window.MarkingSurface.TranscriptionTool = TranscriptionTool;
  }

  if (typeof module !== "undefined" && module !== null) {
    module.exports = TranscriptionTool;
  }

}).call(this);