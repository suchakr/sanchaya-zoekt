<html>
{{template "head"}}
<title>सञ्चयः (Sanchaya) Search</title>
<body id="home">
  <main class="sanchaya-home-shell">
    <header class="sanchaya-home-head">
      <a class="sanchaya-brand" href="/" title="New search">सञ्चयः</a>
      <ul class="sanchaya-utility-nav" aria-label="Site links">
        <li><a href="/labs/" title="Labs" aria-label="Labs"><svg class="sanchaya-labs-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 2h6"></path><path d="M10 2v7.5L4 19a2 2 0 0 0 1.7 3h12.6A2 2 0 0 0 20 19l-6-9.5V2"></path><path d="M6.4 16h11.2"></path><path d="M8 18.5h.01"></path></svg><span class="sr-only">Labs</span></a></li>
      </ul>
    </header>

    {{template "searchbox" .Last}}

    <p class="sanchaya-home-stats">
      {{.Stats.Documents}} documents · {{.Stats.Repos}} repositories · {{HumanUnit .Stats.ContentBytes}}B searchable text
    </p>

    <section class="sanchaya-home-info" aria-label="Help and About">
      <details id="sanchaya-home-info-details">
        <summary><span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span> Help &amp; About</summary>
        <div class="sanchaya-home-info-body">
          <section id="sanchaya-home-help">
            <h2>Help</h2>
            <dl>
              <dt><a href="/search?q=तपःस्वाध्यायनिरतं">तपःस्वाध्यायनिरतं</a></dt>
              <dd>Find the term across all indexed texts.</dd>
              <dt><a href="/search?q=तिमिरा+file%3APur">तिमिरा file:Pur</a></dt>
              <dd>Restrict matches to paths containing <code>Pur</code>.</dd>
              <dt><a href="/search?q=needle+-hay">needle -hay</a></dt>
              <dd>Require <code>needle</code> and exclude <code>hay</code>.</dd>
              <dt><a href="/search?q=%22आदि+काव्य%22">&quot;आदि काव्य&quot;</a></dt>
              <dd>Find an exact phrase.</dd>
              <dt><code>file:Jyotisha|Puranani</code></dt>
              <dd>Include either path fragment.</dd>
            </dl>
            <h2>Query syntax</h2>
            <dl>
              <dt><code>term1 term2</code></dt>
              <dd>Require both terms.</dd>
              <dt><code>term1|term2</code></dt>
              <dd>Accept either term when regular-expression mode is active.</dd>
              <dt><code>-term</code></dt>
              <dd>Exclude matching text.</dd>
              <dt><code>case:yes</code></dt>
              <dd>Match letter case exactly.</dd>
            </dl>
            <h2>File and path scope</h2>
            <dl>
              <dt><code>file:Puranani</code></dt>
              <dd>Include paths containing <code>Puranani</code>.</dd>
              <dt><code>-file:gretil</code></dt>
              <dd>Exclude paths containing <code>gretil</code>.</dd>
            </dl>
          </section>
          <section id="sanchaya-home-about">
            <h2>About सञ्चयः</h2>
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
        </div>
      </details>
    </section>
  </main>

  <nav class="navbar navbar-default navbar-bottom">
    <div class="container">
      {{template "footerBoilerplate"}}
    </div>
  </nav>
  {{template "jsdep"}}
  <script>
    (function() {
      var section = new URLSearchParams(window.location.search).get("section");
      var details = document.getElementById("sanchaya-home-info-details");
      var target = document.getElementById("sanchaya-home-" + section);
      if (!details || !target || (section !== "help" && section !== "about")) return;
      details.open = true;
      window.requestAnimationFrame(function() { target.scrollIntoView({block: "start"}); });
    })();
  </script>
</body>
</html>
