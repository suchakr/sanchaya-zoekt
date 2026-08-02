<html>
{{template "head"}}
<title>About सञ्चयः (Sanchaya) Search</title>
<body id="about">
  <main class="sanchaya-home-shell">
    <header class="sanchaya-home-head">
      <a class="sanchaya-brand" href="/" title="New search">सञ्चयः</a>
      <ul class="sanchaya-utility-nav" aria-label="Site links">
        <li><a href="/help" title="Help" aria-label="Help"><span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span><span class="sr-only">Help</span></a></li>
        <li><a href="/labs/" title="Labs" aria-label="Labs"><svg class="sanchaya-labs-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 2h6"></path><path d="M10 2v7.5L4 19a2 2 0 0 0 1.7 3h12.6A2 2 0 0 0 20 19l-6-9.5V2"></path><path d="M6.4 16h11.2"></path><path d="M8 18.5h.01"></path></svg><span class="sr-only">Labs</span></a></li>
        <li><a href="/about" title="About" aria-label="About"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span><span class="sr-only">About</span></a></li>
      </ul>
    </header>
    {{template "searchbox" .Last}}

    <section>
      <h1 class="zoekt-h1">About सञ्चयः</h1>
      <p>
        सञ्चयः is a customized version of <a href="https://github.com/sourcegraph/zoekt"><em>Zoekt</em></a>,
        optimized for searching Sanskrit and Indic text collections.
      </p>
      <p>{{if .Version}}<em>Zoekt</em> version {{.Version}}, uptime{{else}}Uptime{{end}} {{.Uptime}}.</p>
      <p>
        {{.Stats.Documents}} documents, {{HumanUnit .Stats.ContentBytes}}B of searchable text,
        across {{.Stats.Repos}} repositories.
      </p>
    </section>
  </main>
  <nav class="navbar navbar-default navbar-bottom">
    <div class="container">{{template "footerBoilerplate"}}</div>
  </nav>
  {{template "jsdep"}}
</body>
</html>
