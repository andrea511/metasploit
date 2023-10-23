(function() {

  define(['entities/nexpose/sites'], function($) {
    return describe('Entities.Nexpose.Sites', function() {
      set('WORKSPACE_ID', function() {
        return 2;
      });
      set('nexposeSite', function() {
        return new Pro.Entities.Nexpose.Site({});
      });
      set('nexposeSites', function() {
        return new Pro.Entities.Nexpose.SiteCollection([], {});
      });
      set('siteData', function() {
        return {
          id: 1
        };
      });
      set('sitesData', function() {
        return [
          {
            id: 1
          }, {
            id: 2
          }, {
            id: 3
          }
        ];
      });
      describe('when a site is fetched', function() {
        beforeEach(function() {
          this.server = sinon.fakeServer.create();
          this.server.respondWith(Routes.workspace_nexpose_data_sites_path(WORKSPACE_ID), [
            200, {
              "Content-Type": "application/json"
            }, JSON.stringify(siteData)
          ]);
          return nexposeSite.fetch();
        });
        afterEach(function() {
          return this.server.restore();
        });
        return it('fetched the console data', function() {
          this.server.respond();
          return expect(nexposeSite.get('id')).toEqual(1);
        });
      });
      return describe('when a collection of sites are fetched', function() {
        describe('without a nexpose import run id', function() {
          beforeEach(function() {
            this.server = sinon.fakeServer.create();
            this.server.respondWith(Routes.workspace_nexpose_data_sites_path(WORKSPACE_ID), [
              200, {
                "Content-Type": "application/json"
              }, JSON.stringify(sitesData)
            ]);
            return nexposeSites.fetch();
          });
          afterEach(function() {
            return this.server.restore();
          });
          return it('fetches the collection of sites', function() {
            this.server.respond();
            expect(nexposeSites.length).toEqual(3);
            expect(nexposeSites.get(1).get('id')).toEqual(1);
            expect(nexposeSites.get(2).get('id')).toEqual(2);
            return expect(nexposeSites.get(3).get('id')).toEqual(3);
          });
        });
        return describe('with a nexpose import run id', function() {
          set('nexpose_import_run_id', function() {
            return 5;
          });
          beforeEach(function() {
            this.server = sinon.fakeServer.create();
            this.server.respondWith(Routes.workspace_nexpose_data_sites_path(WORKSPACE_ID) + ("?nexpose_import_run_id=" + nexpose_import_run_id), [
              200, {
                "Content-Type": "application/json"
              }, JSON.stringify(sitesData)
            ]);
            nexposeSites.nexpose_import_run_id = nexpose_import_run_id;
            return nexposeSites.fetch();
          });
          afterEach(function() {
            return this.server.restore();
          });
          return it('fetches the collection of sites', function() {
            this.server.respond();
            expect(nexposeSites.length).toEqual(3);
            expect(nexposeSites.get(1).get('id')).toEqual(1);
            expect(nexposeSites.get(2).get('id')).toEqual(2);
            return expect(nexposeSites.get(3).get('id')).toEqual(3);
          });
        });
      });
    });
  });

}).call(this);
