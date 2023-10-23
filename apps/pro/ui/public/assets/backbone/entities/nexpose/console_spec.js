(function() {

  define(['entities/nexpose/console'], function($) {
    return describe('Entities.Nexpose.Console', function() {
      set('nexposeConsole', function() {
        return new Pro.Entities.Nexpose.Console({});
      });
      set('consoleData', function() {
        return {
          "address": "mspnexpose1.ms.scanlab.rapid7.com",
          "cached_sites": {},
          "cert": null,
          "created_at": "2015-05-15T13:45:43-05:00",
          "enabled": true,
          "id": 4,
          "name": "Test 3",
          "owner": "farias",
          "password": "msfadmin",
          "port": 3780,
          "status": "Initializing",
          "updated_at": "2015-05-15T13:45:43-05:00",
          "username": "msfadmin",
          "version": null,
          "connection_success": true
        };
      });
      return describe('when a console is fetched', function() {
        beforeEach(function() {
          this.server = sinon.fakeServer.create();
          this.server.respondWith(/^\/nexpose_consoles\.json$/, [
            200, {
              "Content-Type": "application/json"
            }, JSON.stringify(consoleData)
          ]);
          return nexposeConsole.fetch();
        });
        afterEach(function() {
          return this.server.restore();
        });
        it('fetched the console data', function() {
          this.server.respond();
          return expect(nexposeConsole.get('id')).toEqual(4);
        });
        return describe('then the console is destroyed', function() {
          beforeEach(function() {
            this.server = sinon.fakeServer.create();
            this.server.respondWith(/^\/nexpose_consoles\/destroy\.json$/, [
              200, {
                "Content-Type": "application/json"
              }, JSON.stringify(consoleData)
            ]);
            return nexposeConsole.destroy();
          });
          return afterEach(function() {
            this.server.restore();
            return it('destroys the model', function() {
              this.server.respond();
              return expect(nexposeConsole.get('id')).toBeUndefined();
            });
          });
        });
      });
    });
  });

}).call(this);
