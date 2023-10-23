(function() {

  define(['entities/cred'], function($) {
    return describe('Entities.Cred', function() {
      set('credOptions', function() {
        return {};
      });
      set('cred', function() {
        return new Pro.Entities.Cred(credOptions);
      });
      describe('#isTruncated', function() {
        describe('when the private data is longer than the truncated private data', function() {
          set('credOptions', function() {
            return {
              'private.data': 'password',
              'private.data_truncated': 'pass...'
            };
          });
          return it('returns true', function() {
            return expect(cred.isTruncated()).toBe(true);
          });
        });
        return describe('when the private data is the same length as the truncated private data', function() {
          set('credOptions', function() {
            return {
              'private.data': 'password',
              'private.data_truncated': 'password'
            };
          });
          return it('returns false', function() {
            return expect(cred.isTruncated()).toBe(false);
          });
        });
      });
      return describe('#isSSHkey', function() {
        describe('when the private type is SSH key', function() {
          set('credOptions', function() {
            return {
              'private.type': 'ssh'
            };
          });
          return it('returns true', function() {
            return expect(cred.isSSHKey()).toBe(true);
          });
        });
        return describe('when the private type is not an SSH key', function() {
          set('credOptions', function() {
            return {
              'private.type': 'none'
            };
          });
          return it('returns false', function() {
            return expect(cred.isSSHKey()).toBe(false);
          });
        });
      });
    });
  });

}).call(this);
