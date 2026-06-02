
<form action="search" data-sanchaya-search-form>
  <div class="form-group form-group-lg">
    <div class="input-group input-group-lg">
      <input class="form-control" placeholder="Search Sanskrit and Indic texts..." autofocus
              {{if .Query}}
              value={{.Query}}
              {{end}}
              id="searchbox" type="text" name="q">
      <div class="input-group-btn">
        <button class="btn btn-primary">Search</button>
      </div>
    </div>
    <p class="help-block sanchaya-search-guard" aria-live="polite"></p>
  </div>
</form>
