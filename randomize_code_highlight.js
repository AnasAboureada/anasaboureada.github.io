var fs = require('fs');
const replace = require('replace-in-file');

var syntaxPath = '_assets/styles/blog_scss/_blog_syntax.scss'
var highlights = fs.readFileSync(syntaxPath, 'utf8');
var fileColors = highlights.match(/\#.{6}/g);

for (i in fileColors){
  var randomColor = Math.floor(Math.random()*16777215).toString(16);
  while (randomColor.length < 6) {
    randomColor = '0' + randomColor;
  }
  var orig_color = fileColors[i].slice(1, fileColors[i].length);

  console.log('changing from ', orig_color, 'to', randomColor);

  const options = {
    files: syntaxPath,
    from: orig_color,
    to: randomColor,
  };

  try {
    const changes = replace.sync(options);
    console.log('Modified files:', changes.join(', '));
  }
  catch (error) {
    console.error('Error occurred:', error);
  }
}
