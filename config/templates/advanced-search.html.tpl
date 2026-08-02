{{define "advancedSearchAssets"}}
<style>
  .sanchaya-advanced-toggle.active {
    background: #e6e6e6;
    border-color: #adadad;
    color: #245580;
  }
  .sanchaya-search-row {
    align-items: stretch;
    display: flex;
    width: 100%;
  }
  .sanchaya-search-field {
    flex: 1 1 auto;
    min-width: 0;
    position: relative;
  }
  .sanchaya-search-field > .form-control {
    padding-right: 48px;
    width: 100%;
  }
  .sanchaya-search-field .sanchaya-advanced-toggle {
    align-items: center;
    border: 0;
    border-left: 1px solid #ddd;
    border-radius: 0;
    bottom: 1px;
    display: flex;
    justify-content: center;
    padding: 0;
    position: absolute;
    right: 1px;
    top: 1px;
    width: 42px;
    z-index: 2;
  }
  .sanchaya-search-submit {
    flex: 0 0 auto;
    margin-left: 6px;
  }
  .navbar .sanchaya-search-row {
    align-items: center;
  }
  .navbar .sanchaya-search-field {
    width: 480px;
  }
  .navbar .sanchaya-search-submit {
    height: 34px;
  }
  .sanchaya-search-mode.advanced-open .sanchaya-basic-option {
    display: none;
  }
  .navbar .sanchaya-search-mode {
    float: none !important;
    width: 100%;
  }
  .navbar .sanchaya-advanced-panel {
    clear: both;
    padding: 8px 15px 4px;
    width: 100%;
  }
  .sanchaya-advanced-panel {
    border-top: 1px solid #ddd;
    display: none;
    margin-top: 8px;
    opacity: 0;
    padding-top: 8px;
    transition: opacity 140ms ease;
  }
  .sanchaya-advanced-panel.active {
    display: block;
    opacity: 1;
  }
  .sanchaya-advanced-grid {
    display: grid;
    gap: 12px;
    grid-template-columns: minmax(0, 1fr) 230px;
  }
  .sanchaya-advanced-main {
    min-width: 0;
  }
  .sanchaya-adv-toolbar {
    align-items: center;
    display: flex;
    flex-wrap: wrap;
    gap: 7px 9px;
    margin: 5px 0;
  }
  .sanchaya-adv-without-control {
    align-items: center;
    display: flex;
    flex: 1 1 240px;
    gap: 7px;
    max-width: 260px;
    min-width: 200px;
  }
  .sanchaya-adv-without-control label {
    font-weight: 500;
    margin-bottom: 0;
    white-space: nowrap;
  }
  .sanchaya-adv-without-control input {
    min-width: 0;
    width: 100%;
  }
  .sanchaya-adv-options {
    display: contents;
  }
  .sanchaya-adv-options label {
    align-items: center;
    display: inline-flex;
    gap: 4px;
    font-weight: 400;
    font-size: 13px;
    margin-bottom: 0;
    white-space: nowrap;
  }
  .sanchaya-adv-options input[type="checkbox"] {
    margin: 0;
  }
  .sanchaya-mini-field {
    align-items: center;
    display: inline-flex;
    gap: 5px;
  }
  .sanchaya-mini-field input {
    height: 28px;
    padding: 3px 5px;
    width: 48px;
  }
  .sanchaya-path-rail {
    box-sizing: border-box;
    border-left: 1px solid #ddd;
    padding-left: 10px;
    width: auto;
  }
  .sanchaya-path-head {
    align-items: center;
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
  }
  .sanchaya-path-head h4 {
    font-size: 13px;
    font-weight: 600;
    margin: 0;
  }
  .sanchaya-link-button {
    background: transparent;
    border: 0;
    color: #337ab7;
    cursor: pointer;
    font: inherit;
    padding: 0;
  }
  .sanchaya-filter-list {
    display: grid;
    gap: 3px;
  }
  .sanchaya-filter {
    align-items: center;
    background: #fff;
    border: 1px solid transparent;
    border-left: 3px solid transparent;
    border-radius: 2px;
    cursor: pointer;
    display: grid;
    grid-template-columns: 18px minmax(0, 1fr);
    gap: 4px;
    padding: 3px 5px 3px 3px;
    text-align: left;
  }
  .sanchaya-filter:hover {
    background: #f7f7f7;
    border-color: #e0e0e0;
  }
  .sanchaya-filter .mark {
    color: #999;
    font-family: Menlo, Consolas, monospace;
    text-align: center;
  }
  .sanchaya-filter.include {
    background: #eef7f1;
    border-left-color: #2f6f54;
  }
  .sanchaya-filter.include .mark {
    color: #2f6f54;
  }
  .sanchaya-filter.exclude {
    background: #fbefee;
    border-left-color: #8a342e;
  }
  .sanchaya-filter.exclude .mark {
    color: #8a342e;
  }
  .sanchaya-adv-error {
    color: #8a342e;
    margin-top: 3px;
  }
  .sanchaya-generated-row {
    align-items: center;
    display: grid;
    grid-template-columns: 112px minmax(0, 1fr);
    gap: 7px;
    min-width: 0;
    margin-top: 8px;
  }
  .sanchaya-generated-row label {
    font-size: 12px;
    font-weight: 500;
    margin: 0;
  }
  .sanchaya-generated-value {
    align-items: center;
    display: flex;
    gap: 6px;
    min-width: 0;
  }
  .sanchaya-generated-query {
    background: #f7f7f7;
    border: 1px solid #e2e2e2;
    border-radius: 2px;
    color: #444;
    display: block;
    flex: 1 1 auto;
    font-size: 12px;
    min-width: 0;
    overflow-x: auto;
    padding: 4px 6px;
    white-space: nowrap;
  }
  .sanchaya-generated-copy {
    flex: 0 0 auto;
  }
  .sanchaya-recall-wrap {
    position: relative;
    z-index: 1;
  }
  .sanchaya-recall-wrap:focus-within {
    z-index: 4000;
  }
  .sanchaya-recall-menu {
    background: #fff;
    border: 1px solid #cfcfcf;
    box-shadow: 0 3px 8px rgba(0,0,0,.08);
    display: none;
    left: 0;
    max-height: 210px;
    overflow: auto;
    position: fixed;
    top: 0;
    z-index: 4001;
  }
  .sanchaya-recall-menu.open {
    display: block;
  }
  .sanchaya-recall-item {
    background: #fff;
    border: 0;
    border-bottom: 1px solid #eee;
    cursor: pointer;
    display: block;
    font: inherit;
    padding: 5px 7px;
    text-align: left;
    width: 100%;
  }
  .sanchaya-recall-row {
    align-items: stretch;
    border-bottom: 1px solid #eee;
    display: grid;
    grid-template-columns: minmax(0, 1fr) 30px;
  }
  .sanchaya-recall-row .sanchaya-recall-item {
    border-bottom: 0;
  }
  .sanchaya-recall-delete {
    background: #fff;
    border: 0;
    color: #888;
    padding: 0;
  }
  .sanchaya-recall-delete:hover,
  .sanchaya-recall-delete:focus {
    background: #f6f6f6;
    color: #8a342e;
  }
  .sanchaya-recall-item:hover {
    background: #f6f6f6;
  }
  .sanchaya-recall-item.active {
    background: #e8f1f8;
  }
  .sanchaya-recall-item .find-main {
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .sanchaya-recall-item .find-meta {
    color: #666;
    display: block;
    font-size: 12px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .sanchaya-page-links {
    display: flex;
    gap: 6px;
    margin: 0 0 8px;
  }
  .sanchaya-scope-toggle,
  .sanchaya-scope-close,
  .sanchaya-scope-backdrop,
  .sanchaya-mobile-advanced-head,
  .sanchaya-mobile-advanced-summary {
    display: none;
  }
  body#results > nav.navbar:first-of-type {
    margin-bottom: 0;
  }
  @media (min-width: 761px) {
    body#results .sanchaya-advanced-grid {
      grid-template-columns: minmax(0, 1fr);
    }
    body#results .sanchaya-path-rail {
      background: #fff;
      border-left: 1px solid #ddd;
      bottom: 0;
      overflow-y: auto;
      padding: 9px 10px;
      position: fixed;
      right: 0;
      width: 220px;
      z-index: 1020;
    }
    body#results.sanchaya-advanced-active .container-results {
      margin-right: 220px;
    }
  }
  @media (max-width: 760px) {
    .sanchaya-advanced-grid {
      display: flex;
      flex-direction: column;
      gap: 0;
    }
    .sanchaya-advanced-main {
      display: contents;
    }
    .sanchaya-adv-toolbar {
      gap: 6px 8px;
      margin: 5px 0 0;
      order: 1;
    }
    .sanchaya-adv-without-control {
      flex-basis: 100%;
      max-width: none;
      min-width: 0;
    }
    .sanchaya-adv-error {
      order: 1;
    }
    .sanchaya-path-rail {
      border-left: 0;
      border-top: 1px solid #ddd;
      margin-top: 9px;
      order: 2;
      padding: 9px 0 0;
      position: static;
      transform: none;
      width: auto;
    }
    .sanchaya-path-head h4 {
      font-size: 12px;
    }
    .sanchaya-scope-close,
    .sanchaya-scope-toggle,
    .sanchaya-scope-backdrop {
      display: none !important;
    }
    .sanchaya-generated-row {
      align-items: stretch;
      grid-template-columns: 1fr;
      gap: 3px;
      order: 3;
    }
    .navbar .sanchaya-search-field { width: calc(100vw - 132px); }
    .navbar .sanchaya-advanced-panel {
      padding-bottom: 2px;
    }
    body#results .sanchaya-advanced-panel.active {
      background: #fff;
      bottom: 0;
      box-shadow: -4px 0 14px rgba(0,0,0,.18);
      display: block;
      margin: 0;
      max-width: 360px;
      opacity: 1;
      overflow-y: auto;
      padding: 10px 14px 18px;
      position: fixed;
      right: 0;
      top: 0;
      transform: translateX(105%);
      transition: transform 160ms ease;
      width: 92vw;
      z-index: 3001;
    }
    body#results .sanchaya-advanced-panel.active.mobile-editor-open {
      transform: translateX(0);
    }
    body#results .sanchaya-search-mode.advanced-open .sanchaya-mobile-advanced-summary {
      align-items: center;
      border-top: 1px solid #ddd;
      display: flex;
      font-size: 12px;
      gap: 7px;
      justify-content: space-between;
      margin: 4px 15px 0;
      padding: 5px 0 1px;
      background: transparent;
      border-left: 0;
      border-right: 0;
      border-bottom: 0;
      width: calc(100% - 30px);
    }
    .sanchaya-mobile-advanced-head {
      align-items: center;
      display: flex;
      justify-content: space-between;
      margin-bottom: 7px;
    }
    .sanchaya-mobile-advanced-head strong {
      font-size: 13px;
    }
  }
</style>
<script>
(function() {
  var filterDefs = [
    ["Puranani", "Puranani"], ["Jyotisham", "Jyotisha"],
    ["Itihaasa", "Itihaasa"], ["Ramayanam", "Ramayanam"],
    ["Mahabharatam", "Mahabharatam"], ["Vedic texts", "Vedic"],
    ["Kavya", "Kavya"], ["Kosha", "Kosha"],
    ["Vyakarana", "Vyakaranam"], ["Nyaya", "Nyaya"],
    ["Bauddha", "Bauddha"], ["Medicine", "Medicine"],
    ["gretil", "gretil"], ["nalayiram", "nalayiram"]
  ];
  var stateOrder = ["neutral", "include", "exclude"];
  var simpleHistoryKey = "sanchaya-simple-search-history-v1";
  var advancedHistoryKey = "sanchaya-query-builder-history-v1";
  var unifiedHistoryKey = "sanchaya-search-history-v2";
  var advancedDraftKey = "sanchaya-query-builder-draft-v1";
  var advancedOpenKey = "sanchaya-query-builder-open-v1";
  var optionHistoryKey = "sanchaya-query-builder-option-history-v1";
  var withoutHistoryKey = "sanchaya-without-history-v1";
  var historyMigrationKey = "sanchaya-query-builder-history-migrated-v1";
  var legacyAdvancedHistoryKey = "sanchaya-advanced-search-history-v1";
  var legacyLabHistoryKey = "sanchaya-lab-query-history-v1";

  var vowels = {"अ":["a","a"],"आ":["ā","A"],"इ":["i","i"],"ई":["ī","I"],"उ":["u","u"],"ऊ":["ū","U"],"ऋ":["ṛ","R"],"ॠ":["ṝ","RR"],"ऌ":["ḷ","lR"],"ए":["e","e"],"ऐ":["ai","ai"],"ओ":["o","o"],"औ":["au","au"]};
  var matras = {"ा":["ā","A"],"ि":["i","i"],"ी":["ī","I"],"ु":["u","u"],"ू":["ū","U"],"ृ":["ṛ","R"],"ॄ":["ṝ","RR"],"ॢ":["ḷ","lR"],"े":["e","e"],"ै":["ai","ai"],"ो":["o","o"],"ौ":["au","au"]};
  var consonants = {"क":["k","k"],"ख":["kh","kh"],"ग":["g","g"],"घ":["gh","gh"],"ङ":["ṅ","G"],"च":["c","c"],"छ":["ch","ch"],"ज":["j","j"],"झ":["jh","jh"],"ञ":["ñ","J"],"ट":["ṭ","T"],"ठ":["ṭh","Th"],"ड":["ḍ","D"],"ढ":["ḍh","Dh"],"ण":["ṇ","N"],"त":["t","t"],"थ":["th","th"],"द":["d","d"],"ध":["dh","dh"],"न":["n","n"],"प":["p","p"],"फ":["ph","ph"],"ब":["b","b"],"भ":["bh","bh"],"म":["m","m"],"य":["y","y"],"र":["r","r"],"ल":["l","l"],"व":["v","v"],"श":["ś","z"],"ष":["ṣ","S"],"स":["s","s"],"ह":["h","h"],"ळ":["ḻ","L"]};
  var signs = {"ं":["ṃ","M"],"ः":["ḥ","H"],"ँ":["m̐","M"],"ऽ":["'","'"]};

  function loadJson(key, fallback) {
    try { return JSON.parse(localStorage.getItem(key) || JSON.stringify(fallback)); }
    catch (e) { return fallback; }
  }
  function saveJson(key, value) { localStorage.setItem(key, JSON.stringify(value)); }
  function loadUnifiedHistory() {
    var current = loadJson(unifiedHistoryKey, []);
    if (current.length) return current;
    var byQuery = {};
    loadJson(advancedHistoryKey, []).concat(loadJson(legacyAdvancedHistoryKey, []), loadJson(legacyLabHistoryKey, [])).forEach(function(state) {
      var query = state && (state.query || state.find);
      if (!query) return;
      byQuery[query] = {query: query, state: state, timestamp: state.timestamp || 0};
    });
    loadJson(simpleHistoryKey, []).forEach(function(item) {
      item = typeof item === "string" ? {query: item, timestamp: 0} : item;
      if (!item || !item.query) return;
      if (!byQuery[item.query]) byQuery[item.query] = {query: item.query, timestamp: item.timestamp || 0};
      else byQuery[item.query].timestamp = Math.max(byQuery[item.query].timestamp || 0, item.timestamp || 0);
    });
    current = Object.keys(byQuery).map(function(query) { return byQuery[query]; }).sort(function(a, b) {
      return (b.timestamp || 0) - (a.timestamp || 0);
    }).slice(0, 20);
    if (current.length) saveJson(unifiedHistoryKey, current);
    saveJson(historyMigrationKey, true);
    return current;
  }
  function loadBuilderHistory() {
    return loadUnifiedHistory().filter(function(entry) { return entry.state; }).map(function(entry) { return entry.state; });
  }
  function saveHistory(query, state) {
    if (!query) return;
    var existing = loadUnifiedHistory().filter(function(item) { return item.query === query; })[0];
    var entry = {query: query, timestamp: Date.now()};
    if (!state && existing && existing.state) state = existing.state;
    if (state) {
      state.query = query;
      state.timestamp = entry.timestamp;
      entry.state = state;
    }
    var history = loadUnifiedHistory().filter(function(item) { return item.query !== query; });
    history.unshift(entry);
    saveJson(unifiedHistoryKey, history.slice(0, 20));
  }
  function removeHistory(query) {
    saveJson(unifiedHistoryKey, loadUnifiedHistory().filter(function(item) { return item.query !== query; }));
    saveJson(simpleHistoryKey, loadJson(simpleHistoryKey, []).filter(function(item) {
      return (typeof item === "string" ? item : item.query) !== query;
    }));
    saveJson(advancedHistoryKey, loadJson(advancedHistoryKey, []).filter(function(item) { return item.query !== query; }));
  }
  function words(value) { return value.trim().split(/\s+/).filter(Boolean); }
  function hasDevanagari(value) { return /[\u0900-\u097f]/.test(value); }
  function escapeRegex(value) { return value.replace(/[\\^$.*+?()[\]{}|]/g, "\\$&"); }
  function filePattern(value) { return value.replace(/\\/g, "\\\\").replace(/\|/g, "\\|"); }
  function phraseToken(value) { return '"' + value.trim().replace(/\\/g, "\\\\").replace(/"/g, '\\"') + '"'; }
  function visibleUnitCount(text) {
    if (window.Intl && Intl.Segmenter) {
      var segmenter = new Intl.Segmenter(undefined, {granularity: "grapheme"});
      var count = 0;
      var segments = segmenter.segment(text);
      for (var iterator = segments[Symbol.iterator](), step; !(step = iterator.next()).done;) count++;
      return count;
    }
    return Array.from(text).length;
  }
  function transliterate(value, schemeIndex) {
    var out = "";
    var pendingA = false;
    Array.from(value).forEach(function(ch) {
      if (consonants[ch]) {
        if (pendingA) out += "a";
        out += consonants[ch][schemeIndex];
        pendingA = true;
      } else if (matras[ch]) {
        out += matras[ch][schemeIndex];
        pendingA = false;
      } else if (ch === "्") {
        pendingA = false;
      } else if (vowels[ch]) {
        if (pendingA) out += "a";
        out += vowels[ch][schemeIndex];
        pendingA = false;
      } else if (signs[ch]) {
        if (pendingA) out += "a";
        out += signs[ch][schemeIndex];
        pendingA = false;
      } else {
        if (pendingA) out += "a";
        out += ch;
        pendingA = false;
      }
    });
    if (pendingA) out += "a";
    return out;
  }
  function romanToDevanagari(value) {
    var consonantMap = {
      "kh":"ख","gh":"घ","ch":"छ","jh":"झ","ṭh":"ठ","Th":"ठ","ḍh":"ढ","Dh":"ढ",
      "th":"थ","dh":"ध","ph":"फ","bh":"भ","k":"क","g":"ग","ṅ":"ङ","G":"ङ",
      "c":"च","j":"ज","ñ":"ञ","J":"ञ","ṭ":"ट","T":"ट","ḍ":"ड","D":"ड",
      "ṇ":"ण","N":"ण","t":"त","d":"द","n":"न","p":"प","b":"ब","m":"म",
      "y":"य","r":"र","l":"ल","v":"व","ś":"श","z":"श","ṣ":"ष","S":"ष",
      "s":"स","h":"ह","ḻ":"ळ","L":"ळ"
    };
    var vowelMap = {
      "ai":["ऐ","ै"],"au":["औ","ौ"],"ā":["आ","ा"],"A":["आ","ा"],"ī":["ई","ी"],
      "I":["ई","ी"],"ū":["ऊ","ू"],"U":["ऊ","ू"],"ṛ":["ऋ","ृ"],"R":["ऋ","ृ"],
      "ṝ":["ॠ","ॄ"],"RR":["ॠ","ॄ"],"ḷ":["ऌ","ॢ"],"lR":["ऌ","ॢ"],"a":["अ",""],
      "i":["इ","ि"],"u":["उ","ु"],"e":["ए","े"],"o":["ओ","ो"]
    };
    var signMap = {"ṃ":"ं","M":"ं","ḥ":"ः","H":"ः"};
    var tokens = Object.keys(Object.assign({}, consonantMap, vowelMap, signMap)).sort(function(a, b) { return b.length - a.length; });
    function match(map, start) {
      for (var m = 0; m < tokens.length; m++) {
        if (map[tokens[m]] && value.slice(start, start + tokens[m].length) === tokens[m]) return tokens[m];
      }
      return "";
    }
    var out = "";
    var i = 0;
    while (i < value.length) {
      var token = match(Object.assign({}, consonantMap, vowelMap, signMap), i);
      if (!token) return "";
      if (consonantMap[token]) {
        out += consonantMap[token];
        i += token.length;
        var vowel = match(vowelMap, i);
        if (vowel) {
          out += vowelMap[vowel][1];
          i += vowel.length;
        } else if (match(consonantMap, i)) {
          out += "्";
        }
      } else if (vowelMap[token]) {
        out += vowelMap[token][0];
        i += token.length;
      } else if (signMap[token]) {
        out += signMap[token];
        i += token.length;
      }
    }
    return out;
  }
  function unique(values) {
    var seen = {};
    return values.filter(function(value) {
      if (!value || seen[value]) return false;
      seen[value] = true;
      return true;
    });
  }
  function variants(value, iast) {
    value = value.trim();
    if (!value) return [];
    if (!iast) return [value];
    if (!hasDevanagari(value)) {
      return unique([value, romanToDevanagari(value)]);
    }
    var ia = transliterate(value, 0);
    var hk = transliterate(value, 1);
    return unique([value, ia, ia.replace(/a$/, ""), hk, hk.replace(/a$/, "")]);
  }
  function atom(value, iast) {
    var vs = variants(value, iast);
    if (!vs.length) return "";
    if (vs.length === 1) return vs[0];
    return "(" + vs.map(escapeRegex).join("|") + ")";
  }
  function validQuery(query) {
    var stripped = query.replace(/-?file:"[^"]*"/g, "").replace(/-?file:\S+/g, "").replace(/case:yes/g, "").trim();
    if (!stripped) return true;
    return stripped.split(/\s+/).every(function(token) {
      token = token.replace(/^-+/, "").replace(/[()]/g, "").replace(/^"|"$/g, "");
      return !token || token.split("|").every(function(option) { return visibleUnitCount(option) >= 2; });
    });
  }
  function seed(values, defaults) {
    values = values || [];
    defaults.forEach(function(value) { if (values.indexOf(value) === -1) values.push(value); });
    return values;
  }
  function renderDatalist(root) {
    var history = loadJson(optionHistoryKey, {});
    var nums = seed(history.num, ["25", "50", "100"]);
    var ctxs = seed(history.ctx, ["1", "5", "10"]);
    root.querySelectorAll(".sanchaya-num-history").forEach(function(list) {
      list.innerHTML = nums.map(function(v) { return '<option value="' + v + '">'; }).join("");
    });
    root.querySelectorAll(".sanchaya-ctx-history").forEach(function(list) {
      list.innerHTML = ctxs.map(function(v) { return '<option value="' + v + '">'; }).join("");
    });
  }
  function saveOptionHistory(state) {
    var history = loadJson(optionHistoryKey, {});
    history.num = seed(history.num, ["25", "50", "100"]);
    history.ctx = seed(history.ctx, ["1", "5", "10"]);
    if (state.num && history.num.indexOf(state.num) === -1) history.num.unshift(state.num);
    if (state.ctx && history.ctx.indexOf(state.ctx) === -1) history.ctx.unshift(state.ctx);
    history.num = history.num.slice(0, 8);
    history.ctx = history.ctx.slice(0, 8);
    saveJson(optionHistoryKey, history);
  }
  function loadSimpleHistory() {
    return loadUnifiedHistory().map(function(item) {
      return {query: item.query, timestamp: item.timestamp || 0};
    });
  }
  function saveSimple(query) {
    saveHistory(query);
  }
  function normalizeWithoutHistory(items) {
    return (items || []).map(function(item) {
      return typeof item === "string" ? {value: item, timestamp: 0} : item;
    }).filter(function(item) {
      return item && item.value && item.value.trim();
    }).map(function(item) {
      return {value: item.value.trim(), timestamp: item.timestamp || 0};
    });
  }
  function loadWithoutHistory() {
    var history = normalizeWithoutHistory(loadJson(withoutHistoryKey, []));
    if (!history.length) {
      history = unique(loadBuilderHistory().map(function(state) { return state.without; }).filter(Boolean)).map(function(value) {
        return {value: value.trim(), timestamp: 0};
      });
      if (history.length) saveJson(withoutHistoryKey, history.slice(0, 20));
    }
    var seen = {};
    return history.filter(function(item) {
      if (seen[item.value]) return false;
      seen[item.value] = true;
      return true;
    }).sort(function(a, b) { return b.timestamp - a.timestamp; }).slice(0, 20);
  }
  function saveWithoutHistory(value) {
    value = (value || "").trim();
    if (!value) return;
    var history = loadWithoutHistory().filter(function(item) { return item.value !== value; });
    history.unshift({value: value, timestamp: Date.now()});
    saveJson(withoutHistoryKey, history.slice(0, 20));
  }
  function removeWithoutHistory(value) {
    saveJson(withoutHistoryKey, loadWithoutHistory().filter(function(item) { return item.value !== value; }));
  }
  function withoutHistoryEntries(filterText) {
    var needle = (filterText || "").toLocaleLowerCase();
    return loadWithoutHistory().filter(function(item) {
      return !needle || item.value.toLocaleLowerCase().indexOf(needle) !== -1;
    }).map(function(item) {
      return {kind: "without", label: item.value, meta: "", value: item.value, timestamp: item.timestamp};
    }).slice(0, 10);
  }
  function stateMeta(state) {
    var bits = [];
    if (state.without) bits.push("without " + state.without.trim());
    Object.keys(state.filters || {}).forEach(function(label) {
      bits.push((state.filters[label] === "include" ? "+" : "-") + label);
    });
    return bits.join(" ");
  }
  function unifiedHistory(filterText) {
    var entries = loadUnifiedHistory().map(function(item) {
      var state = item.state;
      return {
        kind: state ? "builder" : "query",
        label: state ? (state.find || item.query) : item.query,
        meta: state ? [stateMeta(state), state.find && state.find !== item.query ? "q: " + item.query : ""].filter(Boolean).join(" · ") : "",
        query: item.query,
        state: state,
        timestamp: item.timestamp || 0
      };
    });
    var needle = (filterText || "").toLocaleLowerCase();
    var seen = {};
    return entries.sort(function(a, b) { return b.timestamp - a.timestamp; }).filter(function(entry) {
      var key = entry.query || (entry.kind + ":" + entry.label + ":" + entry.meta);
      if (seen[key]) return false;
      seen[key] = true;
      return !needle || (entry.label + " " + entry.meta).toLocaleLowerCase().indexOf(needle) !== -1;
    }).slice(0, 10);
  }
  function initRecallInput(input, options) {
    if (input.dataset.sanchayaRecallReady) return;
    input.dataset.sanchayaRecallReady = "1";
    var menu = document.createElement("div");
    menu.className = "sanchaya-recall-menu";
    document.body.appendChild(menu);
    var entries = [];
    var activeIndex = -1;
    function close() {
      activeIndex = -1;
      menu.classList.remove("open");
    }
    input.sanchayaRecallClose = close;
    function positionMenu() {
      var rect = input.getBoundingClientRect();
      menu.style.left = Math.max(4, rect.left) + "px";
      menu.style.top = (rect.bottom + 2) + "px";
      menu.style.width = Math.max(220, Math.min(rect.width, window.innerWidth - Math.max(4, rect.left) - 4)) + "px";
    }
    function choose(entry) {
      options.choose(entry);
      close();
    }
    function setActive(index) {
      var buttons = menu.querySelectorAll(".sanchaya-recall-item");
      if (!buttons.length) return;
      if (activeIndex < 0) {
        activeIndex = index >= 0 ? 0 : buttons.length - 1;
      } else {
        activeIndex = (index + buttons.length) % buttons.length;
      }
      buttons.forEach(function(button, i) {
        button.classList.toggle("active", i === activeIndex);
        button.setAttribute("aria-selected", i === activeIndex ? "true" : "false");
      });
    }
    function render(filterText) {
      entries = options.entries(filterText) || [];
      activeIndex = -1;
      menu.innerHTML = "";
      if (!entries.length) { close(); return; }
      positionMenu();
      entries.forEach(function(entry) {
        var row = document.createElement("div");
        var b = document.createElement("button");
        var remove = document.createElement("button");
        var main = document.createElement("span");
        var meta = document.createElement("span");
        row.className = "sanchaya-recall-row";
        b.type = "button";
        b.className = "sanchaya-recall-item";
        b.setAttribute("role", "option");
        main.className = "find-main";
        main.textContent = entry.label;
        meta.className = "find-meta";
        meta.textContent = entry.meta || "";
        b.appendChild(main);
        if (entry.meta) b.appendChild(meta);
        b.addEventListener("mousedown", function(e) {
          e.preventDefault();
          choose(entry);
        });
        remove.type = "button";
        remove.className = "sanchaya-recall-delete";
        remove.setAttribute("aria-label", "Remove from history");
        remove.setAttribute("title", "Remove from history");
        remove.innerHTML = '<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>';
        var removed = false;
        remove.addEventListener("mousedown", function(e) {
          e.preventDefault();
          e.stopPropagation();
          options.remove(entry);
          removed = true;
        });
        remove.addEventListener("click", function(e) {
          e.preventDefault();
          e.stopPropagation();
          if (!removed) options.remove(entry);
          render(filterText);
        });
        row.appendChild(b);
        row.appendChild(remove);
        menu.appendChild(row);
      });
      menu.classList.add("open");
    }
    input.addEventListener("click", function() { render(""); });
    input.addEventListener("input", function() {
      if (document.activeElement === input) render(input.value.trim());
      else close();
    });
    input.addEventListener("keydown", function(e) {
      if (e.key === "ArrowDown" || e.key === "ArrowUp") {
        e.preventDefault();
        if (!menu.classList.contains("open")) render("");
        setActive(activeIndex + (e.key === "ArrowDown" ? 1 : -1));
      } else if (e.key === "Enter" && menu.classList.contains("open") && activeIndex >= 0) {
        e.preventDefault();
        choose(entries[activeIndex]);
      } else if (e.key === "Delete" && menu.classList.contains("open") && activeIndex >= 0) {
        e.preventDefault();
        options.remove(entries[activeIndex]);
        render(input.value.trim());
      } else if (e.key === "Escape") {
        close();
      }
    });
    document.addEventListener("mousedown", function(e) {
      if (e.target !== input && !menu.contains(e.target)) close();
    });
    window.addEventListener("resize", close);
    window.addEventListener("scroll", close, true);
    if (options.onSubmit && input.form) input.form.addEventListener("submit", options.onSubmit);
  }
  function initSimpleRecall(scope) {
    scope.querySelectorAll('form[data-sanchaya-search-form] input[name="q"]').forEach(function(input) {
      var searchMode = input.closest(".sanchaya-search-mode");
      initRecallInput(input, {
        entries: unifiedHistory,
        choose: function(entry) {
          if (entry.kind === "builder" && searchMode && searchMode.sanchayaRestoreBuilder) {
            searchMode.sanchayaRestoreBuilder(entry.state);
          } else {
            if (searchMode && searchMode.sanchayaSetAdvanced) searchMode.sanchayaSetAdvanced(false);
            input.value = entry.query;
            input.dispatchEvent(new Event("input", {bubbles: true}));
          }
        },
        remove: function(entry) { removeHistory(entry.query); },
        onSubmit: function() {
          if (searchMode && searchMode.classList.contains("advanced-open")) return;
          saveSimple(input.value.trim());
        }
      });
    });
  }
  function initAdvanced(root) {
    var filterState = {};
    var stateOrder = ["neutral", "include", "exclude"];
    var searchRoot = root.closest(".sanchaya-search-mode");
    var searchForm = searchRoot.querySelector("form[data-sanchaya-search-form]");
    var queryInput = searchForm.querySelector('input[name="q"]');
    var toggle = searchRoot.querySelector(".sanchaya-advanced-toggle");
    var without = root.querySelector(".sanchaya-adv-without");
    var iast = root.querySelector(".sanchaya-adv-iast");
    var exact = root.querySelector(".sanchaya-adv-exact");
    var regexp = root.querySelector(".sanchaya-adv-regexp");
    var caseSensitive = root.querySelector(".sanchaya-adv-case");
    var num = root.querySelector(".sanchaya-adv-num");
    var ctx = root.querySelector(".sanchaya-adv-ctx");
    var uniqueId = "sanchaya-adv-" + Math.random().toString(36).slice(2);
    var error = root.querySelector(".sanchaya-adv-error");
    var filterList = root.querySelector(".sanchaya-filter-list");
    var scopeRail = root.querySelector(".sanchaya-path-rail");
    var scopeToggle = root.querySelector(".sanchaya-scope-toggle");
    var scopeSummary = root.querySelector(".sanchaya-scope-summary");
    var scopeBackdrop = root.querySelector(".sanchaya-scope-backdrop");
    var scopeClose = root.querySelector(".sanchaya-scope-close");
    var mobileClose = root.querySelector(".sanchaya-mobile-advanced-close");
    var mobileSimple = root.querySelector(".sanchaya-mobile-simple");
    var mobileSummary = searchRoot.querySelector(".sanchaya-mobile-advanced-summary");
    var mobileSummaryText = searchRoot.querySelector(".sanchaya-mobile-summary-text");
    var generated = root.querySelector(".sanchaya-generated-query");
    var generatedCopy = root.querySelector(".sanchaya-generated-copy");

    function isMobileResult() {
      return document.body.id === "results" && window.innerWidth <= 760;
    }
    function isAdvancedParam() {
      var value = new URLSearchParams(window.location.search).get("adv");
      return value !== null && !/^(0|false|no|off)$/i.test(value);
    }
    function setAdvancedParam(open) {
      var url = new URL(window.location.href);
      if (open) {
        url.searchParams.set("adv", "1");
        if (queryInput.value.trim()) url.searchParams.set("q", queryInput.value.trim());
      } else {
        url.searchParams.delete("adv");
      }
      window.history.replaceState({}, "", url.pathname + (url.searchParams.toString() ? "?" + url.searchParams.toString() : "") + url.hash);
    }
    function setMobileEditor(open) {
      root.classList.toggle("mobile-editor-open", open);
      if (open) {
        var collapse = document.getElementById("navbar-collapse");
        var menuToggle = document.querySelector('.navbar-toggle[data-target="#navbar-collapse"]');
        if (collapse) collapse.classList.remove("in");
        if (menuToggle) {
          menuToggle.classList.add("collapsed");
          menuToggle.setAttribute("aria-expanded", "false");
        }
      }
    }

    function renderFilters() {
      filterList.innerHTML = "";
      filterDefs.forEach(function(def) {
        var label = def[0], state = filterState[label] || "neutral";
        var b = document.createElement("button");
        b.type = "button";
        b.className = "sanchaya-filter " + (state === "neutral" ? "" : state);
        b.innerHTML = '<span class="mark">' + (state === "include" ? "+" : state === "exclude" ? "-" : "") + '</span><span>' + label + '</span>';
        b.addEventListener("click", function() {
          var next = stateOrder[(stateOrder.indexOf(filterState[label] || "neutral") + 1) % stateOrder.length];
          if (next === "neutral") delete filterState[label]; else filterState[label] = next;
          renderFilters(); update();
        });
        filterList.appendChild(b);
      });
      updateScopeSummary();
    }
    root.querySelector(".sanchaya-num-history").id = uniqueId + "-num";
    root.querySelector(".sanchaya-ctx-history").id = uniqueId + "-ctx";
    num.setAttribute("list", uniqueId + "-num");
    ctx.setAttribute("list", uniqueId + "-ctx");
    function getState() {
      return {find: queryInput.value, without: without.value, iast: iast.checked, exact: exact.checked, regexp: regexp.checked, caseSensitive: caseSensitive.checked, num: num.value, ctx: ctx.value, filters: Object.assign({}, filterState)};
    }
    function renderGenerated(query) {
      generated.textContent = query || "—";
      generated.title = query || "No generated query";
      generated.setAttribute("aria-label", query ? "Generated query: " + query : "No generated query");
    }
    function applyState(saved, syncQuery, syncSource) {
      if (syncSource !== false) queryInput.value = saved.find || saved.source || "";
      without.value = saved.without || "";
      iast.checked = saved.iast !== false;
      exact.checked = !!saved.exact;
      regexp.checked = saved.regexp !== false;
      caseSensitive.checked = !!saved.caseSensitive;
      num.value = saved.num || "50";
      ctx.value = saved.ctx || "1";
      filterState = Object.assign({}, saved.filters || {});
      renderDatalist(root);
      renderFilters();
      if (syncQuery !== false) update();
      else {
        var query = buildQuery();
        renderGenerated(query);
        error.textContent = validQuery(query) ? "" : "Enter search terms with at least two visible characters.";
      }
    }
    function saveHistoryEntry(saved, query) {
      saveHistory(query, saved);
    }
    function updateScopeSummary() {
      var selected = [];
      filterDefs.forEach(function(def) {
        var state = filterState[def[0]];
        if (state) selected.push((state === "include" ? "+" : "-") + def[0]);
      });
      scopeSummary.textContent = selected.length ?
        "Scope: " + selected.slice(0, 2).join(", ") + (selected.length > 2 ? " +" + (selected.length - 2) : "") :
        "Scope";
      if (mobileSummaryText) {
        var modes = [];
        if (iast.checked) modes.push("IAST");
        if (exact.checked) modes.push("exact");
        if (regexp.checked) modes.push("regex");
        if (caseSensitive.checked) modes.push("case");
        mobileSummaryText.textContent = modes.concat(selected).join(" · ") || "Advanced search";
      }
    }
    function setScopeOpen(open) {
      scopeRail.classList.toggle("open", open);
      scopeBackdrop.classList.toggle("open", open);
      scopeToggle.setAttribute("aria-expanded", open ? "true" : "false");
    }
    function positionScopeRail() {
      if (document.body.id !== "results" || window.innerWidth <= 760 || !root.classList.contains("active")) {
        scopeRail.style.top = "";
        return;
      }
      var navbar = searchRoot.closest("nav.navbar");
      if (navbar) scopeRail.style.top = Math.ceil(navbar.getBoundingClientRect().bottom) + "px";
    }
    function buildQuery() {
      var parts = [];
      if (queryInput.value.trim()) {
        if (exact.checked && !iast.checked) parts.push(phraseToken(queryInput.value));
        else words(queryInput.value).forEach(function(v) { var a = atom(v, iast.checked); if (a) parts.push(a); });
      }
      words(without.value).forEach(function(v) { var a = atom(v, iast.checked); if (a) parts.push("-" + a); });
      var includes = [];
      filterDefs.forEach(function(def) {
        if (filterState[def[0]] === "include") includes.push(filePattern(def[1]));
        if (filterState[def[0]] === "exclude") parts.push("-file:" + filePattern(def[1]));
      });
      if (includes.length) parts.push("file:" + includes.join("|"));
      if (caseSensitive.checked) parts.push("case:yes");
      return parts.join(" ");
    }
    function update() {
      var query = buildQuery();
      var valid = validQuery(query);
      renderGenerated(query);
      error.textContent = valid ? "" : "Enter search terms with at least two visible characters.";
      saveJson(advancedDraftKey, getState());
      updateScopeSummary();
      if (searchForm.sanchayaRefreshSearchGuard) searchForm.sanchayaRefreshSearchGuard(false);
      return {query: query, valid: valid};
    }
    function defaultState(query) {
      var generatedLike = /[()|"]/.test(query);
      return {
        find: query.replace(/(^|\s)case:yes(?=\s|$)/g, " ").trim(),
        without: "",
        iast: !generatedLike,
        exact: false,
        regexp: new URLSearchParams(window.location.search).has("regexp"),
        caseSensitive: /(^|\s)case:yes(\s|$)/.test(query),
        num: new URLSearchParams(window.location.search).get("num") || "50",
        ctx: new URLSearchParams(window.location.search).get("ctx") || "1",
        filters: {}
      };
    }
    function hydrateCurrentQuery() {
      var currentQuery = queryInput.value.trim();
      var plain = currentQuery && !/(^|\s)-?[A-Za-z_][A-Za-z0-9_-]*:|[()|"]/.test(currentQuery);
      var match = loadUnifiedHistory().filter(function(entry) {
        return entry.query === currentQuery && entry.state;
      })[0];
      if (plain) applyState(defaultState(currentQuery), false);
      else if (match) applyState(match.state, false);
      else if (currentQuery) applyState(defaultState(currentQuery), false);
      else applyState(loadJson(advancedDraftKey, defaultState("")), false);
    }
    searchRoot.sanchayaGetAdvancedQuery = function() {
      return root.classList.contains("active") ? buildQuery() : "";
    };
    function setOpen(open, focusField, updateUrl) {
      root.classList.toggle("active", open);
      searchRoot.classList.toggle("advanced-open", open);
      document.body.classList.toggle("sanchaya-advanced-active", open);
      toggle.classList.toggle("active", open);
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
      queryInput.readOnly = false;
      if (updateUrl !== false) setAdvancedParam(open);
      if (searchForm.sanchayaRefreshSearchGuard) searchForm.sanchayaRefreshSearchGuard(false);
      if (!open) {
        setScopeOpen(false);
        setMobileEditor(false);
      }
      if (open) {
        if (queryInput.sanchayaRecallClose) queryInput.sanchayaRecallClose();
        requestAnimationFrame(positionScopeRail);
        if (isMobileResult()) setMobileEditor(focusField !== false);
        if (focusField !== false && !isMobileResult()) queryInput.focus();
      }
    }
    root.querySelector(".sanchaya-filter-clear").addEventListener("click", function() { filterState = {}; renderFilters(); update(); });
    scopeToggle.addEventListener("click", function() { setScopeOpen(!scopeRail.classList.contains("open")); });
    scopeClose.addEventListener("click", function() { setScopeOpen(false); });
    scopeBackdrop.addEventListener("click", function() { setScopeOpen(false); });
    window.addEventListener("resize", positionScopeRail);
    window.addEventListener("scroll", positionScopeRail);
    root.querySelectorAll("input").forEach(function(el) {
      el.addEventListener("input", update);
      el.addEventListener("change", update);
    });
    queryInput.addEventListener("input", function() {
      if (root.classList.contains("active")) update();
    });
    initRecallInput(without, {
      entries: withoutHistoryEntries,
      choose: function(entry) {
        without.value = entry.value;
        without.dispatchEvent(new Event("input", {bubbles: true}));
      },
      remove: function(entry) { removeWithoutHistory(entry.value); }
    });
    searchRoot.sanchayaSetAdvanced = function(open) { setOpen(open, false); };
    searchRoot.sanchayaRestoreBuilder = function(saved) {
      applyState(saved, true);
      setOpen(true, false);
    };
    toggle.addEventListener("click", function() {
      if (root.classList.contains("active") && isMobileResult()) {
        setMobileEditor(!root.classList.contains("mobile-editor-open"));
        return;
      }
      var opening = !root.classList.contains("active");
      if (opening) hydrateCurrentQuery();
      setOpen(opening, true);
    });
    if (mobileSummary) mobileSummary.addEventListener("click", function() { setMobileEditor(true); });
    if (mobileClose) mobileClose.addEventListener("click", function() { setMobileEditor(false); });
    if (mobileSimple) mobileSimple.addEventListener("click", function() { setOpen(false, false); });
    generatedCopy.addEventListener("click", function() {
      var value = buildQuery();
      if (!value) return;
      function copied() {
        generatedCopy.setAttribute("title", "Copied");
        setTimeout(function() { generatedCopy.setAttribute("title", "Copy generated query"); }, 1200);
      }
      function fallbackCopy() {
        var area = document.createElement("textarea");
        area.value = value;
        area.style.position = "fixed";
        area.style.opacity = "0";
        document.body.appendChild(area);
        area.focus();
        area.select();
        try { document.execCommand("copy"); copied(); } catch (e) {}
        document.body.removeChild(area);
      }
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(value).then(copied).catch(fallbackCopy);
        return;
      }
      fallbackCopy();
    });
    var mobileMenuToggle = document.querySelector('.navbar-toggle[data-target="#navbar-collapse"]');
    if (mobileMenuToggle) mobileMenuToggle.addEventListener("click", function() { setMobileEditor(false); });
    searchForm.addEventListener("submit", function(e) {
      if (!root.classList.contains("active")) return;
      e.preventDefault();
      var state = update();
      if (!state.valid || !state.query) return;
      var saved = getState();
      saveOptionHistory(saved);
      saveWithoutHistory(saved.without);
      saveSimple(state.query);
      saveHistoryEntry(saved, state.query);
      var params = new URLSearchParams();
      params.set("q", state.query);
      if (saved.num) params.set("num", saved.num);
      if (saved.ctx) params.set("ctx", saved.ctx);
      if (saved.regexp) params.set("regexp", "on");
      params.set("adv", "1");
      window.location.href = "/search?" + params.toString();
    });
    var urlQuery = new URLSearchParams(window.location.search).get("q");
    if (urlQuery && !queryInput.value.trim()) queryInput.value = urlQuery;
    var initialOpen = isAdvancedParam();
    applyState(loadJson(advancedDraftKey, {iast: true, regexp: true, num: "50", ctx: "1", filters: {}}), false, false);
    renderDatalist(root);
    renderFilters();
    if (initialOpen) hydrateCurrentQuery();
    setOpen(initialOpen, false, false);
  }
  function initModes(scope) {
    scope.querySelectorAll(".sanchaya-search-mode").forEach(function(root) {
      if (root.dataset.ready) return;
      root.dataset.ready = "1";
      var advancedPanel = root.querySelector(".sanchaya-advanced-panel");
      initAdvanced(advancedPanel);
    });
  }
  document.addEventListener("DOMContentLoaded", function() {
    initModes(document);
    initSimpleRecall(document);
    if (document.body.id === "results") {
      var currentQuery = new URLSearchParams(window.location.search).get("q");
      if (currentQuery) saveSimple(currentQuery);
    }
  });
})();
</script>
{{end}}

{{define "advancedSearchWidget"}}
<div class="sanchaya-advanced-panel">
  <div class="sanchaya-mobile-advanced-head">
    <strong>Advanced search</strong>
    <div>
      <button class="sanchaya-link-button sanchaya-mobile-simple" type="button">Simple</button>
      <button class="btn btn-default btn-xs sanchaya-mobile-advanced-close" type="button" aria-label="Close advanced editor">
        <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
      </button>
    </div>
  </div>
  <div class="sanchaya-advanced-grid">
    <div class="sanchaya-advanced-main">
      <div class="sanchaya-adv-toolbar">
        <div class="sanchaya-adv-without-control">
          <label for="sanchaya-adv-without">Without</label>
          <input id="sanchaya-adv-without" class="form-control input-sm sanchaya-adv-without" placeholder="रामः कृष्णः">
        </div>
        <div class="sanchaya-adv-options">
          <label><input class="sanchaya-adv-iast" type="checkbox"> IAST</label>
          <label><input class="sanchaya-adv-exact" type="checkbox"> exact</label>
          <label><input class="sanchaya-adv-regexp" type="checkbox"> regex</label>
          <label><input class="sanchaya-adv-case" type="checkbox"> case</label>
          <span class="sanchaya-mini-field">results <input class="form-control sanchaya-adv-num" inputmode="numeric" list="sanchaya-num-history"><datalist class="sanchaya-num-history"></datalist></span>
          <span class="sanchaya-mini-field">context <input class="form-control sanchaya-adv-ctx" inputmode="numeric" list="sanchaya-ctx-history"><datalist class="sanchaya-ctx-history"></datalist></span>
          <button class="btn btn-default btn-xs sanchaya-scope-toggle" type="button">
            <span class="glyphicon glyphicon-filter" aria-hidden="true"></span>
            <span class="sanchaya-scope-summary">Scope</span>
          </button>
        </div>
      </div>
      <div class="sanchaya-adv-error"></div>
      <div class="sanchaya-generated-row">
        <label for="sanchaya-generated-query">Generated query</label>
        <div class="sanchaya-generated-value">
          <code class="sanchaya-generated-query" id="sanchaya-generated-query" aria-live="polite">—</code>
          <button class="btn btn-default btn-xs sanchaya-generated-copy" type="button"
                  title="Copy generated query" aria-label="Copy generated query">
            <span class="glyphicon glyphicon-copy" aria-hidden="true"></span>
          </button>
        </div>
      </div>
    </div>
    <div class="sanchaya-scope-backdrop"></div>
    <div class="sanchaya-path-rail">
      <div class="sanchaya-path-head">
        <h4>Scope · File / Path</h4>
        <div>
          <button class="sanchaya-link-button sanchaya-filter-clear" type="button">clear</button>
          <button class="btn btn-default btn-xs sanchaya-scope-close" type="button"
                  aria-label="Close scope">
            <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
          </button>
        </div>
      </div>
      <div class="sanchaya-filter-list"></div>
    </div>
  </div>
</div>
<button class="sanchaya-mobile-advanced-summary" type="button" aria-label="Edit advanced search">
  <span class="sanchaya-mobile-summary-text">Advanced search</span>
  <span class="sanchaya-link-button">Edit</span>
</button>
{{end}}
