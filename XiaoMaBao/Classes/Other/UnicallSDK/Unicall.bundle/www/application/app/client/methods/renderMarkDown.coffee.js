(function(){

/////////////////////////////////////////////////////////////////////////
//                                                                     //
// client/methods/renderMarkDown.coffee.js                             //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
                                                                       //
__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
this.MarkDownRender = function(message) {                              // 2
  var msg;                                                             // 3
  if (message.html) {                                                  // 3
    msg = message.html.trim();                                         // 5
    msg = msg.replace(/!\[([^\]]+)\]\((https?:\/\/[^\)]+)\)/gm, '<a href="$2" title="$1" class="swipebox" target="_blank"><div class="inline-image" style="background-image: url($2);"></div></a>');
    msg = msg.replace(/\[([^\]]+)\]\((https?:\/\/[^\)]+)\)/gm, '<a href="$2" target="_blank">$1</a>');
    msg = msg.replace(/^# (([\w\d-_\/\*\.,\\] ?)+)/gm, '<h1>$1</h1>');
    msg = msg.replace(/^## (([\w\d-_\/\*\.,\\] ?)+)/gm, '<h2>$1</h2>');
    msg = msg.replace(/^### (([\w\d-_\/\*\.,\\] ?)+)/gm, '<h3>$1</h4>');
    msg = msg.replace(/^#### (([\w\d-_\/\*\.,\\] ?)+)/gm, '<h4>$1</h4>');
    msg = msg.replace(/(^|&gt;|[ >_*~])\`([^`\r\n]+)\`([<_*~]|\B|\b|$)/gm, '$1<span class="copyonly"></span><code class="inline">$2</code><span class="copyonly"></span>$3');
    msg = msg.replace(/(^|&gt;|[ >_~`])\*{1,2}([^\*\r\n]+)\*{1,2}([<_~`]|\B|\b|$)/gm, '$1<span class="copyonly"></span><strong>$2</strong><span class="copyonly"></span>$3');
    msg = msg.replace(/(^|&gt;|[ >*~`])\_([^\_\r\n]+)\_([<*~`]|\B|\b|$)/gm, '$1<span class="copyonly"></span><em>$2</em><span class="copyonly"></span>$3');
    msg = msg.replace(/(^|&gt;|[ >_*`])\~{1,2}([^~\r\n]+)\~{1,2}([<_*`]|\B|\b|$)/gm, '$1<span class="copyonly"></span><strike>$2</strike><span class="copyonly"></span>$3');
    msg = msg.replace(/^&gt;(.*)$/gm, '<blockquote><span class="copyonly">&gt;</span>$1</blockquote>');
    msg = msg.replace(/<\/blockquote>\n<blockquote>/gm, '</blockquote><blockquote>');
    return message.html = msg;                                         //
  }                                                                    //
};                                                                     // 2
                                                                       //
/////////////////////////////////////////////////////////////////////////

}).call(this);
