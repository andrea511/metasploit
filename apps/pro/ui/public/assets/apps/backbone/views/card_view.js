(function() {
  var modalViewPaths,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  modalViewPaths = {
    "firewall_egress": "/assets/firewall_egress/firewall_egress-41aa491fc93a00a990b0b8d0be32d746b97ce4c16afe45c55cbad3431b33293a.js",
    "domino": "/assets/domino/domino-7a82751ce0e6cd898ba2dd086b859b273191d37a09e3b60d0af3ff77f4b2c2b5.js",
    "pass_the_hash": "/assets/apps/backbone/views/modal_views/pass_the_hash-b92b02d88c6a8c50949f1ed50fb3cc77905a6330ad2351f7a08ac38101a4baa1.js",
    "ssh_key": "/assets/apps/backbone/views/modal_views/ssh_key-160a37ba88ac80f734c559bd37a41b094233b6c6111bff2fab8cc801aa7e1676.js",
    "credential_intrusion": "/assets/apps/backbone/views/modal_views/credential_intrusion-75b55e9fefd5fda1eb9b858b7dd0edb83d6f1b8b792f11722f6a0bc4d3c7b622.js",
    "single_password": "/assets/apps/backbone/views/modal_views/single_password-89408bd5ea92a8563da2d31fdfc5042b261ed127adbb34f7a987883422377502.js",
    "passive_network": "/assets/apps/backbone/views/modal_views/passive_network-fa4ee0811dadc1cc7a1649db551036e353ebbaac1c9b2b9ef2c6b58e7fb669a9.js"
  };

  define(['jquery', '/assets/templates/apps/views/card_view-caac12f4c42b5fc13118d56c2f722e47422be5d8aeb5bda2312db5f02fdf97ed.js'], function($, Template) {
    var CardView;
    return CardView = (function(_super) {

      __extends(CardView, _super);

      function CardView() {
        this.launchClicked = __bind(this.launchClicked, this);
        return CardView.__super__.constructor.apply(this, arguments);
      }

      CardView.prototype.template = HandlebarsTemplates['apps/views/card_view'];

      CardView.prototype.events = {
        'click .primary.btn': 'launchClicked',
        'click a.title': 'launchClicked'
      };

      CardView.prototype.launchClicked = function(e) {
        var path;
        e.preventDefault();
        path = modalViewPaths[this.model.get('symbol')];
        return this.loadAssets(path);
      };

      CardView.prototype.loadAssets = function(pathToLoad) {
        var rjs;
        rjs = requirejs.config({
          context: "app"
        });
        return rjs([pathToLoad], function(ModalView) {
          return new ModalView({
            el: $('#modals')
          }).open();
        });
      };

      return CardView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
