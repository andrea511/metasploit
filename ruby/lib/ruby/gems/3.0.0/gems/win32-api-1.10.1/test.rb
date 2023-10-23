
require 'fiddle/import'

module IOExt
  extend Fiddle::Importer
  dlload 'concrt140.dll'

  extern 'int _getmaxstdio( void );'
  extern 'int _setmaxstdio( int new_max );'
end
