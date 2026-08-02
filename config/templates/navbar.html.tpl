
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
      <ul class="nav navbar-nav navbar-left sanchaya-utility-nav" aria-label="Site links">
        <li><a href="/labs/" title="Labs" aria-label="Labs"><svg class="sanchaya-labs-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 2h6"></path><path d="M10 2v7.5L4 19a2 2 0 0 0 1.7 3h12.6A2 2 0 0 0 20 19l-6-9.5V2"></path><path d="M6.4 16h11.2"></path><path d="M8 18.5h.01"></path></svg><span class="sr-only">Labs</span></a></li>
      </ul>
      <div class="sanchaya-search-mode navbar-left">
        <div class="sanchaya-simple-panel">
          <form class="navbar-form navbar-left" action="search" data-sanchaya-search-form>
            <div class="form-group">
              <div class="sanchaya-search-row">
                <div class="sanchaya-search-field">
                  <input class="form-control"
                        placeholder="Search terms..." role="search"
                        id="navsearchbox" type="text" name="q" autofocus
                        {{if .Query}}
                        value="{{.Query}}"
                        {{end}}>
                  <button class="btn btn-default sanchaya-advanced-toggle" type="button"
                          title="Advanced search" aria-label="Advanced search" aria-expanded="false">
                    <span class="glyphicon glyphicon-filter" aria-hidden="true"></span>
                  </button>
                </div>
                <div class="input-group sanchaya-basic-option">
                  <div class="input-group-addon">Max Results</div>
                  <input class="form-control" type="number" id="maxhits" name="num" value="{{.Num}}">
                </div>
                <div class="input-group sanchaya-basic-option">
                  <div class="input-group-addon">Context Lines</div>
                  <input class="form-control" id="context" name="ctx" type="number" value="{{.Ctx}}">
                </div>
                <button class="btn btn-primary sanchaya-search-submit" type="submit">Search</button>
              </div>
              <span class="help-block sanchaya-search-guard" aria-live="polite"></span>
              <!--Hack: we use a hidden form field to keep track of the debug flag across searches-->
              {{if .Debug}}<input id="debug" name="debug" type="hidden" value="{{.Debug}}">{{end}}
            </div>
          </form>
        </div>
        {{template "advancedSearchWidget"}}
      </div>
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
