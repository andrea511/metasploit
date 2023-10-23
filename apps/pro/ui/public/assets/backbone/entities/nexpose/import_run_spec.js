(function() {

  define(['entities/nexpose/import_run'], function($) {
    return describe('Entities.Nexpose.ImportRun', function() {
      set('WORKSPACE_ID', function() {
        return 1;
      });
      set('importRun', function() {
        return new Pro.Entities.Nexpose.ImportRun({});
      });
      set('importRunData', function() {
        return {
          id: 4,
          state: 'not_yet_started'
        };
      });
      set('not_yet_started', function() {
        return 'not_yet_started';
      });
      set('ready_to_import', function() {
        return 'ready_to_import';
      });
      set('finished', function() {
        return 'finished';
      });
      describe('when a import run is fetched', function() {
        beforeEach(function() {
          this.server = sinon.fakeServer.create();
          this.server.respondWith(Routes.workspace_nexpose_data_import_runs_path(WORKSPACE_ID), [
            200, {
              "Content-Type": "application/json"
            }, JSON.stringify(importRunData)
          ]);
          return importRun.fetch();
        });
        afterEach(function() {
          return this.server.restore();
        });
        return it('fetched the import run data', function() {
          this.server.respond();
          expect(importRun.get('id')).toEqual(4);
          return expect(importRun.get('state')).toEqual(not_yet_started);
        });
      });
      return describe('when the state helpers are called', function() {
        it('tells you if is not yet started', function() {
          importRun.set('state', not_yet_started);
          expect(importRun.isNotYetStarted()).toEqual(true);
          expect(importRun.isReadyToImport()).toEqual(false);
          return expect(importRun.isFinished()).toEqual(false);
        });
        it('tells you if it is ready to import ', function() {
          importRun.set('state', ready_to_import);
          expect(importRun.isNotYetStarted()).toEqual(false);
          expect(importRun.isReadyToImport()).toEqual(true);
          return expect(importRun.isFinished()).toEqual(false);
        });
        return it('tells you if it is finished', function() {
          importRun.set('state', finished);
          expect(importRun.isNotYetStarted()).toEqual(false);
          expect(importRun.isReadyToImport()).toEqual(false);
          return expect(importRun.isFinished()).toEqual(true);
        });
      });
    });
  });

}).call(this);
