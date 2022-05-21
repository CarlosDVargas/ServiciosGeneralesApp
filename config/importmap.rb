# Pin npm packages by running ./bin/importmap

pin "application", preload: false
pin "app/javascript/es-module-shims.js", to: "es-module-shims.js", preload: false
pin "react", to: "https://ga.jspm.io/npm:react@17.0.2/index.js", preload: false
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: false
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: false
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: false
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
