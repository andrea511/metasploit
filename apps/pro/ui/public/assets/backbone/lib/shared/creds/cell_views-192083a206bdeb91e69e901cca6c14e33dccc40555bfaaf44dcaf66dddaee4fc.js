(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_view', 'base_itemview', 'lib/components/table/table_view', 'apps/creds/shared/cred_shared_views', 'lib/shared/creds/templates/collection_hover'], function($) {
    /*
      #
      # Table Cell Views for use with Credentials
      #
    */
    Pro.module("Creds.CellViews");
    Pro.Creds.CellViews.Public = (function(_super) {

      __extends(Public, _super);

      function Public() {
        this.template = __bind(this.template, this);
        return Public.__super__.constructor.apply(this, arguments);
      }

      Public.prototype.initialize = function(_arg) {
        var _ref, _ref1, _ref2;
        this.attribute = _arg.attribute, this.idAttribute = _arg.idAttribute, this.workspaceIdAttribute = _arg.workspaceIdAttribute;
        if ((_ref = this.attribute) == null) {
          this.attribute = 'public';
        }
        if ((_ref1 = this.idAttribute) == null) {
          this.idAttribute = 'core_id';
        }
        return (_ref2 = this.workspaceIdAttribute) != null ? _ref2 : this.workspaceIdAttribute = 'workspace_id';
      };

      Public.prototype.template = function(m) {
        var id, user, workspaceRoute;
        id = m[this.idAttribute];
        user = _.escape(_.str.truncate(m[this.attribute], 18));
        workspaceRoute = _.escape(Routes.workspace_credentials_path(m[this.workspaceIdAttribute]));
        return "<a href='" + workspaceRoute + "#creds/" + (_.escape(id)) + "'>" + user + "</a>";
      };

      return Public;

    })(Pro.Views.ItemView);
    Pro.Creds.CellViews.HostAddress = (function(_super) {

      __extends(HostAddress, _super);

      function HostAddress() {
        this.template = __bind(this.template, this);
        return HostAddress.__super__.constructor.apply(this, arguments);
      }

      HostAddress.prototype.initialize = function(_arg) {
        var _ref, _ref1;
        this.attribute = _arg.attribute, this.idAttribute = _arg.idAttribute;
        if ((_ref = this.attribute) == null) {
          this.attribute = 'address';
        }
        return (_ref1 = this.idAttribute) != null ? _ref1 : this.idAttribute = 'host_id';
      };

      HostAddress.prototype.template = function(m) {
        var route;
        route = _.escape(Routes.host_path(m[this.idAttribute]));
        return "<a class='underline' href='" + route + "'>" + (_.escape(m[this.attribute])) + "</a>";
      };

      return HostAddress;

    })(Pro.Views.ItemView);
    Pro.Creds.CellViews.Session = (function(_super) {

      __extends(Session, _super);

      function Session() {
        this.template = __bind(this.template, this);
        return Session.__super__.constructor.apply(this, arguments);
      }

      Session.prototype.initialize = function(_arg) {
        var _ref, _ref1;
        this.attribute = _arg.attribute, this.workspaceAttribute = _arg.workspaceAttribute;
        if ((_ref = this.attribute) == null) {
          this.attribute = 'session_id';
        }
        return (_ref1 = this.workspaceAttribute) != null ? _ref1 : this.workspaceAttribute = 'workspace_id';
      };

      Session.prototype.template = function(m) {
        var route;
        if (m[this.attribute] && m[this.workspaceAttribute]) {
          route = Routes.session_path(m[this.attribute], m[this.workspaceAttribute]);
          return "<a href='" + (_.escape(route)) + "'>Session " + (_.escape(m.session_id)) + "</a>";
        } else {
          return "";
        }
      };

      return Session;

    })(Pro.Views.ItemView);
    Pro.Creds.CellViews.Count = (function(_super) {

      __extends(Count, _super);

      function Count() {
        this.template = __bind(this.template, this);
        return Count.__super__.constructor.apply(this, arguments);
      }

      Count.prototype.initialize = function(_arg) {
        var _ref, _ref1;
        this.attribute = _arg.attribute, this.subject = _arg.subject, this.pluralSubject = _arg.pluralSubject, this.link = _arg.link;
        if (this.attribute == null) {
          throw new Error("missing :attribute option");
        }
        if (this.subject == null) {
          throw new Error("missing :subject option");
        }
        if ((_ref = this.link) == null) {
          this.link = true;
        }
        return (_ref1 = this.pluralSubject) != null ? _ref1 : this.pluralSubject = this.subject + 's';
      };

      Count.prototype.template = function(m) {
        var count, phrase, subject;
        count = parseInt(m[this.attribute], 10);
        subject = count === 1 ? this.subject : this.pluralSubject;
        phrase = "" + (_.escape(m[this.attribute])) + " " + subject;
        if (count > 0 && this.link === true) {
          return "<a href='javascript:void(0)'>" + phrase + "</a>";
        } else if (this.link && typeof this.link !== 'boolean') {
          return "<a href='" + (this.link(m)) + "'>" + phrase + "</a>";
        } else {
          return phrase;
        }
      };

      return Count;

    })(Pro.Views.ItemView);
    Pro.Creds.CellViews.Private = (function(_super) {

      __extends(Private, _super);

      function Private() {
        this.passClicked = __bind(this.passClicked, this);

        this.template = __bind(this.template, this);
        return Private.__super__.constructor.apply(this, arguments);
      }

      Private.prototype.events = {
        'click a': 'passClicked'
      };

      Private.prototype.initialize = function(_arg) {
        var _ref, _ref1;
        this.attribute = _arg.attribute, this.typeAttribute = _arg.typeAttribute;
        if ((_ref = this.attribute) == null) {
          this.attribute = 'private';
        }
        return (_ref1 = this.typeAttribute) != null ? _ref1 : this.typeAttribute = 'private_type';
      };

      Private.prototype.template = function(m) {
        var ptype, _ref;
        ptype = (_ref = m[this.typeAttribute]) != null ? _ref.split('::')[2] : void 0;
        if (ptype === 'Password') {
          return _.escape(_.str.truncate(m[this.attribute], 24));
        } else {
          return "<a href='javascript:void(0)'>" + (_.escape(ptype)) + "</a>";
        }
      };

      Private.prototype.passClicked = function() {
        var dialogView;
        dialogView = new Pro.CredsApp.Shared.CoresTablePrivateCellDisclosureDialog({
          model: new Backbone.Model({
            'private.data': this.model.get(this.attribute)
          })
        });
        return Pro.execute('showModal', dialogView, {
          modal: {
            title: 'Private Data',
            description: '',
            width: 600,
            height: 400
          },
          buttons: [
            {
              name: 'Close',
              "class": 'close'
            }
          ]
        });
      };

      return Private;

    })(Pro.Views.ItemView);
    Pro.Creds.CellViews.CollectionHover = (function(_super) {

      __extends(CollectionHover, _super);

      function CollectionHover() {
        this.serializeData = __bind(this.serializeData, this);

        this.sync = __bind(this.sync, this);
        return CollectionHover.__super__.constructor.apply(this, arguments);
      }

      CollectionHover.prototype.className = 'hover-square';

      CollectionHover.prototype.template = JST['backbone/lib/shared/creds/templates/collection_hover'];

      CollectionHover.prototype.initialize = function(opts) {
        var _ref, _ref1, _ref2;
        if (opts == null) {
          opts = {};
        }
        if ((_ref = this.url) == null) {
          this.url = opts.url;
        }
        if ((_ref1 = this.columns) == null) {
          this.columns = opts.columns;
        }
        return (_ref2 = this.title) != null ? _ref2 : this.title = opts.title;
      };

      CollectionHover.prototype.onShow = function() {
        return this.timeout = setTimeout(this.sync, 300);
      };

      CollectionHover.prototype.onDestroy = function() {
        return clearTimeout(this.timeout);
      };

      CollectionHover.prototype.sync = function() {
        var _this = this;
        return $.getJSON(_.result(this, 'url')).done(function(data) {
          var _ref;
          _this.data = data;
          if (((_ref = _this.el) != null ? _ref.parentNode : void 0) != null) {
            return _this.render();
          }
        });
      };

      CollectionHover.prototype.serializeData = function() {
        var _this = this;
        return _.reduce(['data', 'columns', 'title'], function(memo, propName) {
          if (memo == null) {
            memo = {};
          }
          memo[propName] = _.result(_this, propName);
          return memo;
        }, {});
      };

      return CollectionHover;

    })(Pro.Views.CompositeView);
    Pro.Creds.CellViews.Realm = (function(_super) {

      __extends(Realm, _super);

      function Realm() {
        this.template = __bind(this.template, this);
        return Realm.__super__.constructor.apply(this, arguments);
      }

      Realm.prototype.initialize = function(_arg) {
        var _ref;
        this.attribute = _arg.attribute;
        return (_ref = this.attribute) != null ? _ref : this.attribute = 'realm_key';
      };

      Realm.prototype.template = function(m) {
        var key;
        key = (m[this.attribute] || '').replace(/\sDomain$/, '');
        return "<a href='javascript:void(0)'>" + (_.escape(key)) + "</a>";
      };

      return Realm;

    })(Pro.Views.ItemView);
    return Pro.Creds.CellViews.RealmHover = (function(_super) {

      __extends(RealmHover, _super);

      function RealmHover() {
        return RealmHover.__super__.constructor.apply(this, arguments);
      }

      RealmHover.prototype.className = 'hover-square realm';

      RealmHover.prototype.initialize = function(_arg) {
        var _ref;
        this.attribute = _arg.attribute;
        return (_ref = this.attribute) != null ? _ref : this.attribute = 'realm';
      };

      RealmHover.prototype.template = function(m) {
        return "<div>Realm Name</div><div>" + (_.escape(m.realm)) + "</div>";
      };

      return RealmHover;

    })(Pro.Views.ItemView);
  });

}).call(this);
