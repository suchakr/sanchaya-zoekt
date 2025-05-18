
<html>
{{template "head"}}
<title>Results for {{.QueryStr}}</title>
<script>
  function zoektAddQ(atom) {
      window.location.href = "/search?q=" + escape("{{.QueryStr}}" + " " + atom) +
	  "&" + "num=" + {{.Last.Num}};
  }
</script>
<body id="results">
  {{template "navbar" .Last}}
  <div class="container-fluid container-results">
    <h5>
      {{if .Stats.Crashes}}<br><b>{{.Stats.Crashes}} shards crashed</b><br>{{end}}
      {{ $fileCount := len .FileMatches }}
      Found {{.Stats.MatchCount}} results in {{.Stats.FileCount}} files{{if or (lt $fileCount .Stats.FileCount) (or (gt .Stats.ShardsSkipped 0) (gt .Stats.FilesSkipped 0)) }},
        showing top {{ $fileCount }} files (<a rel="nofollow"
           href="search?q={{.Last.Query}}&num={{More .Last.Num}}">show more</a>).
      {{else}}.{{end}}
    </h5>
    {{range .FileMatches}}
    <table class="table table-hover table-condensed">
      <thead>
        <tr>
          <th colspan="2">
            {{if .URL}}<a name="{{.ResultID}}" class="result"></a><a href="{{.URL}}" >{{else}}<a name="{{.ResultID}}">{{end}}
            <small>
              {{.Repo}}:{{.FileName}} {{if .ScoreDebug}}<i>({{.ScoreDebug}})</i>{{end}}</a>:
              <span style="font-weight: normal">[ {{if .Branches}}{{range .Branches}}<span class="label label-default">{{.}}</span>,{{end}}{{end}} ]</span>
              {{if .Language}}<button
                   title="restrict search to files written in {{.Language}}"
                   onclick="zoektAddQ('lang:&quot;{{.Language}}&quot;')" class="label label-primary">language {{.Language}}</button></span>{{end}}
              {{if .DuplicateID}}<a class="label label-dup" href="#{{.DuplicateID}}">Duplicate result</a>{{end}}
            </small>
          </th>
        </tr>
      </thead>
      {{if not .DuplicateID}}
      <tbody>
        {{range .Matches}}
        {{if gt .LineNum 0}}
        <tr>
          <td style="width: 1%; white-space: nowrap; background-color: rgba(238, 238, 255, 0.6);">
<pre class="inline-pre"><p style="margin: 0px;">{{$beforeLines := AddLineNumbers .Before .LineNum true}}{{range $line := $beforeLines}}<span class="noselect"><u>{{$line.LineNum}}</u>:</span>
{{end}}<span class="noselect">{{if .URL}}<a href="{{.URL}}">{{end}}<u>{{.LineNum}}</u>{{if .URL}}</a>{{end}}:</span>
{{$afterLines := AddLineNumbers .After .LineNum false}}{{range $line := $afterLines}}<span class="noselect"><u>{{$line.LineNum}}</u>:</span>
{{end}}</p></pre>
          </td>
          <td style="background-color: rgba(238, 238, 255, 0.6);">
<pre class="inline-pre"><p style="margin: 0px;">{{range $line := $beforeLines}} {{$line.Content}}
{{end}}</p> {{range .Fragments}}{{LimitPre 100 .Pre}}<b>{{.Match}}</b>{{LimitPost 100 (TrimTrailingNewline .Post)}}{{end}}<p style="margin: 0px;">{{range $line := $afterLines}} {{$line.Content}}
{{end}}</p>{{if .ScoreDebug}}<i>({{.ScoreDebug}})</i>{{end}}</pre>
          </td>
        </tr>
        {{end}}
      </tbody>
      {{end}}
      {{end}}
    </table>
    {{end}}

  <nav class="navbar navbar-default navbar-bottom">
    <div class="container">
      {{template "footerBoilerplate"}}
      <p class="navbar-text navbar-right">
      Took {{.Stats.Duration}}{{if .Stats.Wait}} (queued: {{.Stats.Wait}}){{end}} for
      {{HumanUnit .Stats.IndexBytesLoaded}}B index data,
      {{.Stats.NgramMatches}} ngram matches,
      {{.Stats.FilesConsidered}} docs considered,
      {{.Stats.FilesLoaded}} docs ({{HumanUnit .Stats.ContentBytesLoaded}}B) loaded,
      {{.Stats.ShardsScanned}} shards scanned,
      {{.Stats.ShardsSkippedFilter}} shards filtered
      {{- if or .Stats.FilesSkipped .Stats.ShardsSkipped -}}
        , {{.Stats.FilesSkipped}} docs skipped, {{.Stats.ShardsSkipped}} shards skipped
      {{- end -}}
	  .
      </p>
    </div>
  </nav>
  </div>
  {{ template "jsdep"}}
</body>
</html>
