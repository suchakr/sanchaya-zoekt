{{define "searchGuardAssets"}}
<style>
  .sanchaya-search-guard {
    color: #a94442;
    margin-bottom: 0;
  }
</style>
<script>
(function() {
  var message = "Enter a search term with at least two visible characters.";
  var qualifierPattern = /^([A-Za-z_][A-Za-z0-9_-]*):(.*)$/;

  function visibleUnitCount(text) {
    if (window.Intl && Intl.Segmenter) {
      var segmenter = new Intl.Segmenter(undefined, {granularity: "grapheme"});
      var count = 0;
      var segments = segmenter.segment(text);
      for (var iterator = segments[Symbol.iterator](), step; !(step = iterator.next()).done;) {
        count++;
      }
      return count;
    }
    return Array.from(text).length;
  }

  function tokenize(query) {
    var tokens = [];
    var token = "";
    var quote = "";

    for (var i = 0; i < query.length; i++) {
      var ch = query[i];
      if (quote) {
        if (ch === quote) {
          quote = "";
        } else {
          token += ch;
        }
      } else if (ch === '"' || ch === "'") {
        quote = ch;
      } else if (/\s/.test(ch)) {
        if (token) {
          tokens.push(token);
          token = "";
        }
      } else {
        token += ch;
      }
    }

    if (token) {
      tokens.push(token);
    }
    return tokens;
  }

  function searchQueryIsValid(query) {
    var tokens = tokenize(query.trim());
    var hasPositiveSearchTerm = false;
    var positiveSearchTermsAreValid = true;
    var hasLongStandaloneQualifier = false;

    tokens.forEach(function(rawToken) {
      var token = rawToken;
      var negative = false;

      while (token.charAt(0) === "-") {
        negative = true;
        token = token.slice(1);
      }
      if (!token || /^(and|or)$/i.test(token)) {
        return;
      }

      var qualifier = token.match(qualifierPattern);
      if (qualifier) {
        if (!negative && visibleUnitCount(qualifier[2].trim()) >= 2) {
          hasLongStandaloneQualifier = true;
        }
        return;
      }

      if (!negative) {
        hasPositiveSearchTerm = true;
        if (visibleUnitCount(token) >= 2) {
          return;
        }
        positiveSearchTermsAreValid = false;
      }
    });

    if (hasPositiveSearchTerm) {
      return positiveSearchTermsAreValid;
    }
    return hasLongStandaloneQualifier;
  }

  function updateForm(form, showMessage) {
    var input = form.querySelector('input[name="q"]');
    var button = form.querySelector('button[type="submit"], button:not([type])');
    var guard = form.querySelector(".sanchaya-search-guard");
    if (!input || !button) {
      return true;
    }

    var query = input.value.trim();
    var valid = searchQueryIsValid(query);
    button.disabled = !valid;
    input.setAttribute("aria-invalid", valid ? "false" : "true");
    if (guard) {
      guard.textContent = !valid && (showMessage || query) ? message : "";
    }
    return valid;
  }

  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll("form[data-sanchaya-search-form]").forEach(function(form) {
      var input = form.querySelector('input[name="q"]');
      if (!input) {
        return;
      }

      updateForm(form, false);
      input.addEventListener("input", function() {
        updateForm(form, false);
      });
      form.addEventListener("submit", function(event) {
        if (!updateForm(form, true)) {
          event.preventDefault();
          input.focus();
        }
      });
    });
  });
})();
</script>
{{end}}
