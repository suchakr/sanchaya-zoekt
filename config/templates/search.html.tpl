
<html>
{{template "head"}}
<title>सञ्चयः (Sanchaya) Search</title>
<body>
  <div class="jumbotron" style="background-color: #f5f5f5;">
    <div class="container">
      <h1 class="zoekt-h1"><span class="sanchaya-brand">सञ्चयः</span> <span style="font-size: 24px;">Search</span></h1>
      {{template "searchbox" .Last}}
    </div>
  </div>

  <div class="container">
    <div class="row">
      <div class="col-md-8">
        <h3>Search examples:</h3>
        <dl class="dl-horizontal">
          <dt><a href="search?q=%22%E0%A4%A4%E0%A4%BF%E0%A4%AE%E0%A4%BF%E0%A4%B0%E0%A4%BE+%E0%A4%AA%E0%A4%B9%E0%A4%83%22">"तिमिरा पहः"</a></dt><dd>search for the exact phrase "तिमिरा पहः"</dd>
          <dt><a href="search?q=%E0%AE%85%E0%AE%AE%E0%AF%8D+%E0%AE%95%E0%AE%AF%E0%AE%B2%E0%AF%8D+%E0%AE%AA%E0%AE%BE%E0%AE%AF%E0%AF%8D">அம் கயல் பாய்</a></dt><dd>search for texts containing "அம் கயல் பாய்" (Tamil text)</dd>
          <dt><a href="search?q=%E0%A4%B8%E0%A4%B0%E0%A5%8D%E0%A4%B5%E0%A5%87%E0%A4%B6%E0%A5%8D%E0%A4%B5%E0%A4%B0+%E0%A4%A8%E0%A4%BF%E0%A4%AF%E0%A5%81%E0%A4%A3%E0%A4%AE%E0%A5%8D">सर्वेश्वर नियुणम्</a></dt><dd>search for texts containing both "सर्वेश्वर" and "नियुणम्"</dd>
          <dt><a href="search?q=%E0%A4%A4%E0%A4%AA%E0%A4%83%E0%A4%B8%E0%A5%8D%E0%A4%A5%E0%A4%BE">तपःस्था</a></dt><dd>search for "तपःस्था" or similar words</dd>
          <dt><a href="search?q=%E0%A4%A4%E0%A4%BF%E0%A4%AE%E0%A4%BF%E0%A4%B0%E0%A4%BE+file%3APur">तिमिरा file:Pur</a></dt><dd>search for "तिमिरा" in files containing "Pur" in their path</dd>
        </dl>
        
        <div class="panel panel-default">
          <div class="panel-heading">
            <h4 class="panel-title">
              <a data-toggle="collapse" href="#advancedExamples">Show Advanced Search Options</a>
            </h4>
          </div>
          <div id="advancedExamples" class="panel-collapse collapse">
            <div class="panel-body">
              <h4>Advanced search examples:</h4>
              <dl class="dl-horizontal">
                <dt><a href="search?q=needle">needle</a></dt><dd>search for "needle"</dd>
                <dt><a href="search?q=thread+or+needle">thread or needle</a></dt><dd>search for either "thread" or "needle"</dd>
                <dt><a href="search?q=class+needle">class needle</a></span></dt><dd>search for files containing both "class" and "needle"</dd>
                <dt><a href="search?q=class+Needle">class Needle</a></dt><dd>search for files containing both "class" (case insensitive) and "Needle" (case sensitive)</dd>
                <dt><a href="search?q=class+Needle+case:yes">class Needle case:yes</a></dt><dd>search for files containing "class" and "Needle", both case sensitively</dd>
                <dt><a href="search?q=%22class Needle%22">"class Needle"</a></dt><dd>search for files with the phrase "class Needle"</dd>
                <dt><a href="search?q=needle+-hay">needle -hay</a></dt><dd>search for files with the word "needle" but not the word "hay"</dd>
                <dt><a href="search?q=path+file:java">path file:java</a></dt><dd>search for the word "path" in files whose name contains "java"</dd>
                <dt><a href="search?q=needle+lang%3Apython&num=50">needle lang:python</a></dt><dd>search for "needle" in Python source code</dd>
                <dt><a href="search?q=f:%5C.c%24">f:\.c$</a></dt><dd>search for files whose name ends with ".c"</dd>
                <dt><a href="search?q=path+-file:java">path -file:java</a></dt><dd>search for the word "path" excluding files whose name contains "java"</dd>
                <dt><a href="search?q=foo.*bar">foo.*bar</a></dt><dd>search for the regular expression "foo.*bar"</dd>
                <dt><a href="search?q=-%28Path File%29 Stream">-(Path File) Stream</a></dt><dd>search "Stream", but exclude files containing both "Path" and "File"</dd>
                <dt><a href="search?q=-Path%5c+file+Stream">-Path\ file Stream</a></dt><dd>search "Stream", but exclude files containing "Path File"</dd>
                <dt><a href="search?q=sym:data">sym:data</a></span></dt><dd>search for symbol definitions containing "data"</dd>
                <dt><a href="search?q=phone+r:droid">phone r:droid</a></dt><dd>search for "phone" in repositories whose name contains "droid"</dd>
              </dl>

              <h4>To list repositories, try:</h4>
              <dl class="dl-horizontal">
                <dt><a href="search?q=r:droid">r:droid</a></dt><dd>list repositories whose name contains "droid".</dd>
                <dt><a href="search?q=r:go+-r:google">r:go -r:google</a></dt><dd>list repositories whose name contains "go" but not "google".</dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="panel panel-primary">
          <div class="panel-heading">
            <h3 class="panel-title">Quick Tips</h3>
          </div>
          <div class="panel-body">
            <ul>
              <li>Search for exact phrases using quotes: <code>"आदि काव्य"</code></li>
              <li>Use <code>file:</code> to search within specific sections, like <code>file:Puranani</code></li>
              <li>Multi-language support: Sanskrit, Tamil, Prakrit, and English texts are all searchable</li>
              <li>Sanskrit terms are fully searchable with diacritics</li>
              <li>Click "Show Advanced Search Options" for more ways to search</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
  <nav class="navbar navbar-default navbar-bottom">
    <div class="container">
      {{template "footerBoilerplate"}}
      <p class="navbar-text navbar-right">
        Used {{HumanUnit .Stats.IndexBytes}} mem for
        {{.Stats.Documents}} documents ({{HumanUnit .Stats.ContentBytes}})
        from {{.Stats.Repos}} repositories.
      </p>
    </div>
  </nav>

  <!-- jQuery (necessary for Bootstrap's JavaScript components) -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
  <!-- Include all compiled plugins (below), or include individual files as needed -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
</body>
</html>
