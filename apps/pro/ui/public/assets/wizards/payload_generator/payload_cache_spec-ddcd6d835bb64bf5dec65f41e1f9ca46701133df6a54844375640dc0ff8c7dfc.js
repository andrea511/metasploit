(function() {

  define(['jquery', '/assets/wizards/payload_generator/mixins/datastore-84cf40e6c43a44f3c767b3373fd6ce524024e34be40a16b0c45ff0b775513ce4.js', '/assets/wizards/payload_generator/encoder-68515368c02ab5ad1ae35b9f6d48cc3d2e70418396137052ba1ca887687ac05d.js', '/assets/wizards/payload_generator/payload-2cdfe45703230514468d67715c30c9f9cc18002ecebb1488df9ad9505c0175a4.js', '/assets/wizards/payload_generator/payload_cache-705bd267276c9d0d65b73f1b6edac71e697cd34125f255ec3fbf592011d7fef0.js'], function($) {
    return describe('PayloadCache', function() {
      var encoder, payload;
      payload = function() {
        return {
          fullname: 'exploit/unix/test_exploit',
          platform: ['Msf::Module::Platform::Unix'],
          arch: ['x86']
        };
      };
      encoder = function() {
        return {
          fullname: 'x86/alpha_mixed',
          arch: 'x86'
        };
      };
      beforeEach(function() {
        PayloadCache._version = function() {
          return "Test";
        };
        return PayloadCache.reset();
      });
      it('has an addPayloads method', function() {
        return expect(PayloadCache.addPayloads).toBeDefined();
      });
      it('has a plaforms method', function() {
        return expect(PayloadCache.platforms).toBeDefined();
      });
      it('has a isEmpty method', function() {
        return expect(PayloadCache.isEmpty).toBeDefined();
      });
      it('has a loadFromCache method', function() {
        return expect(PayloadCache.loadFromCache).toBeDefined();
      });
      it('is initially empty', function() {
        return expect(PayloadCache.isEmpty()).toBe(true);
      });
      describe('#payloads()', function() {
        it('returns an empty Array', function() {
          return expect(PayloadCache.payloads()).toEqual([]);
        });
        return describe('after adding a Payload', function() {
          beforeEach(function() {
            return PayloadCache.addPayloads([payload()]);
          });
          return it('contains a single Payload instance', function() {
            return expect(_.map(PayloadCache.payloads(), function(p) {
              return p.constructor;
            })).toEqual([Payload]);
          });
        });
      });
      describe('#encoders()', function() {
        it('returns an empty Array', function() {
          return expect(PayloadCache.encoders()).toEqual([]);
        });
        return describe('after adding an Encoder', function() {
          beforeEach(function() {
            return PayloadCache.addEncoders([encoder()]);
          });
          return it('contains a single Encoder instance', function() {
            return expect(_.map(PayloadCache.encoders(), function(p) {
              return p.constructor;
            })).toEqual([Encoder]);
          });
        });
      });
      describe('#platforms()', function() {
        it('returns an empty Array', function() {
          return expect(PayloadCache.platforms()).toEqual([]);
        });
        return describe('after adding a Payload', function() {
          beforeEach(function() {
            return PayloadCache.addPayloads([payload()]);
          });
          return it('returns ["Unix"]', function() {
            return expect(PayloadCache.platforms()).toEqual(["Unix"]);
          });
        });
      });
      describe('#arches()', function() {
        it('returns an empty Array', function() {
          return expect(PayloadCache.arches()).toEqual([]);
        });
        return describe('after adding a Payload', function() {
          beforeEach(function() {
            return PayloadCache.addPayloads([payload()]);
          });
          describe('called with no arguments', function() {
            return it('returns ["x86"]', function() {
              return expect(PayloadCache.arches()).toEqual(["x86"]);
            });
          });
          describe('called with a {platform:joe} arguments', function() {
            return it('returns []', function() {
              return expect(PayloadCache.arches({
                platform: 'joe'
              })).toEqual([]);
            });
          });
          return describe('called with a {platform:Unix} arguments', function() {
            return it('returns ["x86"]', function() {
              return expect(PayloadCache.arches({
                platform: 'Unix'
              })).toEqual(["x86"]);
            });
          });
        });
      });
      describe('#loadFromAjax()', function() {
        var server;
        server = null;
        beforeEach(function() {
          server = sinon.fakeServer.create();
          server.respondWith("GET", PayloadCache.PAYLOADS_URL, [
            200, {
              "Content-Type": "application/json"
            }, JSON.stringify([payload()])
          ]);
          return server.respondWith("GET", PayloadCache.ENCODERS_URL, [
            200, {
              "Content-Type": "application/json"
            }, JSON.stringify([encoder()])
          ]);
        });
        afterEach(function() {
          return server.restore();
        });
        it('calls the callback once', function(done) {
          var cb;
          cb = sinon.spy();
          return PayloadCache.loadFromAjax(function(p) {
            expect(true).toBe(true);
            return done();
          });
        });
        it('passes the callback an object with a payloads key', function(done) {
          return PayloadCache.loadFromAjax(function(p) {
            expect((p != null ? p.payloads : void 0) != null).toBe(true);
            return done();
          });
        });
        return it('passes the callback an object with an encoders key', function(done) {
          return PayloadCache.loadFromAjax(function(p) {
            expect((p != null ? p.encoders : void 0) != null).toBe(true);
            return done();
          });
        });
      });
      return describe('when PayloadCache.useLocalStorage=true', function() {
        beforeEach(function() {
          return PayloadCache.useLocalStorage = true;
        });
        describe('after adding a Payload', function() {
          beforeEach(function() {
            return PayloadCache.addPayloads([payload()]);
          });
          it('is not empty', function() {
            return expect(PayloadCache.isEmpty()).toBe(false);
          });
          return describe('#payloads', function() {
            return it('contains a single Payload instance', function() {
              return expect(_.map(PayloadCache.payloads(), function(p) {
                return p.constructor;
              })).toEqual([Payload]);
            });
          });
        });
        describe('after adding a Payload, resetting, and reloading from cache', function() {
          beforeEach(function() {
            PayloadCache.addPayloads([payload()]);
            PayloadCache.addEncoders([encoder()], {
              updateStorage: true
            });
            PayloadCache.reset({
              preserveLocalStorage: true
            });
            return PayloadCache.loadFromCache();
          });
          it('is not empty', function() {
            return expect(PayloadCache.isEmpty()).toBe(false);
          });
          return describe('#payloads', function() {
            return it('contains a single Payload instance', function() {
              return expect(_.map(PayloadCache.payloads(), function(p) {
                return p.constructor;
              })).toEqual([Payload]);
            });
          });
        });
        return describe('after adding a Payload, resetting, reloading from cache, then calling #reset', function() {
          beforeEach(function() {
            PayloadCache.addPayloads([payload()]);
            PayloadCache.addEncoders([encoder()], {
              updateStorage: true
            });
            PayloadCache.reset({
              preserveLocalStorage: true
            });
            PayloadCache.loadFromCache();
            return PayloadCache.reset();
          });
          return it('is empty', function() {
            return expect(PayloadCache.isEmpty()).toBe(true);
          });
        });
      });
    });
  });

}).call(this);
