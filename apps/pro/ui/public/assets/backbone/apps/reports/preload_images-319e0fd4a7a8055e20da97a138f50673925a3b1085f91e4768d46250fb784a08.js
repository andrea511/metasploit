(function() {
  var PRELOADED_REPORT_IMAGES, PRELOADED_RETINA_REPORT_IMAGES, RetinaDetector, reportImages;

  RetinaDetector = {
    useRetinaImages: function() {
      return this.isHighDensity() || this.isRetina();
    },
    isHighDensity: function() {
      return (window.matchMedia && (window.matchMedia('only screen and (min-resolution: 124dpi), only screen and (min-resolution: 1.3dppx), only screen and (min-resolution: 48.8dpcm)').matches || window.matchMedia('only screen and (-webkit-min-device-pixel-ratio: 1.3), only screen and (-o-min-device-pixel-ratio: 2.6/2), only screen and (min--moz-device-pixel-ratio: 1.3), only screen and (min-device-pixel-ratio: 1.3)').matches)) || (window.devicePixelRatio && window.devicePixelRatio > 1.3);
    },
    isRetina: function() {
      return ((window.matchMedia && (window.matchMedia('only screen and (min-resolution: 192dpi), only screen and (min-resolution: 2dppx), only screen and (min-resolution: 75.6dpcm)').matches || window.matchMedia('only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (-o-min-device-pixel-ratio: 2/1), only screen and (min--moz-device-pixel-ratio: 2), only screen and (min-device-pixel-ratio: 2)').matches)) || (window.devicePixelRatio && window.devicePixelRatio > 2)) && /(iPad|iPhone|iPod)/g.test(navigator.userAgent);
    }
  };

  PRELOADED_REPORT_IMAGES = ["/assets/reports/formats/html-icon-not-generated-ab9f11f17298ca2804a0bbbfce9e981614f5d8c9e9471209cbee9e3bf005ca16.png", "/assets/reports/formats/html-icon-regenerate-898abf9318ab75b2babf513b480e7cd4ea691d79258df1e7eb5ab6254548157b.png", "/assets/reports/formats/html-icon-84921e90cb5f88b692c4637509f478a961ef4954dfa27a6a03ca003118084b5d.png", "/assets/reports/formats/pdf-icon-not-generated-1b989ee6bff7039c40ec4b6cb1a26b38268cdbcc4efd405bb86ca3f7a1e0be8d.png", "/assets/reports/formats/pdf-icon-regenerate-b140550721d7b14f6a3506c1479fed80dc7e505172e148d87892c45423b187c8.png", "/assets/reports/formats/pdf-icon-9e73790736387ef8f3f871c874931e792165a20d156a92679d9c145911d4cf09.png", "/assets/reports/formats/regenerate-icon-50b74979511f9c63f5b57a0b810fb91f27d6e2b78a5b74285e3ee512ad0962de.png", "/assets/reports/formats/rtf-icon-not-generated-7b20f13eb028ec22e6cdd61c578ad7daccd094b13dec50aeb968db2fc3ab7ad1.png", "/assets/reports/formats/rtf-icon-regenerate-a4e97186af42b50f536babb01fc4ea0e11c08ac8cf7c406a0c6b0f6876baf0ac.png", "/assets/reports/formats/rtf-icon-50714123dfa8ac68330425fcce610588e626df1645d6798c991f42ecd7cebcb3.png", "/assets/reports/formats/word-icon-not-generated-bf2959a63114ecd803f33067b36859b560abc2ffaf8bc3dbc7b79299bd778de2.png", "/assets/reports/formats/word-icon-regenerate-9db024256f7c33b28a55c9b4b8674f195cbfb2f4ef93746e9d77a02cbf02132f.png", "/assets/reports/formats/word-icon-552d907b5e9db6ce9f43f589b80bd50ce5bcf4db90c9134490e59ab62a4073b0.png", "/assets/reports/formats/xml-icon-not-generated-9e794628ecf2db1cc577772d67e084dc45fc559e34f39ea3f4f03e89ae669fcd.png", "/assets/reports/formats/xml-icon-regenerate-c9c8ab94229535c8e8e0bc4746fd9638968bd83e49a8e77e58e63ffac3e913a0.png", "/assets/reports/formats/xml-icon-b9504557c63cf35407c00f370cfda666da825916998f1bf0d75d51666a952ef1.png", "/assets/reports/actions/destroy-action-icon-hover-43cbbe8fa8eda87d6360111b2481113d6bbe02af7957cc75a90db81e016124c8.png", "/assets/reports/actions/destroy-action-icon-d1aa2f79981588b0dd617e8624eecb3b0c47a6e712d88e94877eedd1784ba13f.png", "/assets/reports/actions/download-action-icon-hover-cfcbdf77ab16436453ce76bb99c40197784da6f2a8158f57516bafe777a65a6e.png", "/assets/reports/actions/download-action-icon-fae3a947ef09eed04e227da178df9e2a9564e16208e700e34ddc8278d0842a97.png", "/assets/reports/actions/email-action-icon-hover-6ff36cb6b5e223d172a1730fadc269a38d22f5e3ee194eedf9ba1c1d8ded2351.png", "/assets/reports/actions/email-action-icon-6bbc97d07282ba607a021b3ec7db292659c31c9d548c65226631d1eef28cb378.png"];

  PRELOADED_RETINA_REPORT_IMAGES = ["/assets/reports/formats/html-icon-not-generated@2x-824132c0b40c321b24bd77e757aa62748b7eb938be466673e9f3044e907673e2.png", "/assets/reports/formats/html-icon-regenerate@2x-965fd43d17ce2d4b97dd58b7dd6974640bb08f71fb5dd670381218dbf3c34a87.png", "/assets/reports/formats/html-icon@2x-f52574940d3e393b0f0eec9cb7f312f0c90cc1d2b8e95774e7efdde9510670b3.png", "/assets/reports/formats/pdf-icon-not-generated@2x-9a33b878adc4b329a2386b25cb0bd6245417217970a9928ae073a38288db91f3.png", "/assets/reports/formats/pdf-icon-regenerate@2x-755b71b660398a4387947d6ba881e5553d62f861bfd8ca194f81a97c65b8d313.png", "/assets/reports/formats/pdf-icon@2x-c7b0d4d131db3f7de2782d0aaa927fd6a89964e24e1b43e649c9919c66a02187.png", "/assets/reports/formats/rtf-icon-not-generated@2x-7ac30ac53e564eff5467e081f304d5b582be4d75fcc7a557e00047c369d52105.png", "/assets/reports/formats/rtf-icon-regenerate@2x-aeff78c64ee4eb344a7c25f652898e24afef4f09cd0f2f09789517c5f69ac726.png", "/assets/reports/formats/rtf-icon@2x-7d95ebd6f72308214fb5034cee4b7d29ce6748b72dd4c9c0c73d7f7d7166236c.png", "/assets/reports/formats/word-icon-not-generated@2x-d63c7250a374be226fa30b4104778b25b99a9021786edcfc0b6a716c420d1c33.png", "/assets/reports/formats/word-icon-regenerate@2x-1dd05275533ccbf7cf6e04236cabe0492a3722ce1bef40459c754053717cff56.png", "/assets/reports/formats/word-icon@2x-4cd5d524d0546151880fafcba1b43217ebe9ff0519df2a7b67b1c3f3e1ac8cb9.png", "/assets/reports/formats/xml-icon-not-generated@2x-c630ea88f940710a7ca4b4d2d646ce686d8b66df1f79efc8a8f5a80f52a6713e.png", "/assets/reports/formats/xml-icon-regenerate@2x-dad17e19207bbc54f8b1f5ec9c73a1503d4727e4bacc934c5e30741e8d5e92fa.png", "/assets/reports/formats/xml-icon@2x-301df9a1507eb1e8079e9a18cc26cee41d61012efa5ef30cf2290effbe57b4e4.png", "/assets/reports/actions/destroy-action-icon-hover@2x-911b81a04fd688ae8447f026b8731f72aa849ff15f561db5b4efd9c67ab3a33b.png", "/assets/reports/actions/destroy-action-icon@2x-b559b30dbb79447549cbb5a906687decbe341d768cb542f638cdd0c82108c69d.png", "/assets/reports/actions/download-action-icon-hover@2x-76a837dbdf44bfdf5c6c2948181ca6aa6382d73a7b071de097f86775bcc94429.png", "/assets/reports/actions/download-action-icon@2x-83ade9b1312dd22823d6cc829da8113f222de0570beff1ab5f44ed8b22e43067.png", "/assets/reports/actions/email-action-icon-hover@2x-4de287fe93c7497e961fb51cfbdd409118f6171ad1253864ee35def1c5e42559.png", "/assets/reports/actions/email-action-icon@2x-a6e53dfb60a0b68904763e1521bf60a36d5e7d12778d275a18362f4cd6523304.png"];

  reportImages = RetinaDetector.useRetinaImages() ? PRELOADED_RETINA_REPORT_IMAGES : PRELOADED_REPORT_IMAGES;

  jQuery('body').append("<div id='preload-images' style='position: absolute; left: -100000px;'></div>");

  _.each(reportImages, function(src) {
    return jQuery('#preload-images').append("<img src='" + src + "'>");
  });

}).call(this);