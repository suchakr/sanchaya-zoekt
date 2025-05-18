{{define "body"}}
<div class="banner" style="background-color: #FFFF00; padding: 15px; margin-bottom: 20px;">
  <h1 class="zoekt-h1"><span class="sanchaya-brand">सञ्चयः</span> Search - TEST CHANGE</h1>
</div>
<form action="search">
<div class="input-group input-group-lg">
  {{if .Last}}
  <input class="form-control" placeholder="Search for something, regexp allowed." autofocus {{if .AutoFocus}}autofocus{{end}}
         type="text" name="q" value="{{.Last}}" />
  {{else}}
  <input class="form-control" placeholder="Search for something, regexp allowed." autofocus {{if .AutoFocus}}autofocus{{end}}
  type="text" name="q" value="" />
  {{end}}
  <span class="input-group-btn">
    <button class="btn btn-primary">Search</button>
  </span>
</div><!-- /input-group -->
<div class="checkbox">
  <label title="Regular expression search is more powerful, but may be slower.">
    <input name="regexp" {{if .PatternType }}checked{{end}}
                            type="checkbox"> Regular expression
  </label>
  <a class="btn btn-xs btn-default tooltip-toggle" data-toggle="tooltip" data-placement="bottom"><span class="glyphicon glyphicon-question-sign"></span></a>
</div>
</form>

<center>
{{if .Repos}}
<h5>This server knows about the following repositories:</h5>
<kbd>
  {{range .Repos}}
  {{.Name}}
  {{end}}
</kbd>
{{end}}
</center>
{{end}}
