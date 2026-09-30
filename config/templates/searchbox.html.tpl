<div class="sanchaya-search-mode">
  <div class="sanchaya-simple-panel">
    <form action="search" data-sanchaya-search-form>
      <div class="form-group form-group-lg">
        <div class="sanchaya-search-row">
          <div class="sanchaya-search-field">
          <input class="form-control" placeholder="Search terms..." autofocus
                  {{if .Query}}
                  value="{{.Query}}"
                  {{end}}
                  id="searchbox" type="text" name="q">
            <button class="btn btn-default sanchaya-advanced-toggle" type="button"
                    title="Advanced search" aria-label="Advanced search" aria-expanded="false">
              <span class="glyphicon glyphicon-filter" aria-hidden="true"></span>
            </button>
          </div>
          <button class="btn btn-primary sanchaya-search-submit" type="submit">Search</button>
          </div>
        <p class="help-block sanchaya-search-guard" aria-live="polite"></p>
      </div>
    </form>
  </div>
  {{template "advancedSearchWidget"}}
</div>
