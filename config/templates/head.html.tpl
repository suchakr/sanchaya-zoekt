
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="सञ्चयः (Sanchaya) - Sanskrit and Indic Text Search">
<meta name="author" content="">
<!-- Google tag (gtag.js) -->
<script>
  if (window.location.hostname === "sanchaya.rasowshi.us") {
    var gaScript = document.createElement('script');
    gaScript.async = true;
    gaScript.src = "https://www.googletagmanager.com/gtag/js?id=G-NCNTYPNR00";
    document.head.appendChild(gaScript);

    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-NCNTYPNR00');
  }
</script>
<link rel="icon" href="data:image/gif;base64,R0lGODlhEAAQAKIAAP///8zMzJmZmWZmZjMzMwAAAAAAAAAAACH5BAEAAAUALAAAAAAQABAAAAMoGLrc/jAuQWuxsVoePnsRNoJgR00AznRDJZbBJ6LM1bmVat+OXucXAQA7">
<!-- Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE) -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<style>
  /* Base template styles */
  .zoekt-h1 {
    color: #222;
    font-family: 'Arial Unicode MS', 'Marathi Harsh', serif;
    font-size: 24px;
  }
  
  /* Add Sanchaya branding styles */
  .sanchaya-brand {
    font-size: 22px;
    margin-right: 10px;
    color: #7b2626;
    font-weight: bold;
    font-family: 'Arial Unicode MS', 'Nirmala UI', serif;
  }
  
  #navsearchbox { font-size: 16px; height: 38px; width: 100% !important; }
  .navbar .sanchaya-basic-option { display: none; }
  #maxhits { width: 100px !important; }
  #context { width: 70px !important; }
  .sanchaya-utility-nav {
    align-items: center;
    display: flex;
    gap: 2px;
  }
  .sanchaya-utility-nav > li > a {
    color: #555;
    min-width: 34px;
    padding-left: 9px;
    padding-right: 9px;
    text-align: center;
  }
  .sanchaya-labs-icon {
    fill: none;
    height: 18px;
    stroke: currentColor;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-width: 1.8;
    vertical-align: -4px;
    width: 18px;
  }
  .sanchaya-home-shell {
    margin: 0 auto;
    max-width: 980px;
    padding: 18px 20px 24px;
  }
  .sanchaya-home-head {
    align-items: center;
    border-bottom: 1px solid #ddd;
    display: flex;
    justify-content: space-between;
    margin-bottom: 18px;
    padding-bottom: 9px;
  }
  .sanchaya-home-head .sanchaya-brand {
    text-decoration: none;
  }
  .sanchaya-home-head .sanchaya-utility-nav {
    list-style: none;
    margin: 0;
    padding: 0;
  }
  .sanchaya-home-head .sanchaya-utility-nav > li {
    display: block;
  }
  .sanchaya-home-head .sanchaya-utility-nav > li > a {
    display: block;
    line-height: 30px;
  }
  .sanchaya-home-stats {
    color: #777;
    font-size: 12px;
    margin-top: 10px;
  }
  .sanchaya-home-info {
    border-top: 1px solid #ddd;
    margin-top: 18px;
    padding-top: 10px;
  }
  .sanchaya-home-info > details > summary {
    color: #555;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    list-style-position: inside;
    outline: none;
  }
  .sanchaya-home-info > details > summary:focus-visible {
    outline: 2px solid #66afe9;
    outline-offset: 2px;
  }
  .sanchaya-home-info-body {
    display: grid;
    gap: 24px;
    grid-template-columns: minmax(0, 1.25fr) minmax(220px, .75fr);
    margin-top: 12px;
  }
  .sanchaya-home-info-body h2 {
    border-top: 1px solid #e4e4e4;
    font-size: 15px;
    margin: 0 0 8px;
    padding-top: 10px;
  }
  .sanchaya-home-info-body dl {
    display: grid;
    grid-template-columns: minmax(115px, 1fr) minmax(0, 1.4fr);
    margin: 0;
  }
  .sanchaya-home-info-body dt,
  .sanchaya-home-info-body dd {
    border-bottom: 1px solid #eee;
    margin: 0;
    padding: 5px 0;
  }
  .sanchaya-home-info-body dt { font-weight: 400; }
  .sanchaya-home-info-body dd { padding-left: 10px; }
  .sanchaya-home-info-body code {
    overflow-wrap: anywhere;
    word-break: break-word;
  }
  .label-dup {
    border-width: 1px !important;
    border-style: solid !important;
    border-color: #aaa !important;
    color: black;
  }
  .noselect {
    color: #999;    
    user-select: none;
  }
  a.label-dup:hover {
    color: black;
    background: #ddd;
  }
  .result {
    display: block;
    content: " ";
    visibility: hidden;
  }
  .container-results {
     overflow: auto;
     max-height: calc(100% - 72px);
  }
  .inline-pre {
     border: unset;
     background-color: unset;
     margin: unset;
     padding: unset;
     overflow: unset;
  }
  :target { background-color: #ccf; }
  table tbody tr td { border: none !important; padding: 2px !important; }
  @media (max-width: 760px) {
    #navsearchbox { width: 100% !important; }
    .navbar #navbar-collapse.navbar-collapse.collapse {
      border-top: 0;
      box-shadow: none;
      display: block !important;
      height: auto !important;
      overflow: visible !important;
    }
    #navbar-collapse .sanchaya-utility-nav {
      display: none;
    }
    #navbar-collapse.in .sanchaya-utility-nav {
      background: #fff;
      border: 1px solid #ddd;
      box-shadow: 0 3px 8px rgba(0,0,0,.1);
      display: flex;
      margin: 0;
      padding: 0 3px;
      position: absolute;
      right: 10px;
      top: 48px;
      z-index: 4100;
    }
    #navbar-collapse.in .sanchaya-utility-nav > li {
      float: none;
    }
    #navbar-collapse.in .sanchaya-utility-nav > li > a {
      padding: 8px 12px;
    }
    .sanchaya-home-shell {
      padding: 10px 12px 18px;
    }
    .sanchaya-home-info-body {
      grid-template-columns: 1fr;
      gap: 14px;
    }
    .sanchaya-home-info-body dl {
      grid-template-columns: minmax(100px, .8fr) minmax(0, 1.2fr);
    }
  }
  @media (min-width: 761px) {
    .navbar .navbar-collapse {
      position: relative;
    }
    .navbar .sanchaya-utility-nav {
      position: absolute;
      right: 0;
      top: 0;
      z-index: 2;
    }
  }
</style>
{{template "searchGuardAssets"}}
{{template "advancedSearchAssets"}}
</head>
  
