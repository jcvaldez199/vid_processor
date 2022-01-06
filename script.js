//var document = {
//    name  : "document_name",
//    title : "document_title"
//};

//var document = require('./testfile.json');
$.getJSON("testfile.json", function(json) {
  console.log(json);
  db.imagetest_normal.insert({json});
});


