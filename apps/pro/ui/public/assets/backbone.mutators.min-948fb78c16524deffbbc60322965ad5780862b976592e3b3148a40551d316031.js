/*! Backbone.Mutators - v0.4.1
------------------------------
Build @ 2014-03-27
Documentation and Full License Available at:
http://asciidisco.github.com/Backbone.Mutators/index.html
git://github.com/asciidisco/Backbone.Mutators.git
Copyright (c) 2014 Sebastian Golasch <public@asciidisco.com>

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the

Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.*/

!function(a,b,c){"use strict";"object"==typeof exports?module.exports=b(require("underscore"),require("backbone")):"function"==typeof define&&define.amd?define(["underscore","backbone"],function(d,e){return d=d===c?a._:d,e=e===c?a.Backbone:e,a.returnExportsGlobal=b(d,e,a)}):a.returnExportsGlobal=b(a._,a.Backbone)}(this,function(a,b,c,d){"use strict";b=b===d?c.Backbone:b,a=a===d?c._:a;var e=function(){},f=b.Model.prototype.get,g=b.Model.prototype.set,h=b.Model.prototype.toJSON;return e.prototype.mutators={},e.prototype.get=function(b){var c=this.mutators!==d;return c===!0&&a.isFunction(this.mutators[b])===!0?this.mutators[b].call(this):c===!0&&a.isObject(this.mutators[b])===!0&&a.isFunction(this.mutators[b].get)===!0?this.mutators[b].get.call(this):f.call(this,b)},e.prototype.set=function(b,c,e){var f=this.mutators!==d,h=null,i=null;return h=g.call(this,b,c,e),a.isObject(b)||null===b?(i=b,e=c):(i={},i[b]=c),f===!0&&a.isObject(this.mutators[b])===!0&&(a.isFunction(this.mutators[b].set)===!0?h=this.mutators[b].set.call(this,b,i[b],e,a.bind(g,this)):a.isFunction(this.mutators[b])&&(h=this.mutators[b].call(this,b,i[b],e,a.bind(g,this)))),f===!0&&a.isObject(i)&&a.each(i,a.bind(function(b,c){if(a.isObject(this.mutators[c])===!0){var f=this.mutators[c];a.isFunction(f.set)&&(f=f.set),a.isFunction(f)&&((e===d||a.isObject(e)===!0&&e.silent!==!0&&e.mutators!==d&&e.mutators.silent!==!0)&&this.trigger("mutators:set:"+c),f.call(this,c,b,e,a.bind(g,this)))}},this)),h},e.prototype.toJSON=function(b){var c,d,e=h.call(this);return a.each(this.mutators,a.bind(function(f,g){a.isObject(this.mutators[g])===!0&&a.isFunction(this.mutators[g].get)?(c=a.has(b||{},"emulateHTTP"),d=this.mutators[g].transient,c&&d||(e[g]=a.bind(this.mutators[g].get,this)())):a.isFunction(this.mutators[g])&&(e[g]=a.bind(this.mutators[g],this)())},this)),e},e.prototype.escape=function(b){var c=this.get(b);return a.escape(null==c?"":""+c)},a.extend(b.Model.prototype,e.prototype),b.Mutators=e,e});
