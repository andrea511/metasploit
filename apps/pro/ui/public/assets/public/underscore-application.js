(function() {

  _.templateSettings = {
    evaluate: /\{%([\s\S]+?)%\}/g,
    escape: /\{\{([\s\S]+?)\}\}/g
  };

}).call(this);
