
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="सञ्चयः (Sanchaya) - Sanskrit and Indic Text Search">
<meta name="author" content="">
<link rel="icon" href="data:image/gif;base64,R0lGODlhEAAQAKIAAP///8zMzJmZmWZmZjMzMwAAAAAAAAAAACH5BAEAAAUALAAAAAAQABAAAAMoGLrc/jAuQWuxsVoePnsRNoJgR00AznRDJZbBJ6LM1bmVat+OXucXAQA7">
<!-- Licensed under MIT (https://github.com/twbs/bootstrap/blob/master/LICENSE) -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<style>
  /* Base template styles */
  .zoekt-h1 {
    color: #FF0000;  /* Changed to bright red for testing */
    font-family: 'Arial Unicode MS', 'Marathi Harsh', serif;
    font-size: 32px; /* Made larger for testing */
  }
  
  /* Add Sanchaya branding styles */
  .sanchaya-brand {
    font-size: 28px; /* Made larger for testing */
    margin-right: 10px;
    color: #0000FF; /* Changed to blue for testing */
    font-weight: bold;
    font-family: 'Arial Unicode MS', 'Nirmala UI', serif;
  }
  
  #navsearchbox { width: 350px !important; }
  #maxhits { width: 100px !important; }
  #context { width: 70px !important; }
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
</style>
</head>
  