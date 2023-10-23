(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Note = (function(_super) {

        __extends(Note, _super);

        function Note() {
          this.url = __bind(this.url, this);
          return Note.__super__.constructor.apply(this, arguments);
        }

        Note.prototype.url = function() {
          return Routes.workspace_notes_path(this.get('workspace_id'));
        };

        return Note;

      })(App.Entities.Model);
      Entities.NoteCollection = (function(_super) {

        __extends(NoteCollection, _super);

        function NoteCollection() {
          this.url = __bind(this.url, this);
          return NoteCollection.__super__.constructor.apply(this, arguments);
        }

        NoteCollection.prototype.url = function() {
          return Routes.workspace_notes_path(WORKSPACE_ID);
        };

        NoteCollection.prototype.model = Entities.Note;

        return NoteCollection;

      })(App.Entities.Collection);
      API = {
        getNotes: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Entities.NoteCollection([], opts);
        },
        getNote: function(id) {
          return new Entities.Note({
            id: id
          });
        },
        newNote: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Note(attributes);
        }
      };
      App.reqres.setHandler("note:entity", function(id) {
        return API.getNote(id);
      });
      App.reqres.setHandler("notes:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getNotes(opts);
      });
      return App.reqres.setHandler("new:note:entity", function(attributes) {
        return API.newNote(attributes);
      });
    });
  });

}).call(this);
