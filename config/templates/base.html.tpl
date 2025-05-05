<!--
  base.html: Common header and footer for all pages.
-->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- The above 3 meta tags *must* come first in the head -->
  <meta name="description" content="सञ्चयः (Sanchaya) Code Search">
  <meta name="author" content="">
  <link rel="icon" href="data:image/gif;base64,R0lGODlhEAAQAKIAAP///8zMzJmZmWZmZjMzMwAAAAAAAAAAACH5BAEAAAUALAAAAAAQABAAAAMoGLrc/jAuQWuxsVoePnsRNoJgR00AznRDJZbBJ6LM1bmVat+OXucXAQA7">

  <title>{{if .Last}}Search result - {{.Last}} {{end}}सञ्चयः (Sanchaya) Code Search</title>

  <!-- Bootstrap core CSS -->
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">

  <!-- Custom styles for this template -->
  <style>
    /* Base template styles */
    .zoekt-h1 {
      color: #990000;
      font-family: 'Arial Unicode MS', 'Marathi Harsh', serif;
    }
    
    /* Add Sanchaya branding styles */
    .sanchaya-brand {
      font-size: 24px;
      margin-right: 10px;
      color: #8B0000;
      font-weight: bold;
      font-family: 'Arial Unicode MS', 'Nirmala UI', serif;
    }
    
    body {
      padding-top: 70px;
    }
    .entry {
      padding: 5px;
      padding-bottom: 10px;
    }
    .table-nonfluid {
      width: auto !important;
    }
    .label-dup {
      color: #fcfcfc;
      background-color: #bbb;
    }

    .label-neg {
      color: #fcfcfc;
      background-color: #d28
    }

    .badge-neg {
      color: #fcfcfc;
      background-color: #d28;
    }

    .label-langtag {
      color: #fcfcfc;
      background-color: #5cb85c;
    }

    .linecontent span.match {
      background: rgba(255,255,0,.5);
      border-radius: 3px;
    }

    .linenos {
      font-family: monospace;
    }

    a.linenos:hover {
      text-decoration: none;
    }

    a.linenos.dim {
      opacity: 0.4;
    }

    a.linenos.selected {
      background-color: #5cb85c;
      color: white;
    }

    .stats-box {
      border-radius: 5px;
      padding: 5px;
      margin: 5px;
    }
    
    @media (min-width: 400px) {
      .file-result {
        display: flex;
      }
      .file-details {
        flex: auto;
      }
    }

    .file-repo {
      display: inline-block;
      margin: 5px;
      border-bottom: solid 1px #5AC0F3;
    }

    .content-line {
      font-family: 'Source Code Pro', courier, monospace;
      white-space: pre;
    }

    .file-content {
      margin-top: 5px;
      margin-bottom: 3px;
      margin-left: 30px;
    }

    div.file-name {
      font-weight: 900;
      margin: 0px;
      padding: 5px;
      display: inline-block;
      border: solid #5AC0F3;
      border-width: 1px 1px 0px 1px;
      border-radius: 2px;
    }

    .breadcrumb-color {
      color: black;
    }

    g.match {
      fill: #5cb85c;
    }

    g.match text {
      fill: white;
    }
  </style>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/github.min.css">
  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
      <![endif]-->

  {{ if .Version }}
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      var helpTxt = 'regex supported. prefix terms with "-" to exclude.\n' +
          'Supported predicates:\n' +
          '  repo:  repo name\n' +
          '  file:  file name\n' +
          '  lang:  language name\n' +
          '  -lang: exclude language\n' +
          '  sym:   symbol name\n' +
          'Example: "foo.*bar -file:test"';

      document.querySelectorAll('.tooltip-toggle').forEach(function(el) {
        el.setAttribute('title', helpTxt);
      });
    });
  </script>
  {{ end }}
</head>

<body>
  <!-- Fixed navbar -->
  <nav class="navbar navbar-default navbar-fixed-top">
    <div class="container">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/"><span class="sanchaya-brand">सञ्चयः</span> Code Search</a>
      </div>
      <div id="navbar" class="navbar-collapse collapse">
        <ul class="nav navbar-nav">
          {{ if .Version }}<li><a href="/">Search</a></li>{{ end }}
          {{ if .Version }}<li><a href="/about">About</a></li>{{ end }}
          {{ if .Debug }}<li><a href="/debug">Debug</a></li>{{ end }}
        </ul>
      </div>
    </div>
  </nav>

  <div class="container">
    {{template "body" .}}
  </div>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
</body>
</html>