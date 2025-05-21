

<html>
  {{template "head"}}
  <title>About सञ्चयः (Sanchaya) Search</title>
<body>


  <div class="jumbotron" style="background-color: #f5f5f5;">
    <div class="container">
      <h1 class="zoekt-h1"><span class="sanchaya-brand">सञ्चयः</span> <span style="font-size: 24px;">Search</span></h1>
      {{template "searchbox" .Last}}
    </div>
  </div>

  <div class="container">
    <p>
      This is <span class="sanchaya-brand">सञ्चयः</span> (Sanchaya), a customized version of <a href="http://github.com/sourcegraph/zoekt"><em>zoekt</em> (IPA: /zukt/)</a>,
      an open-source full text search engine optimized for Sanskrit and Indic text search.
    </p>
    <p>
    {{if .Version}}<em>Zoekt</em> version {{.Version}}, uptime{{else}}Uptime{{end}} {{.Uptime}}
    </p>

    <p>
    Used {{HumanUnit .Stats.IndexBytes}} memory for
    {{.Stats.Documents}} documents ({{HumanUnit .Stats.ContentBytes}})
    from {{.Stats.Repos}} repositories.
    </p>
  </div>

  <nav class="navbar navbar-default navbar-bottom">
    <div class="container">
      {{template "footerBoilerplate"}}
      <p class="navbar-text navbar-right">
      </p>
    </div>
  </nav>
