(function() {

  define(['jquery', 'entities/cred', 'apps/creds/index/index_view'], function($) {
    return describe('Pro.Concerns.CoresTablePrivateCell', function() {
      set('cred', function() {
        return new Pro.Entities.Cred({
          'private.data': 'password',
          'private.data_truncated': 'pass...'
        });
      });
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'clone-cell-region'
        }).appendTo($('body'))[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      it('should render', function() {
        var privateCellView;
        privateCellView = new Pro.CredsApp.Shared.CoresTablePrivateCell({
          model: cred
        });
        this.region.show(privateCellView);
        return expect(this.region.$el.children().length).toBeGreaterThan(0);
      });
      describe('when the private data is truncated', function() {
        it('displays a disclosure link', function() {
          var privateCellView, truncatedCred;
          truncatedCred = new Backbone.Model;
          truncatedCred.isTruncated = function() {
            return true;
          };
          truncatedCred.isSSHKey = function() {
            return true;
          };
          privateCellView = new Pro.CredsApp.Shared.CoresTablePrivateCell({
            model: truncatedCred
          });
          this.region.show(privateCellView);
          return expect(privateCellView.$el.find('a').length).toBe(1);
        });
        return describe('when the disclosure link is clicked', function() {
          return it('requests display of a dialog containing the private data');
        });
      });
      return describe('when the private data is not truncated', function() {
        return it('does not display a disclosure link', function() {
          var nonTruncatedCred, privateCellView;
          nonTruncatedCred = new Backbone.Model;
          nonTruncatedCred.isTruncated = function() {
            return false;
          };
          nonTruncatedCred.isSSHKey = function() {
            return true;
          };
          privateCellView = new Pro.CredsApp.Shared.CoresTablePrivateCell({
            model: nonTruncatedCred
          });
          this.region.show(privateCellView);
          return expect(privateCellView.$el.find('a').length).toBe(0);
        });
      });
    });
  });

}).call(this);
