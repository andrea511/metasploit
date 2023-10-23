var $j = jQuery.noConflict();

var total_nodes = parseInt($j('meta[name="msp:map_total_nodes"]').attr('content'));
var zoom = total_nodes/50;
zoom = (zoom < 1) ? 1 : zoom;
var mag = zoom;
zoom = (zoom > 3 ) ? 3 : zoom;
var radius = 30;

var w = 1175,
    h = 500*mag+500,
    i = 0,
    duration = 1000,
    root,
    offset=0;

var tree = d3.layout.tree()
    .size([h-150, w - 175]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

var vis = d3.select(".tab_panel").append("svg:svg")
    .attr("width", w)
    .attr("height", h)  
    .append("svg:g")
    .attr("transform", "translate(40,0)");

function os_regex(os){
  var windows = /windows/i;
  var cisco = /cisco/i;
  var swtch = /switch/i;
  var apple = /apple/i;
  var bsd = /bsd/i;
  var freebsd = /freebsd/i;
  var aix = /aix/i;
  var printer = /printer/i;
  var msf = /localhost/i;
  var linux = /linux/i;
  var solaris = /solaris/i;
  
  if(windows.test(os)){
    return "windows";
  }else if(cisco.test(os)){
    return "cisco";
  }else if(swtch.test(os)){
    return "switch";
  }else if(apple.test(os)){
    return "apple";
  }else if(freebsd.test(os)){
    return "freebsd";
  }else if(bsd.test(os)){
    return "bsd";
  }else if(aix.test(os)){
    return "aix";
  }else if(printer.test(os)){
    return "printer";
  }else if(msf.test(os)){
    return "localhost";
  }else if(linux.test(os)){
    return "linux";
  }else if(solaris.test(os)){
    return "solaris";
  }else{
    return "unknown";
  }
}

function build_drop_down(data){
  var name = (data.name == null) ? "Hostname Unknown" : data.name;
  var comments = (data.comments == null) ? "Comments: None" : "Comments: "+data.comments;
  comments = comments.replace(/>/g,"&gt;");
  comments = comments.replace(/</g,"&lt;");
  comments = (data.os_name == null) ? "IP Not in Hosts List" : comments;
  var trace = (data.no_traceroute) ? "No traceroute exists for host" : "";
  var os_flavor = (data.os_flavor == null) ? " " : data.os_flavor;
  var os_name = (data.os_name == "Unknown" || data.os_name == null) ? "Unknown OS" : data.os_name;
  var os = ""+os_name+" "+os_flavor;
  var idl = (data.os_name == "localhost") ? "<div class=\"linktext\"><a href='../'>"+data.ip+"</a></div><br>" : "<div class=\"linktext\"><a href='/hosts/"+data.id+"'>"+data.ip+"</a></div><br>";
  var id_name = (data.os_name == null) ? "<div class=\"linktext\">"+data.ip+"</div><br>" : idl;
  var links = (data.os_name == "localhost") ? "" : "<hr><bold><div class=\"al\"><a href='../tasks/new_scan?host_ids[]="+data.id+"'>Scan</a><br>"+
  "<a href='../tasks/new_bruteforce?host_ids[]="+data.id+"'>Bruteforce</a><br>"+
  "<a href='../imports/new#nexpose'>Nexpose</a><br>"+
  "<a href='../tasks/new_webscan?host_ids[]="+data.id+"'>WebScan</a><br>"+
  "<a href='../tasks/new_exploit?host_ids[]="+data.id+"'>Exploit</a><br>"+
  "<a href='../modules/'>Modules</a></bold></div>"
  ;
  var linx = (data.os_name == null) ? "<hr><div class=\"linktext\"><a align=\"left\" href='../tasks/new_scan?target_addresses="+data.ip+"'>Scan</a><br>" : links;

  return id_name+
  "<table border=0><tr><td align='left' class=\"nodetext\">"+name+
  "</td></tr><tr>" +
  "<td class=\"nodetext\">"+os+
  "</td></tr>"+
  "<td class=\"nodetext\">"+trace+
  "</td></tr><tr>" +
  "<td>&nbsp;&nbsp;"+
  "</td></tr></table>"+
  "<div class=\"nodetext\"><hr>"+comments+"</div>"+
  linx
  }

var tag = /#/g;

var search = $j('meta[name="msp:map_search"]').attr('content');
sString = "&search=" + encodeURIComponent(search);

var trace_hosts = $j('meta[name="msp:map_trace_hosts"]').attr('content');
if((search != "") && !trace_hosts){
    trace_hosts = tag.test(search)
}
trace_hosts = (trace_hosts == false) ? "" : "&trace_hosts=true"

d3.json("map?format=json"+sString+trace_hosts, function(json) {
  json.x0 = 800;
  json.y0 = 0;
  update(root = json);
});

function update(source) {

  var nodes = tree.nodes(root);

  var node = vis.selectAll("g.node")
      .data(nodes, function(d) {
        return d.id || (d.id = ++i); });

  var nodeEnter = node.enter().append("svg:g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + source.y0 + "," + source.x0 + ")"; });

   nodeEnter.append("svg:circle")
      .attr("class", "circ")
      .attr("cx", radius/zoom)
      .attr("cy", radius/zoom)
      .attr("fill", function(d){ return d._children ? "transparent" : "transparent";})
      .attr("r", (radius/zoom)/1.1);
      
   nodeEnter.append("svg:circle")
      .attr("class", "circ")
      .attr("cx", radius/zoom -radius/(3*zoom))
      .attr("cy", radius/zoom) 
      .attr("opacity", ".5")
      .attr("fill", function(d){
        switch(d.status)
        {
          case 2:
            return "blue";
            break;
          case 3:
            return "red";
            break;
          case 4:
            return "gray";
            break;
          default:
            return "transparent";
            break;
        }})
      .attr("r", (radius/zoom)/1.5);
      
  nodeEnter.append("svg:image")
      .attr("class", "icon")
      .attr("xlink:href", function(d) {
        if((d.id == null || d.status == null) && d.os_name != "localhost"){
          return '/assets/icons/silky/arrow_right-2d04288f620a60918b6f6590589b3bb205aec7a8c2fa0482abb7bdccaf83dd60.png';
        }
        switch(os_regex(d.os_name))
            {
              case "windows":
                return '/assets/icons/os/winlogo-a889181eb1da7f1e02a4f8a951bd873e2860a85ea8cf002575106f57f0c84363.png';
                break;
              case "localhost":
                return '/assets/icons/stef-a49130a2119c0b84241f6415394cd9e4f546c2bfe18b913d9eaeb8b6ef433608.jpg';
                break;
              case "linux":
                return '/assets/icons/os/linuxlogo-d581e7c323bf5476477c9ec7c477d7280fc492665c3825856b9938b491f39382.png';
                break;
              case "apple":
                return '/assets/icons/os/apple_logo-1af046942c147f25021c4b9208f40e86b841941e4ca08b8750b138c485270348.png';
                break;
              case "cisco":
                return '/assets/icons/os/cisco_logo-da4db925fd34808fd55d7e71b7d6e1faa231a395a779451b323cdae7b5fa2a93.png';
                break;
              case "embedded":
                return '/assets/icons/os/router_logo-fc8b7d0a3080135b4efdad7218a85b27ac6c7e0dc793e5c4628405cc1f966f9c.png';
                break;
              case "bsd":
                return '/assets/icons/os/bsd_logo-9f813d8515abe689bc3b9e3759741b529d1176a41973f02b76c7b45b1c064c98.png';
                break;
              case "freebsd":
                return '/assets/icons/os/freebsd_logo-cc758cf3317b14f2713335768d47f94be8e57d81633d1e420ca22c5beba93905.png';
                break;
              case "printer":
                return '/assets/icons/os/printer_logo-9d3fbd24f6945bff50cf6aa9168ceeb3009856407e9561459c6289d252d7c7aa.png';
                break;  
              case "aix":
                return '/assets/icons/os/aix_logo-9d79d58416d2ecf33b845f18e737f0053fa4878957d7f24ead05c11f51f0c5ba.png';
                break;
              case "solaris":
                return '/assets/icons/os/solaris_logo-8548360e390f4f007b2089512e6f7d6db7a27fed8305c9e46f72b32cea3e32ba.png';
                break;
              default:
                return '/assets/icons/silky/computer-e98a48c1a5362b16903a1e97790bf044510bcc12a1e77416c4b2c570583d3f8d.png';
                break;
            }
          })
      .attr("width", radius/zoom)
      .attr("height", radius/zoom)
      .attr("y", radius/zoom/2)
      .on("click", click)
      .append("svg:title")
      .text(function(d) { return build_drop_down(d) });
  
  nodeEnter.append("svg:text")
        .attr("class",function(d){
           if(zoom <= 1){
            return "treetext_large";
           }else{
            return "treetext_small"
           }
        })
        .text(function(d) {
          return d.ip; })
        .transition()
        .duration(duration)
        .attr("dx", function(d){
          //x = 0 is from the top left corner
          if (d.children == null || d.children.length == 0){
           //leaf node
           return (zoom <= 1) ? 33 : (zoom <= 2 ) ? 20 : 11
          }
          return 0;})
        .attr("dy", function(d){
          //y=0 is from the top left corner
          if (d.children == null || d.children.length == 0){
           return (zoom <= 1) ? 33 : (zoom <= 2 ) ? 20 : 15
          }
          
          var above = (zoom <= 1) ? 18 : (zoom <= 2 ) ? 10 : 5;
          var below = (zoom <= 1) ? 50 : (zoom <= 2 ) ? 35 : 24;
          return d.depth & 1 ? above : below});
        
  node.transition()
      .duration(duration)
      .attr("transform", function(d) {
        return "translate(" + d.y + "," + (d.x-(radius/zoom)) + ")"; })
      .style("opacity", "1")
      .select("circle")
      .style("cx", radius)
      .style("cy", radius/2)
      .style("fill", function(d){return d._children ? "#069" : "transparent";})
      
  node.exit().transition()
      .duration(duration)
      .remove();
  
  var link = vis.selectAll("path.link")
      .data(tree.links(nodes), function(d) { return d.target.id; });

  link.enter().insert("svg:path", "g")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: source.x0, y: source.y0};
        return diagonal({source: o, target: o});
      })
    .transition()
      .duration(duration)
      .attr("d", diagonal);

  link.transition()
      .duration(duration)
      .attr("d", diagonal);

  link.exit().transition()
      .duration(duration)
      .attr("d", function(d) {
        var o = {x: source.x, y: source.y};
        return diagonal({source: o, target: o});
      })
      .remove();
 
  nodes.forEach(function(d) {
    d.x0 = d.x;
    d.y0 = d.y;
  });

  $j(document).ready(function(){
      $j(".icon").tipsy({gravity:'n', html:true, fade: true, opacity:.95, offsetHeight:radius/zoom, offsetWidth:radius/2});
  });

}
function click(d) {

  if (d.children) {
    d._children = d.children;
    d.children = null;
  } else {
    d.children = d._children;
    d._children = null;
  }
  update(d);
}
;
