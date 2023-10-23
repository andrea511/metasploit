(function() {

  define(['jquery', 'apps/imports/nexpose/nexpose_controller'], function($) {
    var deferServerResponse;
    deferServerResponse = function(deferFunction) {
      var flag, result, set;
      flag = false;
      set = function() {
        return flag = true;
      };
      result = function() {
        server.respond();
        return flag;
      };
      runs(function() {
        return setTimeout(set, 8);
      });
      waitsFor(result, 8);
      return runs(function() {
        return deferFunction.call(this);
      });
    };
    return describe('ImportsApp.Nexpose.Controller', function() {
      var cleanupSpies, registerSpies;
      set('gon', function() {
        return {};
      });
      set('WORKSPACE_ID', function() {
        return 1;
      });
      set('consoleData', function() {
        return {
          "address": "mspnexpose1.ms.scanlab.rapid7.com",
          "cached_sites": {},
          "cert": null,
          "created_at": "2015-05-15T13:45:43-05:00",
          "enabled": true,
          "id": 2,
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
      set('importRunData', function() {
        return {
          "id": 9,
          "user_id": 1,
          "workspace_id": 1,
          "state": "ready_to_import",
          "nx_console_id": 2,
          "metasploitable_only": true,
          "created_at": "2015-07-23T14:50:09.896-05:00",
          "updated_at": "2015-07-23T14:50:15.031-05:00",
          "import_state": "not_yet_started",
          "templates": [
            {
              "id": 20,
              "nx_console_id": 2,
              "scan_template_id": "custom-template-1",
              "name": "custom-template-1",
              "created_at": "2015-07-21T12:13:50.482-05:00",
              "updated_at": "2015-07-21T12:13:50.482-05:00"
            }, {
              "id": 19,
              "nx_console_id": 2,
              "scan_template_id": "custom-template-2",
              "name": "custom-template-2",
              "created_at": "2015-07-21T12:13:50.476-05:00",
              "updated_at": "2015-07-21T12:13:50.476-05:00"
            }
          ]
        };
      });
      set('siteData', function() {
        return {
          "collection": [
            {
              "created_at": "2015-07-23 15:10:07 -0500",
              "description": "Test site, ignore",
              "id": "660",
              "importance": "normal",
              "last_scan_date": "2015-05-18 14:20:49 -0500",
              "last_scan_id": "269",
              "name": "shuckins has a super site name for great justice",
              "nexpose_data_import_run_id": "10",
              "next_scan_date": null,
              "site_id": "244",
              "summary.assets_count": "2",
              "summary.critical_vulnerabilities_count": "20",
              "summary.exploits_count": "0",
              "summary.malware_kits_count": "0",
              "summary.metasploit_exploits_count": "0",
              "summary.moderate_vulnerabilities_count": "4",
              "summary.pci_status": null,
              "summary.riskscore": "0.0",
              "summary.severe_vulnerabilities_count": "5",
              "summary.url": "https://mspnexpose1.ms.scanlab.rapid7.com:3780/api/2.0/sites/244/summary",
              "summary.vulnerabilities_count": "29",
              "summary.vulnerabilities_instances_count": "0",
              "summary.vulnerabilities_with_exploits_count": "0",
              "summary.vulnerabilities_with_malware_kits_count": "0",
              "type": "static",
              "updated_at": "2015-07-23 15:10:07 -0500"
            }, {
              "created_at": "2015-07-23 15:10:08 -0500",
              "description": null,
              "id": "755",
              "importance": "normal",
              "last_scan_date": "2015-06-08 15:08:26 -0500",
              "last_scan_id": "290",
              "name": "kaboomies",
              "nexpose_data_import_run_id": "10",
              "next_scan_date": null,
              "site_id": "265",
              "summary.assets_count": "0",
              "summary.critical_vulnerabilities_count": "0",
              "summary.exploits_count": "0",
              "summary.malware_kits_count": "0",
              "summary.metasploit_exploits_count": "0",
              "summary.moderate_vulnerabilities_count": "0",
              "summary.pci_status": null,
              "summary.riskscore": "0.0",
              "summary.severe_vulnerabilities_count": "0",
              "summary.url": "https://mspnexpose1.ms.scanlab.rapid7.com:3780/api/2.0/sites/265/summary",
              "summary.vulnerabilities_count": "0",
              "summary.vulnerabilities_instances_count": "0",
              "summary.vulnerabilities_with_exploits_count": "0",
              "summary.vulnerabilities_with_malware_kits_count": "0",
              "type": "static",
              "updated_at": "2015-07-23 15:10:08 -0500"
            }
          ],
          "total_pages": 1,
          "total_count": 2
        };
      });
      set('server', function() {
        var server;
        server = sinon.fakeServer.create();
        server.respondWith(/^\/nexpose_consoles\.json$/, [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(consoleData)
        ]);
        server.respondWith(/.*\/nexpose\/data\/import_runs/, [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(importRunData)
        ]);
        server.respondWith(/.*\/nexpose\/data\/sites.*/, [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(siteData)
        ]);
        return server;
      });
      set('model', function() {
        return new Pro.Entities.Nexpose.ImportRun({
          consoles: {
            'Test Consoles': 2
          }
        });
      });
      set('regionEl', function() {
        return $("<div />").appendTo($('body'))[0];
      });
      set('region', function() {
        return new Backbone.Marionette.Region({
          el: regionEl
        });
      });
      registerSpies = function(controller) {
        sinon.spy(controller, "_showForm");
        return sinon.spy(controller, "_showSitesTable");
      };
      cleanupSpies = function(controller) {
        controller._showForm.restore();
        return controller._showSitesTable.restore();
      };
      beforeEach(function() {
        return server;
      });
      afterEach(function() {
        return region.reset();
      });
      return describe('when it initially loads the page', function() {
        beforeEach(function() {
          this.controller = new Pro.ImportsApp.Nexpose.Controller({
            model: model
          });
          registerSpies(this.controller);
          return region.show(this.controller._mainView);
        });
        afterEach(function() {
          return cleanupSpies(this.controller);
        });
        it('renders the view', function() {
          return expect($(regionEl).children().length).toBeGreaterThan(0);
        });
        return describe('after a console is selected', function() {
          beforeEach(function() {
            $('[name="imports[nexpose_console]"]').val(2);
            return $('[name="imports[nexpose_console]"]').trigger('change');
          });
          it('should call _showForm', function() {
            server.respond();
            return expect(this.controller._showForm.calledOnce);
          });
          it('should call _showSitesTable', function() {
            expect(this.controller._showSitesTable.calledOnce);
            return server.respond();
          });
          describe('when import existing data is set', function() {
            return it('should render the sites table with two sites', function() {
              var spec;
              spec = function() {
                return expect($('.nexpose-sites-region tbody tr').length).toEqual(2);
              };
              return deferServerResponse(spec);
            });
          });
          return describe('when scan and import data selected', function() {
            beforeEach(function() {
              $('#scan-and-import').prop('checked', true);
              return $('[name="imports[nexpose][type]"]').trigger('change');
            });
            it('should render the scan and import data form', function() {
              var spec;
              spec = function() {
                expect($('#nexpose_scan_task_whitelist_string').length).toEqual(1);
                expect($('#nexpose_scan_task_blacklist_string').length).toEqual(1);
                expect($('#nexpose_scan_task_scan_template').length).toEqual(1);
                return expect($('#nexpose_scan_task_scan_template option').length).toEqual(2);
              };
              return deferServerResponse(spec);
            });
            return it('should render the scan templates from the import run', function() {
              var spec;
              spec = function() {
                expect($($('#nexpose_scan_task_scan_template option')[0]).val()).toEqual('custom-template-1');
                return expect($($('#nexpose_scan_task_scan_template option')[1]).val()).toEqual('custom-template-2');
              };
              return deferServerResponse(spec);
            });
          });
        });
      });
    });
  });

}).call(this);
