(function() {

  define(['/assets/web_scans/backbone/models/web_scan_stats-3e2760bf0dee9f8e7815bfa754d5e34a7e64f37da18c7fecf7fa3531652ac541.js'], function(module) {
    return describe('WebScanStats', function() {
      var taskId, webScanStats, workspaceId;
      webScanStats = void 0;
      workspaceId = 1;
      taskId = 2;
      beforeEach(function() {
        return webScanStats = new WebScanStats({
          workspaceId: workspaceId,
          taskId: taskId
        });
      });
      it("URL endpoint should be set by constructor", function() {
        return expect(webScanStats.url()).toBe("/workspaces/" + workspaceId + "/web_scans/" + taskId + ".json");
      });
      it("should have 0 web pages by default", function() {
        return expect(webScanStats.get('web_pages').value).toBe(0);
      });
      it("should have 'Web pages' to display stat name", function() {
        return expect(webScanStats.get('web_pages').display).toBe("Web pages");
      });
      it("should have 0 web forms by default", function() {
        return expect(webScanStats.get('web_forms').value).toBe(0);
      });
      it("should have 'Web forms' to display stat name", function() {
        return expect(webScanStats.get('web_forms').display).toBe("Web forms");
      });
      it("should have 0 web vulns by default", function() {
        return expect(webScanStats.get('web_vulns').value).toBe(0);
      });
      return it("should have 'Web vulns' to display stat", function() {
        return expect(webScanStats.get('web_vulns').display).toBe("Web vulns");
      });
    });
  });

}).call(this);
