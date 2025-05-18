
<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="/">सञ्चयः</a>
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>
    <div class="navbar-collapse collapse" id="navbar-collapse" aria-expanded="false" style="height: 1px;">
      <form class="navbar-form navbar-left" action="search">
        <div class="form-group">
          <input class="form-control"
                placeholder="Search for some code..." role="search"
                id="navsearchbox" type="text" name="q" autofocus
                {{if .Query}}
                value={{.Query}}
                {{end}}>
          <div class="input-group">
            <div class="input-group-addon">Max Results</div>
            <input class="form-control" type="number" id="maxhits" name="num" value="{{.Num}}">
          </div>
          <div class="input-group">
            <div class="input-group-addon">Context Lines</div>
            <input class="form-control" id="context" name="ctx" type="number" value="{{.Ctx}}">
          </div>
          <button class="btn btn-primary">Search</button>
          <!--Hack: we use a hidden form field to keep track of the debug flag across searches-->
          {{if .Debug}}<input id="debug" name="debug" type="hidden" value="{{.Debug}}">{{end}}
        </div>
      </form>
    </div>
  </div>
</nav>
<script>
document.onkeydown=function(e){
  var e = e || window.event;
  if (e.key == "/") {
    var navbox = document.getElementById("navsearchbox");
    if (document.activeElement !== navbox) {
      navbox.focus();
      return false;
    }
  }
};
</script>
